//
//  cityTourViewController.m
//  cityTour
//
//  Created by David Yatom on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Museum.h"
#import "RootViewController.h"
#import <Foundation/Foundation.h>
#import "AboutViewController.h"
#import "Helper.h"
@class Museum;
@implementation RootViewController

@synthesize aboutViewController;
@synthesize museumsTableVIew;
@synthesize museumsArray;
@synthesize currentMuseumName;
@synthesize currentMuseumCity; 
@synthesize currentMuseumImageUrl ;
@synthesize currentMuseumID;
@synthesize currentMuseumDescription;
@synthesize museum;
@synthesize museumListConnection;
@synthesize museumListData;
@synthesize parser;
@synthesize currentElement;
@synthesize nodeName;
@synthesize museumInfoViewController;
@synthesize currentMuseumImageName;
@synthesize imageCache;
#define USE_CUSTOM_DRAWING 1

#pragma mark Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Museum *tmpMuseum = [museumsArray objectAtIndex:indexPath.row];
    [self loadImageInBackground:tmpMuseum];
#if USE_CUSTOM_DRAWING
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	UILabel *bottomLabel;
#endif
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		//
		// Create the cell.
		//
		cell =
        [[[UITableViewCell alloc]
          initWithFrame:CGRectZero
          reuseIdentifier:CellIdentifier]
         autorelease];
        
#if USE_CUSTOM_DRAWING
		UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
		cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
		
		const CGFloat LABEL_HEIGHT = 20;
		UIImage *image = [UIImage imageNamed:@"imageA.png"];
        
		//
		// Create the label for the top row of text
		//
		topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:topLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
		//
		// Create the label for the top row of text
		//
		bottomLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:bottomLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.tag = BOTTOM_LABEL_TAG;
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
        
		//
		// Create a background image view.
		//
		cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
        [[[UIImageView alloc] init] autorelease];
#endif
	}
    
#if USE_CUSTOM_DRAWING
	else
	{
		topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}
	
	topLabel.text = tmpMuseum.museumName;
	bottomLabel.text = tmpMuseum.museumCity;
	
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
    cell.image = tmpMuseum.thumbImage;
#else
	cell.text = [NSString stringWithFormat:@"Cell at row %ld.", [indexPath row]];
#endif
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [museumsArray count];
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    self.imageCache = [[NSMutableDictionary alloc]init];
    museumsTableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
	museumsTableVIew.rowHeight = 100;
	museumsTableVIew.backgroundColor = [UIColor clearColor];
    
	self.title =@"ArtPhone";
    
    //
	// Create a header view. Wrap it in a container to allow us to position
	// it better.
	//
	UIView *containerView =
    [[[UIView alloc]
      initWithFrame:CGRectMake(0, 0, 300, 60)]
     autorelease];
	UILabel *headerLabel =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(10, 20, 300, 40)]
     autorelease];
	headerLabel.text = NSLocalizedString(@"Museum list", @"");
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:22];
	headerLabel.backgroundColor = [UIColor clearColor];
	[containerView addSubview:headerLabel];
	self.museumsTableVIew.tableHeaderView = containerView;
	

    NSString *url =[Helper getAllMuseumsDBURL];
    
	NSLog(@" taking xml feed from this url : %@",url);
	
	NSString *fileNPath = [[NSBundle mainBundle ] pathForResource:@"GetAllMuseums" ofType:@"xml"];
	
	NSData *fileData = [NSData dataWithContentsOfFile:fileNPath];
	NSString *postData = [[NSString alloc] initWithData:fileData encoding:NSASCIIStringEncoding]; 
	NSLog(@"post data is : %@",postData);
	
	
	NSMutableURLRequest *museumListRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[museumListRequest setHTTPMethod:@"POST"];
	[museumListRequest setValue:@"application/soap+xml" forHTTPHeaderField:@"content-type"];
	[museumListRequest setHTTPBody:[postData dataUsingEncoding: NSASCIIStringEncoding]];	
	[museumListRequest setURL:[NSURL URLWithString:url]];
	countMuseums = 0;
	
	
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:museumListRequest
                                                          delegate:self];
    self.museumListConnection = conn;
	
	NSAssert(self.museumListConnection != nil, @"Failure to create URL connection.");
	
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

    if (infoButton==nil)
        infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    if (addButton == nil)
        addButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton] ;
    
   
     [addButton setTitle:@"QR"];
     self.navigationItem.rightBarButtonItem = addButton;
     self.navigationItem.rightBarButtonItem.enabled = YES;
     self.navigationItem.rightBarButtonItem.target  = self;
     [infoButton addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
 
 
    /*
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIBarButtonItem *infoButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];

    
    // [addButton setTitle:@"about"];
     self.navigationItem.rightBarButtonItem = infoButtonItem;
     self.navigationItem.rightBarButtonItem.enabled = YES;
     self.navigationItem.rightBarButtonItem.target  = self;
     self.navigationItem.rightBarButtonItem.action = @selector(showAbout);
   */
}

