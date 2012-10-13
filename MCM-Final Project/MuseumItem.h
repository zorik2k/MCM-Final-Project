//
//  Item.h
//  MCM-Final Project
//
//  Created by Zorik on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MuseumItem : NSObject {
    NSString *itemName;
    NSString *itemDescription;
    NSString *imageID;
    NSString *YTID;
    NSString *embedCode;
    NSString *youtubeVideoName;
    NSString *itemPicture;
    NSString *objectID;
    NSString *itemQRID;

    
    
    
}
@property (nonatomic,retain)NSString *itemName;
@property (nonatomic,retain)NSString *itemDescription;
@property (nonatomic,retain)NSString *imageID;
@property (nonatomic,retain)NSString *YTID;
@property (nonatomic,retain)NSString *embedCode;
@property (nonatomic,retain)NSString *youtubeVideoName;
@property (nonatomic,retain)NSString *itemPicture;
@property (nonatomic,retain)NSString *objectID;
@property (nonatomic,retain)NSString *itemQRID;

-(void) goToItem;



@end
