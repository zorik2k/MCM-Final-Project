//
//  ReaderSampleViewController.h
//  ReaderSample
//
//  Created by spadix on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderController.h"
#import "ZBarReaderViewController.h"
#import "ItemDetails.h"

@interface ReaderSampleViewController
    : UIViewController
    // ADD: delegate protocol
    < ZBarReaderDelegate >
{
    UIImageView *resultImage;
    UITextView *resultText;
    UINavigationController *navigationController;
    ItemDetails *item;
    NSString *itemID;
    UINavigationController *itemDetalisViewController;
    NSMutableArray *itemsArray;
    NSMutableDictionary *qrHash;

    

}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextView *resultText;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic ,retain) UINavigationController *itemDetalisViewController;
@property (nonatomic, retain) ItemDetails *item;
@property (nonatomic,retain ) NSString *itemID;
@property (nonatomic,retain)     NSMutableArray *itemsArray;
@property (nonatomic,retain) NSMutableDictionary *qrHash;


- (IBAction) scanButtonTapped;
-(void) goToItem : (ZBarSymbol*) symbol;

@end
