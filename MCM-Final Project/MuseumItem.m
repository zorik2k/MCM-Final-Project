//
//  Item.m
//  MCM-Final Project
//
//  Created by Zorik on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MuseumItem.h"


@implementation MuseumItem

@synthesize itemName;
@synthesize itemDescription;
@synthesize imageID;
@synthesize YTID;
@synthesize embedCode;
@synthesize youtubeVideoName;
@synthesize itemPicture;
@synthesize objectID;
@synthesize itemQRID;
-(void)dealloc
{
    NSLog(@"MuseumItem dealloc() start");
     itemName=nil;
     itemDescription=nil;
     imageID=nil;
     YTID=nil;
     embedCode=nil;
     youtubeVideoName=nil;
     itemPicture=nil;
    self.objectID =nil;
    [super dealloc];
    NSLog(@"MuseumItem dealloc() done");

}
@end
