//
//  MuseumData.m
//  MCM-Final Project
//
//  Created by Zorik on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MuseumInfo.h"
@implementation MuseumInfo

@synthesize museum;
    


-(void)dealloc{ 
    
    NSLog(@"MuseumInfo dealloc() ");
    [museum release];
    self.museum = Nil;
	[super dealloc];
}

@end
