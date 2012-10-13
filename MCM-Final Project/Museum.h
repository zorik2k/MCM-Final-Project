//
//  MyClass.h
//  MCM-Final Project
//
//  Created by Zorik on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Museum : NSObject {
	NSString *museumName;
	NSString *museumCity;
	UIImage *museumPicture;
    UIImage *thumbImage;
	NSString *museumImageURL;
    NSString *museumImageName;
	NSString *museumDescription;
	NSString *museumID;
	
}
@property (nonatomic,retain) NSString *museumName;
@property (nonatomic,retain) NSString *museumCity;
@property (nonatomic,retain) UIImage *museumPicture;
@property (nonatomic,retain) NSString *museumImageURL;
@property (nonatomic,retain) NSString *museumDescription;
@property (nonatomic,retain) NSString *museumID;
@property (nonatomic,retain) NSString *museumImageName;
@property (nonatomic,retain) UIImage *thumbImage;
@end
