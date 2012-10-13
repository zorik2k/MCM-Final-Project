//
//  ItemsTable.m
//  MCM-Final Project
//
//  Created by Zorik on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemsTable.h"
#import "Museum.h"
#import "MuseumItem.h"
#import "ItemDetails.h"
#import "Helper.h"

@implementation ItemsTable
#define USE_CUSTOM_DRAWING 1

@synthesize currentMuseum;
@synthesize item;
@synthesize navigationController;
@synthesize itemsTable;
@synthesize itemsArray;
@synthesize museumItemConnection;
@synthesize museumItemData;
@synthesize parser;
@synthesize currentElement;
@synthesize nodeName;

@synthesize currentitemName;
@synthesize currentitemDescription;
@synthesize currentimageID;
@synthesize currentYTID;
@synthesize currentembedCode;
@synthesize currentyoutubeVideoName;
@synthesize currentObjectID;
@synthesize qrViewController;
@synthesize imageCache;

-(void)viewWillAppear:(BOOL)animated
{
    self.title = self.currentMuseum.museumName;
    
    /*
    UIBarButtonItem     *addButton = [[UIBarButtonItem alloc] init];
    [addButton setTitle:@"QR"];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.target  = self;
    self.navigationItem.rightBarButtonItem.action = @selector(mySelector:);
    */
    
    
}

-(IBAction) QRButtongWasPressed{
    
    if (self.qrViewController == nil) {
        self.qrViewController = [[[ReaderSampleViewController alloc] initWithNibName:@"ReaderSampleViewController" bundle:[NSBundle mainBundle]] autorelease];        
    }
    
    qrViewController.navigationController = self.navigationController;
    qrViewController.itemsArray = self.itemsArray;
    for( int i =0 ; i< [self.itemsArray count] ;i++)
    {
        MuseumItem *tmp =[self.itemsArray objectAtIndex:i];
        NSLog(@"%@",tmp.itemName);
    }
    [self.navigationController pushViewController:qrViewController animated:YES]; 
    
}

