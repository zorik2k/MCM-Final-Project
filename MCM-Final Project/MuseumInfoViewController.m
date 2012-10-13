//
//  MuseumInfoViewController.m
//  MCM-Final Project
//
//  Created by Zorik on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MuseumInfoViewController.h"
#import "ItemsTable.h"
#import "Helper.h"
@implementation MuseumInfoViewController
@synthesize imageURL;
@synthesize description;
@synthesize imageView;
@synthesize museum;
@synthesize navigationController;
@synthesize dynamicImage;
@synthesize toolbar;
- (void)dealloc
{
    
    NSLog(@"Deallocing musumInfoViewController");
    [self.museum release];
    self.museum =nil;
    self.description = nil;
    self.imageView = nil;
    self.imageURL = nil;
    self.navigationController =nil;
    self.dynamicImage =nil;
    
    self.imageURL = nil;
    [super dealloc];
    
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
    self.imageView.image = [UIImage imageNamed:@"loading.jpg"];
    [self.description setEditable:NO];
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
}


- (void) loadImageInBackground {
    
	// Create a pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableString *itemImageURL = [[NSMutableString alloc]initWithString:[Helper getServerURL]];
    [itemImageURL appendString:[Helper getMuseumImagePath]];
    
    [itemImageURL appendString:museum.museumID];
    [itemImageURL appendString:@"&Height="];
    [itemImageURL appendString: [Helper getMuseumImageHeight]];
    [itemImageURL appendString :@"&Width="];
    [itemImageURL appendString:[Helper getMuseumImageWidth]];

    
	NSURL *imgURL = [NSURL URLWithString:itemImageURL];
	NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
	UIImage *img    = [[UIImage alloc] initWithData:imgData];
    
    self.museum.museumPicture = img;
    
	// Image retrieved, call main thread method to update image, passing it the downloaded UIImage
	[self performSelectorOnMainThread:@selector(assignImageToImageView:) withObject:img waitUntilDone:YES];
    
	// clean up
	[pool release];

    
    
    
    
    
    
}

- (void) assignImageToImageView:(UIImage *)img
{
    
	// Create a pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	// create an image view with an appropriately sized frame using the passed in UIImage
	self.dynamicImage = [[UIImageView alloc] initWithImage:img]; 
    
	//set contentMode to scale aspect to fit
	self.dynamicImage.contentMode = UIViewContentModeScaleAspectFit;
    
	//change width of frame
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    frame.size.width = 320;
    frame.size.height = 250;
    self.dynamicImage.frame = frame;
    
	// add the image view as a subview
	[self.view addSubview:self.dynamicImage];
    
	// release the pool
	[pool release];
    
	// Remove the activity indicator created in ViewDidLoad()
	//[self.activityIndicator removeFromSuperview];
    
}
-(void)viewDidDisappear:(BOOL)animated
//-(void)viewWillDisappear:(BOOL)animated
{
    [self.dynamicImage removeFromSuperview]; 
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadImageInBackground];
    NSLog(@"viewWilAppear");
    self.title = museum.museumName;
    self.description.text = museum.museumDescription;
    
//    [self setWantsFullScreenLayout:YES];
    
    /*
    UIBarButtonItem     *addButton = [[UIBarButtonItem alloc] init];
    [addButton setTitle:@"QR"];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.target  = self;
    self.navigationItem.rightBarButtonItem.action = @selector(mySelector:);
    
    self.description.text =museum.museumDescription;
    self.description.editable =FALSE ;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit:)];
*/

}

/*
- (IBAction)mySelector:(id)sender {
    NSLog(@"You touched me THERE!");
    
    if (self.qrViewController == nil) {
        self.qrViewController = [[[ReaderSampleViewController alloc] initWithNibName:@"ReaderSampleViewController" bundle:[NSBundle mainBundle]] autorelease];        
    }
    
    
    qrViewController.navigationController = self.navigationController;
    [self.navigationController pushViewController:qrViewController animated:YES]; 
    
    
}
*/


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return YES;
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)didSelectItemsView
{
    NSLog(@"didSlectItem was pressed");

    ItemsTable *itemsTable = [[ItemsTable alloc]initWithNibName:@"ItemsTable" bundle:[NSBundle mainBundle]];
    itemsTable.currentMuseum = self.museum;
    itemsTable.navigationController = self.navigationController;
    
    [self.navigationController pushViewController:itemsTable animated:YES]; 
}


@end
