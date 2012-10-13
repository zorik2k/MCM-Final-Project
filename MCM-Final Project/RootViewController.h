//
//  MuseumListViewController.h
//  MCM-Final Project
//
//  Created by Zorik on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Museum.h"
#import "MuseumInfoViewController.h"
#import "Helper.h"
@class Museum;
@class AboutViewController;
@interface RootViewController : UIViewController <NSXMLParserDelegate> {
	UITableView *museumsTableVIew;
	NSMutableArray *museumsArray;
	NSMutableString * currentMuseumName, * currentMuseumCity, * currentMuseumImageUrl ,*currentMuseumID ,*currentMuseumDescription, *currentMuseumImageName;
	Museum *museum;
	NSURLConnection *museumListConnection;
	NSMutableData *museumListData;
	NSXMLParser *parser;
	NSString *currentElement;
    AboutViewController  *aboutViewController;
	NSString *nodeName;
	NSInteger countMuseums;
    MuseumInfoViewController *museumInfoViewController;
    UIButton *infoButton;
    UIBarButtonItem *addButton;
    
    
    NSMutableDictionary *imageCache;
	
    
}

-(void)PrintMuseumList:(NSString*) str;
-(void)handleError:(NSError *) error;
- (void) loadImageInBackground: (Museum*) tmpMuseum;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;


@property (nonatomic,retain) IBOutlet UITableView *museumsTableVIew;
@property (nonatomic,retain) NSURLConnection *museumListConnection;
@property (nonatomic,retain) NSMutableData *museumListData;
@property (nonatomic,retain) NSXMLParser *parser;
@property (nonatomic,retain) NSString *currentElement;
@property (nonatomic,retain) NSString *nodeName;
@property (nonatomic,retain) Museum *museum;
@property (nonatomic,retain) Helper *helper;

@property (nonatomic,retain) NSMutableArray *museumsArray;
@property (nonatomic,retain) NSMutableString * currentMuseumName, * currentMuseumCity, *currentMuseumImageName ,* currentMuseumImageUrl ,*currentMuseumID ,*currentMuseumDescription;
@property (nonatomic,retain) MuseumInfoViewController *museumInfoViewController;
@property (nonatomic, retain)     AboutViewController  *aboutViewController;
@property (nonatomic, retain)     NSMutableDictionary *imageCache;



@end