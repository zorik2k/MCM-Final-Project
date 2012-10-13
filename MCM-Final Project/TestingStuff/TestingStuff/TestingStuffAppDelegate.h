//
//  TestingStuffAppDelegate.h
//  TestingStuff
//
//  Created by Zorik on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestingStuffViewController;

@interface TestingStuffAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TestingStuffViewController *viewController;

@end