/*
- (IBAction)mySelector:(id)sender {
    NSLog(@"You touched me THERE!");
    
    if (self.qrViewController == nil) {
        self.qrViewController = [[[ReaderSampleViewController alloc] initWithNibName:@"ReaderSampleViewController" bundle:[NSBundle mainBundle]] autorelease];        
    }
    
    qrViewController.navigationController = self.navigationController;
    qrViewController.itemsArray = self.itemsArray;
    for( int i =0 ; i< [self.itemsArray count] ;i++)
    {
        MuseumItem *tmp =[self.itemsArray objectAtIndex:i];
        NSLog(@"%@",tmp.itemName);
    }
    [self.navigationController pushViewController:qrViewController animated:YES]; 
    
    
}
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ItemTable dealloc() start");
    self.currentMuseum=nil; ;
    self.item=nil;
    self.navigationController = nil;
    self.itemsArray =nil;
    self.currentitemName=nil;
    self.currentitemDescription=nil;
    self.currentimageID=nil;
    self.currentYTID=nil;
    self.currentembedCode=nil;
    self.currentyoutubeVideoName=nil;
    self.museumItemConnection =nil;
    self.museumItemData= nil;
    self.parser =nil;
    self.currentElement =nil ;
    self.nodeName =nil;
    self.itemsTable=nil;
    self.currentObjectID = nil;
    self.currentQRID=nil;
    

    [super dealloc];
    NSLog(@"ItemTable dealloc() done");

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageCache = [[NSMutableDictionary alloc]init];
    itemsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	itemsTable.rowHeight = 100;
	itemsTable.backgroundColor = [UIColor clearColor];
    
    
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
	headerLabel.text = NSLocalizedString(@"Items", @"");
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:22];
	headerLabel.backgroundColor = [UIColor clearColor];
	[containerView addSubview:headerLabel];
	self.itemsTable.tableHeaderView = containerView;
    
	self.title =@"MCM";
	
    NSString *url =[Helper getAllItemsDBURL];
    
	NSLog(@" The url is : %@",url);
	
	NSString *fileNPath = [[NSBundle mainBundle ] pathForResource:@"GetAllMuseumItems" ofType:@"xml"];
	
	NSData *fileData = [NSData dataWithContentsOfFile:fileNPath];
	NSString *postData = [[NSString alloc] initWithData:fileData encoding:NSASCIIStringEncoding];
    
    postData = [postData stringByReplacingOccurrencesOfString:@"{{IDINJECT}}" withString:self.currentMuseum.museumID];
    //stringByReplacingOccurrencesOfString
    
	NSLog(@"post data is : %@",postData);
	
	
	NSMutableURLRequest *museumItemsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[museumItemsRequest setHTTPMethod:@"POST"];
	[museumItemsRequest setValue:@"application/soap+xml" forHTTPHeaderField:@"content-type"];
	[museumItemsRequest setHTTPBody:[postData dataUsingEncoding: NSASCIIStringEncoding]];	
	[museumItemsRequest setURL:[NSURL URLWithString:url]];
	
	
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:museumItemsRequest
                                                          delegate:self];
    self.museumItemConnection = conn;
	
	NSAssert(self.museumItemConnection != nil, @"Failure to create URL connection.");
}



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
		
        self.museumItemData = [NSMutableData data];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
      
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        
        NSLog([NSString stringWithContentsOfURL:httpResponse ]);
        
        [self handleError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[museumItemData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.museumItemConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    
	parser = [[NSXMLParser alloc] initWithData:self.museumItemData];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
    [parser parse];
    
    [self.itemsTable reloadData];
    //[museumsTableVIew reloadData];
    // data will be retained by the NSOperation until it has finished executing,
    // so we no longer need a reference to it in the main thread.
	
    self.museumItemData = nil;
}


// Parsing Error
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to read feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	[self handleError:parseError];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) handleError:(NSError *)error{
    
    [Helper handleError:error];

}

//parser operation


//Sent by a parser object to its delegate when it encounters a start tag for a given element.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    NSLog(@"found this element: %@", elementName);
	self.nodeName =@"Table";
	NSLog(@"Node name is : %@",nodeName);
    
	currentElement = [elementName copy];
	if ([elementName isEqualToString: nodeName]) {
		NSLog(@"===- StartElement was found -===");
		MuseumItem *itemInstance = [[MuseumItem alloc]init];
		self.museumItemData = itemInstance;
		[itemInstance release];
		
		currentitemName = [[NSMutableString alloc]init];
		currentitemDescription = [[NSMutableString alloc]init];
       currentimageID = [[NSMutableString alloc]init];
        currentyoutubeVideoName  = [[NSMutableString alloc]init];
		currentYTID = [[NSMutableString alloc]init];
        currentembedCode = [[NSMutableString alloc]init];
        currentObjectID = [[NSMutableString alloc] init];
        currentQRID = [[NSMutableString alloc] init];
	}
}

//Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"objectName"]) 
	{
		NSLog(@"## Object name was Found : %@",string);
		[currentitemName appendString:string];
	}
	
    else if ([currentElement isEqualToString:@"ImageID"]) 
    {
        NSLog(@"Image ID was Found");
        [currentimageID appendString:string];
    }
    
    
    else if ([currentElement isEqualToString:@"Description"]) 
    {
        NSLog(@"Description was Found");		
        [currentitemDescription appendString:string];
    }
    
	else if ([currentElement isEqualToString:@"YTID"])
	{
		NSLog(@"## You Tube ID was found: %@",string);
		[currentYTID appendString:string];
	}
	else if ([currentElement isEqualToString:@"EmbedCode"])
	{
		NSLog(@"## EmbedCode was found : %@",string);
		[currentembedCode appendString:string];
	}
    else if ([currentElement isEqualToString:@"VideoName"])
	{
		NSLog(@"## VideoName was found : %@",string);
		[currentyoutubeVideoName appendString:string];
	}
    
    else if ([currentElement isEqualToString:@"ObjectID"])  
	{
		NSLog(@"## ObjectID was found : %@",string);
		[currentObjectID appendString:string];
	}
    
    else if ([currentElement isEqualToString:@"itemNumber"])  
	{
		NSLog(@"## QRID was found : %@",string);
		[currentQRID appendString:string];
	}
    
    
    
}

//Sent by a parser object to its delegate when it encounters an end tag for a specific element.

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);
	
	// node name to parse from XML is : Table
	if ([elementName isEqualToString:self.nodeName]) {
		// save values to an item, then store that item into the array...
		
		NSLog(@" ===- End Elemet was found -===");
        self.item = [[MuseumItem alloc]init];
		 self.item.itemDescription  = currentitemDescription;
        self.item.itemName = currentitemName;
        self.item.imageID = currentimageID;
        self.item.youtubeVideoName = currentyoutubeVideoName;
        self.item.YTID = currentYTID;
        self.item.embedCode = currentembedCode;
        self.item.objectID = currentObjectID;
        self.item.itemQRID = currentQRID;
		
        //	museum.museumImageURL = currentMuseumImageUrl;
        //	museum.museumCity = currentMuseumCity;
		
		
		if (itemsArray == nil)
        {
            NSLog(@"Allocating the items array");
			//self.itemsArray =  [[NSMutableArray alloc]init];
            self.itemsArray = [[NSMutableArray alloc]initWithObjects:self.item, nil];
        }
        else
        {
            NSLog(@"adding to items array the item: @%",self.item);
            [self.itemsArray addObject: item ]; 
        }
                
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	NSLog(@"Parsing is done!");
	NSLog(@"Number of items parsed is  %d ", [itemsArray count]);
	
    
    [itemsTable reloadData];
	//[museumsTableVIew reloadData];
    //NSLog(@"Reloading DATA");
    
}



//end of parser operation

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MuseumItem *tmpItem = [self.itemsArray objectAtIndex:indexPath.row];
    
    if(tmpItem==nil)
        NSLog(@"tmpItem is null");
    
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
	
	topLabel.text = tmpItem.itemName;
	bottomLabel.text = @"More info";
	
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
	
    cell.image =[self downloadImage:tmpItem];

#else
	cell.text = [NSString stringWithFormat:@"Cell at row %ld.", [indexPath row]];
#endif
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [itemsArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemDetails *details =  [[[ItemDetails alloc] initWithNibName:@"ItemDetails" bundle:[NSBundle mainBundle]] autorelease];        
    MuseumItem *item = [self.itemsArray objectAtIndex:indexPath.row];
    NSLog(@"item name is %@",item.itemName);
    details.item = item;
    details.navigationController = self.navigationController;
    [self.navigationController pushViewController:details animated:YES]; 
    
}

- (UIImage*) downloadImage:(MuseumItem *)item
{  
    NSLog(@"loadImageInBackground()...");
    
    UIImage *imgFromCache;
    imgFromCache = [self.imageCache objectForKey:item.imageID];
    if (imgFromCache != nil)
    {
        NSLog(@"brought image from cache!");
        return imgFromCache;
    }
    
	// Create a pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    NSMutableString *itemImageURL = [[NSMutableString alloc] initWithString:[Helper getServerURL]];
    [itemImageURL appendString:[Helper getPictureImagePath]];
    [itemImageURL appendString:item.imageID];
    [itemImageURL appendString:@"&Height="];
    [itemImageURL appendString:[Helper getThumbImageHeight]];
    [itemImageURL appendString:@"&Width="];
    [itemImageURL appendString:[Helper getThumbImageWidth]];


    NSLog(@"IMAGE TO FETCH %@",itemImageURL);
 	// Retrieve the remote image
	NSURL *imgURL = [NSURL URLWithString:itemImageURL];
	NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
	UIImage *img    = [[UIImage alloc] initWithData:imgData];
    
    [self.imageCache setValue:img forKey:item.imageID];

    [pool release ];
    
    return [img autorelease];
    
}
//end of table view

@end
