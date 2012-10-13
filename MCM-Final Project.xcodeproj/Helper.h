//
//  Helper.h
//  MCM-Final Project
//
//  Created by Zorik on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Helper : NSObject {
    
    NSString *serverURL;
    NSString *museumListPath;
    NSString *museumItemsPath;
    NSNumber *thumbImageHeight;
    NSNumber *thumbImageWidth;
    
    
    
 


}
@property (nonatomic,retain) NSString *serverURL;
@property (nonatomic,retain) NSString *museumListPath;
@property (nonatomic,retain) NSString *museumItemsPath;

@property (retain) NSNumber *thumbImageHeight;
@property (retain) NSNumber *thumbImageWidth;

+(void)handleError:(NSError *)error;
+(NSString*) getServerURL;
+(NSString*) getPictureImagePath;
+(NSString*) getMuseumImagePath;
+(NSString*) getThumbImageHeight;
+(NSString*) getThumbImageWidth;
+(NSString*) getAllItemsDBURL;

+(NSString*) getMuseumImageHeight;
+(NSString*) getMuseumImageWidth;

+(NSString*) getAllMuseumsDBURL;
+(NSString*) getAudioURL :(NSString*) itemID;







@end
