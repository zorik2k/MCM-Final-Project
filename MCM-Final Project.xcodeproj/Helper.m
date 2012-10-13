//
//  Helper.m
//  MCM-Final Project
//
//  Created by Zorik on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"


@implementation Helper
@synthesize serverURL;
@synthesize thumbImageHeight;
@synthesize thumbImageWidth;
@synthesize museumListPath;
@synthesize  museumItemsPath;


+(NSString *)getMuseumImagePath
{
    return @"pages/getmuseumimage.aspx?id=";
}
+(NSString *)getPictureImagePath
{
    return @"pages/getimage.aspx?id=";
}

+(NSString *)getServerURL{
 //  return @" http://db.cs.colman.ac.il/mcm/";
    return @"http://mcm.no-ip.info/";
}

+(NSString*) getAllMuseumsDBURL
{
    NSString *serverURL = [self getServerURL];
    serverURL = [serverURL stringByAppendingString:@"/webservices/getallmuseums.asmx?op=MuseumsFromDB"];
    
    return  serverURL;
    
    
}

+(NSString*) getAllItemsDBURL{
    NSString *serverURL = [self getServerURL];
    serverURL = [serverURL stringByAppendingString:@"/webservices/getmuseumitems.asmx?op=GetMuseumItemsFromDB"];    
    return  serverURL;
    
}


+(NSString*) getMuseumImageHeight
{
    return @"250";
}
+(NSString*) getMuseumImageWidth
{
    return @"320";
}



+(NSString*) getThumbImageHeight
{
    return  @"60";
}
+(NSString*) getThumbImageWidth
{
    return  @"60";
}

+(NSString*) getAudioURL :(NSString*) itemID
{
    NSMutableString *sb = [[NSMutableString alloc] init];
    [sb appendString: [self getServerURL]];
    [sb appendString: @"audio/"];
    [sb appendString: itemID ];
    [sb appendString:@".mp3"];
    
    return  sb;
}

-(void) dealloc
{
    NSLog(@"Dealloc helper started");
    self.serverURL =nil;
    self.thumbImageHeight =nil;
    self.thumbImageWidth =nil;
    self.museumListPath = nil;
    self.museumItemsPath =nil;
    
    [super dealloc];
    
}
+(void)handleError:(NSError *)error
{
    NSLog(@"Error ouccuerd, description is : %@",[error description]);

	NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:
     NSLocalizedString(@"Error Title",
                       @"MCM ouccred error , please reLuch the apploiaction.")
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end