- (IBAction)showAbout {
    
    NSLog(@"You touched me THERE!");

    [UIView beginAnimations: @"Showinfo" context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.50];
    
    if (self.aboutViewController == nil) {
        self.aboutViewController = [[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]] autorelease];        
    }
    
    
    aboutViewController.navigationController = self.navigationController;
    [self.navigationController pushViewController:aboutViewController animated:YES]; 
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}
/***** Connection stuf ***************************/

//
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // check for HTTP status code for proxy authentication failures
    // anything in the 200 to 299 range is considered successful,
    // also make sure the MIMEType is correct:
    //
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
	NSLog(@"response is an http response");
	NSInteger rc = [((NSHTTPURLResponse*) response) statusCode];
	NSLog(@"status code: %d", rc);
	
    
	
    if ([httpResponse statusCode] == 200){
		
        self.museumListData = [NSMutableData data];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        //		NSLog([NSString stringWithContentsOfURL:httpResponse ]);
        [self handleError:error];
    }
}


// Appending data after all date recived wihtout prolbmes
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[museumListData appendData:data];
}


// we have problem with the connection
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:
         NSLocalizedString(@"No Connection Error",
                           @"Error message displayed when not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    } else {
        // otherwise handle the error generically
        [self handleError:error];
    }
    self.museumListData = nil;
}

//Sent when a connection has finished loading successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.museumListConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    
	parser = [[NSXMLParser alloc] initWithData:self.museumListData];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
    [parser parse];
    
    [museumsTableVIew reloadData];
    // data will be retained by the NSOperation until it has finished executing,
    // so we no longer need a reference to it in the main thread.
	
    self.museumListData = nil;
}


// Parsing Error
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to read feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	[self handleError:parseError];
}

//Sent by a parser object to its delegate when it encounters a start tag for a given element.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    NSLog(@"found this element: %@", elementName);
	self.nodeName =@"Table";
	NSLog(@"Node name is : %@",nodeName);
    
	currentElement = [elementName copy];
	if ([elementName isEqualToString: nodeName]) {
		NSLog(@"===- StartElement was found -===");
		Museum *museumInstance = [[Museum alloc]init];
		self.museum = museumInstance;
		[museumInstance release];
		
		currentMuseumName = [[NSMutableString alloc]init];
		currentMuseumImageUrl = [[NSMutableString alloc]init];
		currentMuseumCity = [[NSMutableString alloc]init];
		currentMuseumID = [[NSMutableString alloc]init];
		currentMuseumDescription = [[NSMutableString alloc]init];
	}
}

//Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"MusuemName"]) 
	{
		NSLog(@"## Museum name was Found : %@",string);
		[currentMuseumName appendString:string];
	}
	
     else if ([currentElement isEqualToString:@"MuseumCity"]) 
     {
     NSLog(@"Museum city tag was Found");
     [currentMuseumCity appendString:string];
     }
     
     
     else if ([currentElement isEqualToString:@"ImageName"]) 
     {
     NSLog(@"ImageName was Found");		
     [currentMuseumImageName appendString:string];
     }

	else if ( [currentElement isEqualToString:@"ID"])
	{
		NSLog(@"## Museum ID was found: %@",string);
		[currentMuseumID appendString:string];
	}
	else if ([currentElement isEqualToString:@"Description"])
	{
		NSLog(@"## Description was found : %@",string);
		[currentMuseumDescription appendString:string];
	}
    

}

//Sent by a parser object to its delegate when it encounters an end tag for a specific element.

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);
	
	// node name to parse from XML is : Table
	if ([elementName isEqualToString:self.nodeName]) {
		// save values to an item, then store that item into the array...
		
		NSLog(@" ===- End Elemet was found -===");
        
		self.museum.museumDescription = currentMuseumDescription;
		self.museum.museumName = currentMuseumName;
		self.museum.museumID = currentMuseumID;
        self.museum.museumImageName = currentMuseumImageName;
        self.museum.museumCity = currentMuseumCity;
        
        /*
        NSMutableString *imageUrl = [[NSMutableString alloc]initWithString:@"http://db.cs.colman.ac.il/mcm/pages/getmuseumimage.aspx?id="];
        [imageUrl appendString:self.museum.museumID];
        [imageUrl appendString: @"&Height=250&Width=250"];
        NSLog(imageUrl);
        self.museum.museumImageURL = imageUrl;
        
        [imageUrl release];
         
		*/
		
		if (museumsArray == nil)
			museumsArray = [[NSMutableArray alloc]init];
		
		[self.museumsArray addObject:self.museum]; 
		
		countMuseums = countMuseums + 1;
		self.museum = nil;
        
	}
	
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	NSLog(@"Parsing is done!");
	NSLog(@"Number of Museums(museumsArray) parsed is  %d ", [museumsArray count]);
	
	
	NSLog(@"Reloading DATA");
	NSLog(@"Parser count %d Museums",countMuseums);
	
	[self PrintMuseumList:@"aaa"];
	//[museumsTableVIew reloadData];
    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    NSLog(@"RootVC dealloc() ");
	self.museumsTableVIew = nil;
    self.museumsArray=nil;
    self.museumListData = nil;
    self.museumListConnection =nil;
    self.parser =nil;
    self.currentElement =nil;
    self.nodeName =nil;
    self.museum = nil;
    self.currentMuseumImageName=nil;
    self.currentMuseumCity=nil;
    self.currentMuseumImageName=nil;
    self.currentMuseumImageUrl=nil;
    self.currentMuseumID=nil;
    self.currentMuseumDescription=nil;
    self.helper =nil;
    self.imageCache = nil;
    [infoButton release];
    [addButton release];
    
	[super dealloc];
    

}


