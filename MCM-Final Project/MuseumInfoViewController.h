//
//  MuseumInfoViewController.h
//  MCM-Final Project
//
//  Created by Zorik on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Museum.h"

@class ImgaeLoader;
@interface MuseumInfoViewController : UIViewController {
    
    Museum  *museum;
    bool downloadFInsihed ;
    IBOutlet UITextView *description;
    IBOutlet UIImageView *imageView;
    NSURL *imageURL;
    UINavigationController *navigationController;
    UIImageView *dynamicImage;
    UIToolbar *toolBar;
    

}
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (retain,nonatomic) IBOutlet UITextView *description;
@property (retain,nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) UIImageView *dynamicImage;
@property (retain,nonatomic) NSURL *imageURL;
@property (retain,nonatomic) Museum *museum;
@property (retain,nonatomic) UIToolbar *toolbar;

-(IBAction)didSelectItemsView;
-(IBAction)QRButtonPressed;

-(void)loadImageInBackground;

//@property (retain,nonatomic) ImgaeLoader *imageLoader;
@end

