//
//  ReaderSampleViewController.m
//  ReaderSample
//
//  Created by spadix on 8/4/10.
//

#import "ReaderSampleViewController.h"
#import "MuseumItem.h"

@implementation ReaderSampleViewController

@synthesize resultImage, resultText;
@synthesize itemsArray,navigationController,itemDetalisViewController;


-(void) viewDidLoad
{
    self.title = @"Scan Item";
}
- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    resultText.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    frame.size.width = 320;
    frame.size.height = 250;
    self.resultImage.frame = frame;
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    [self goToItem:symbol];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    self.resultImage = nil;
    self.resultText = nil;
    [super dealloc];
}

-(void) goToItem : (ZBarSymbol*) symbol
{
    
    bool match = NO;
    
    NSLog(@"GoItem() starte");
    NSLog(@"Function recvived the next input - @%",symbol.data);
    
    if(self.itemsArray==nil)
        NSLog(@"itemsArray is null - bug");
    
    
    int i=0;
    MuseumItem *itemFromArray=nil;
    for( ; i < [self.itemsArray count] ;i++)
    {
        itemFromArray = [self.itemsArray objectAtIndex:i];
        NSLog(@"Entring the loop - looking for qr id  @%",symbol.data);
        NSLog(@"Entring the loop - The item QRID is @%",itemFromArray.itemQRID);
        if( [itemFromArray.itemQRID isEqualToString: symbol.data ])
        {
            NSLog(@"Match!!");
            match = YES;
            break;
        }
    }
    
    

    // IF QR WAS FOUND
    if(match==YES)
    {
        ItemDetails *details =  [[[ItemDetails alloc] initWithNibName:@"ItemDetails" bundle:[NSBundle mainBundle]] autorelease];    
    
    //  MuseumItem *item = [self.itemsArray objectAtIndex:i];
    //   MuseumItem *item = [self.qrHash ]
    
        NSLog(@"item name is %@",itemFromArray.itemName);
        details.item = itemFromArray;
        details.navigationController = self.navigationController;
        [self.navigationController pushViewController:details animated:YES]; 
    }
    else //QR wasn't found
    {
        NSLog(@"QR id wasn't found - trying again to take a photo...");
        resultText.text =@"QR ID Wasn't fonud try to capture QR again";
    }
    
    
}

-(void) debugPrint
{
    for(int i=0 ; i< [self.itemsArray count ] ;i++)
    {
        MuseumItem *tmp =[self.itemsArray objectAtIndex:i];
        NSLog(@"%@",tmp.itemName);
        NSLog(@"%@",tmp.itemQRID);
    }
}

@end
