//
//  MyClass.m
//  MCM-Final Project
//
//  Created by Zorik on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "Museum.h"

@implementation Museum
@synthesize museumName;
@synthesize museumCity;
@synthesize museumPicture;
@synthesize museumImageURL;
@synthesize museumDescription;
@synthesize museumID;
@synthesize museumImageName;
@synthesize thumbImage;

-(void)dealloc{

    
    NSLog(@"Museum dealloc() ");
     self.museumName=nil;
    [self.museumPicture release];
	 self.museumCity=nil;
	 self.museumPicture=nil;
	 self.museumImageURL=nil;
     self.museumImageName=nil;
	 self.museumDescription=nil;
	 self.museumID=nil;
    
	[super dealloc];
}
@end