-(void)PrintMuseumList :(NSString*) str{
	
	NSLog(@"Printing all the museum");
	
    if(museumsArray==NULL)
    {
        NSLog(@"MuseumArray is null");
    }
	for (int i=0; i< [museumsArray count]; i++) {
		NSLog(@"instance number :%d",i+1);
		NSLog(@"Museum Name %@", [[museumsArray objectAtIndex:i] museumName] );
		NSLog(@"Museum museumImageNameL %@", [[museumsArray objectAtIndex:i] museumImageName] );
        NSLog(@"Museum museumImageUrl %@",[[museumsArray objectAtIndex:i] museumImageURL]);
		NSLog(@"Museum museumPicture %@", [[museumsArray objectAtIndex:i] museumPicture] );
		NSLog(@"Museum museumCity %@", [[museumsArray objectAtIndex:i] museumCity] );
		NSLog(@"Museum museumDescription %@", [[museumsArray objectAtIndex:i] museumDescription] );
		NSLog(@"Museum museumID %@", [[museumsArray objectAtIndex:i] museumID] );
		NSLog(@"----------");
        
	}
	
	
}
#pragma ViewControllerStuff

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    /*
    UITabBarController *tabController = [[[UITabBarController alloc] initWithNibName:@"MuseumInfoViewController" bundle:[NSBundle mainBundle]] autorelease];  
    
    */
	if (self.museumInfoViewController == nil) {
        self.museumInfoViewController = [[[MuseumInfoViewController alloc] initWithNibName:@"MuseumInfoViewController" bundle:[NSBundle mainBundle]] autorelease];        
    }
    
    
    Museum *museum = [museumsArray objectAtIndex:indexPath.row];
    NSLog(@"museum name is %@",museum.museumName);
    museumInfoViewController.museum= museum;
    museumInfoViewController.navigationController = self.navigationController;
    [self.navigationController pushViewController:museumInfoViewController animated:YES]; 
    
}


- (void) loadImageInBackground: (Museum*) tmpMuseum{
    
    NSLog(@"loadImageInBackground()...");
    
    UIImage *imgFromCache;
    imgFromCache = [self.imageCache objectForKey:tmpMuseum.museumID];
    if (imgFromCache != nil)
    {
        tmpMuseum.thumbImage = imgFromCache;
        NSLog(@"brought image from cache!");
        return;
    }
	// Create a pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSMutableString *itemImageURL = [[NSMutableString alloc] initWithString:@"http://db.cs.colman.ac.il/mcm/pages/getmuseumimage.aspx?id="];

    NSMutableString *itemImageURL = [[NSMutableString alloc]initWithString:[Helper getServerURL]];
    [itemImageURL appendString:[Helper getMuseumImagePath]];
    
    if(tmpMuseum==nil)
        NSLog(@"museum is nil");
    if(tmpMuseum==nil)
        NSLog(@"museum id is nil");
    
    [itemImageURL appendString:tmpMuseum.museumID];
    [itemImageURL appendString:@"&Height="];
    [itemImageURL appendString: [Helper getThumbImageHeight]];
    [itemImageURL appendString :@"&Width="];
    [itemImageURL appendString:[Helper getThumbImageWidth]];
    
   // tmpMuseum.museumImageURL = itemImageURL;
    
    NSLog(@"IMAGE TO FETCH from :%@",itemImageURL);
 	// Retrieve the remote image
	NSURL *imgURL = [NSURL URLWithString:itemImageURL];
	NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
	UIImage *img    = [[UIImage alloc] initWithData:imgData];
    
    [self.imageCache setValue:img forKey:tmpMuseum.museumID];
    tmpMuseum.thumbImage = img;
    
	// Image retrieved, call main thread method to update image, passing it the downloaded UIImage
	//[self performSelectorOnMainThread:@selector(assignImageToImageView:) withObject:img waitUntilDone:YES];
    
	// clean up
	[pool release];
    
}

@end
