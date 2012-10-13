//
//  ItemDetails.h
//  MCM-Final Project
//
//  Created by Zorik on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MuseumItem;
@class ImageLoader;
@interface ItemDetails : UIViewController {
    UINavigationController *navigationController;
    MuseumItem *item;
    IBOutlet UIImageView *itemImage;
    IBOutlet UITextView *description;
    UIImageView *dynamicImage;
    
}
@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic,retain) MuseumItem *item;
@property (nonatomic,retain) IBOutlet UIImageView *itemImage;
@property (nonatomic,retain) IBOutlet UITextView *description;
@property (nonatomic,retain) UIImageView *dynamicImage;
@property (nonatomic,retain) NSString *itemYoutubeVideoUrl;

- (void) loadImageInBackground;
-(IBAction)didSelectYoutubeWatch;
-(IBAction)didSelectPlayer;
@end
