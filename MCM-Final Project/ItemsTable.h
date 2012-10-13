//
//  ItemsTable.h
//  MCM-Final Project
//
//  Created by Zorik on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderSampleViewController.h"
@class Museum;
@class MuseumItem;
@interface ItemsTable : UIViewController <NSXMLParserDelegate> {
    Museum *currentMuseum;
    MuseumItem *item;
    UINavigationController *navigationController;
    NSMutableDictionary *qrHash;
    
	NSMutableArray *itemsArray;
	
    NSMutableString 
        *currentitemName,
        *currentitemDescription,
        *currentimageID,
        *currentYTID,
        *currentembedCode,
        *currentyoutubeVideoName,
        *currentObjectID,
        *currentQRID;
    
	NSURLConnection *museumItemConnection;
	NSMutableData *museumItemData;
	NSXMLParser *parser;
	NSString *currentElement;
	NSString *nodeName;
    UITableView *itemsTable;
    ReaderSampleViewController *qrViewController;

    

}

@property (nonatomic,retain) Museum *currentMuseum;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic,retain) IBOutlet UITableView *itemsTable;
@property (nonatomic,retain) NSMutableArray *itemsArray;
@property (nonatomic,retain) NSMutableDictionary *qrHash;
@property (nonatomic,retain) NSURLConnection *museumItemConnection;
@property (nonatomic,retain) NSMutableData *museumItemData;
@property (nonatomic,retain) NSXMLParser *parser;
@property (nonatomic,retain) NSString *currentElement;
@property (nonatomic,retain) NSString *nodeName;
@property (nonatomic,retain) MuseumItem *item;
@property (nonatomic,retain) ReaderSampleViewController *qrViewController;
@property (nonatomic,retain) NSMutableString
*currentitemName,
*currentitemDescription,
*currentimageID,
*currentYTID,
*currentembedCode,
*currentyoutubeVideoName,
*currentQRID,
*currentObjectID;
-(void) handleError:(NSError*) err;
-(UIImage*) downloadImage :(MuseumItem*) item;
-(IBAction) QRButtongWasPressed;
@property (nonatomic, retain)     NSMutableDictionary *imageCache;

@end
