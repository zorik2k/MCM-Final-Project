//
//  iphoneProjAppDelegate.h
//  iphoneProj
//
//  Created by Avi Romascanu on 1/29/11.
//  Copyright 2011 None. All rights reserved.
//


#import <UIKit/UIKit.h>


@class RootViewController;

@interface MuseumListAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIWindow *windowSecond;
    
    //RootViewController *viewController;
    UINavigationController *navigationController;
	
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet RootViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

