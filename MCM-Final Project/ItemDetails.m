//
//  ItemDetails.m
//  MCM-Final Project
//
//  Created by Zorik on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemDetails.h"
#import "MuseumItem.h"
#import "SVWebViewController.h"
#import "Helper.h"
#import "iPhoneStreamingPlayerViewController.h"

@implementation ItemDetails
@synthesize navigationController;
@synthesize item;
@synthesize description;
@synthesize itemImage;
@synthesize dynamicImage;
@synthesize itemYoutubeVideoUrl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = self.item.itemName;
    self.description.text = self.item.itemDescription;
    
    [self loadImageInBackground];
}

- (void)dealloc
{
 //   self.navigationController = nil;
 //   self.item = nil;    

    NSLog(@"itemDealis dealloc() start");
    
    self.navigationController =nil;
    self.item = nil;
    self.itemImage =nil;
    self.description =nil;
    self.dynamicImage =nil;
    
    [super dealloc];
    
    NSLog(@"itemDealis dealloc() done");

}

-(void) freeProperties
{
    self.description = nil;
    self.dynamicImage = nil;
    self.itemImage = nil;
}

- (void)didReceiveMemoryWarning
{
  //  [self freeProperties];
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.description setEditable:NO];
    self.itemImage.image = [UIImage imageNamed:@"loading.jpg"];
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
}

-(void)viewDidDisappear:(BOOL)animated
//-(void)viewWillDisappear:(BOOL)animated
{
    [self.dynamicImage removeFromSuperview]; 
}

- (void) loadImageInBackground {
    
	// Create a pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    NSMutableString *itemImageURL = [[NSMutableString alloc] initWithString:[Helper getServerURL]];
    [itemImageURL appendString:[Helper getPictureImagePath]];
    [itemImageURL appendString:self.item.imageID];
    [itemImageURL appendFormat:@"&Height="];
    [itemImageURL appendFormat:[Helper getMuseumImageHeight]];
    [itemImageURL appendFormat:@"&Width="];
    [itemImageURL appendFormat:[Helper getMuseumImageWidth]];
    
      NSLog(@"IMAGE TO FETCH %@",itemImageURL);
 	// Retrieve the remote image
	NSURL *imgURL = [NSURL URLWithString:itemImageURL];
	NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
	UIImage *img    = [[UIImage alloc] initWithData:imgData];
    
    self.itemImage = img;
    
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

-(IBAction)didSelectYoutubeWatch
{
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress: item.embedCode];
    //[self.navigationController pushViewController:webViewController animated:YES];
    
    
    
    [UIView  beginAnimations: @"Showinfo" context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.75];
    [self.navigationController pushViewController: webViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [webViewController release];
}
-(IBAction)didSelectPlayer
{
    iPhoneStreamingPlayerViewController *player = [[iPhoneStreamingPlayerViewController alloc] init];
    
    player.downloadSourceField = [Helper getAudioURL:item.objectID];
    NSLog(@"Audio url is %@",player.downloadSourceField);

    NSString *audioDescrprtion  = @"Audio for : ";
    audioDescrprtion = [audioDescrprtion stringByAppendingString:item.itemName];
    NSLog(@"audioDescrprtion name is %@",audioDescrprtion);
    player.pictureName = audioDescrprtion;
    audioDescrprtion = nil;
    
    [UIView  beginAnimations: @"Showinfo" context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.75];
    [self.navigationController pushViewController: player animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    
    
}
@end
