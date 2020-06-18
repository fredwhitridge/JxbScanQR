//
//  parseView.m
//  ESCBarcode101
//
//  Created by fred whitridge on 6/12/20.
//  Copyright © 2020 esco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "parseView.h"



@interface parseViewController ()

//-(void)showQRParsed;
-(void)loadBeepSound;
@end



@implementation parseViewController






static NSRange end;
static BOOL isSingleLabel = FALSE;
//static int numSkus=0;  //moved to GlobalVariables 5/16/17
static NSString *lastChunk;
static float lengthFloat;
static float widthFloat;
static float piecesPerSqFloat;
static float sqFloat;
static float totSqFloat;
static int widthInt;
static NSString *scanContents;
static NSString *theDate;
static NSString *theTime;
static NSString *outputString;
static NSString *file2Write;
static NSString *userName;
static BOOL scanHasBeenSaved;









@synthesize slateColor, sku1, pieces1, labelDate, bin, job, pallet, sku2, pieces2;
@synthesize sku3, pieces3, sku4, pieces4;
@synthesize sku5, pieces5, sku6, pieces6;
@synthesize sq1, sq2, sq3, sq4, sq5, sq6, totSq;
@synthesize physicalButton, millButton, commentButton;
@synthesize saveScans, noteToUser;


//-------------------------------------------------------------------------


-(void) viewWillAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        self.view.backgroundColor =[UIColor greenColor];
        physicalButton.userInteractionEnabled=NO;
        millButton.userInteractionEnabled=YES;
        //added MillsSelected 5/27/2018
        NSLog(@"\r\n\n*** At ParseView Will Appear: Buttons hidden? ****\r\n");
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"MillsSelected"]) {
            NSLog(@"\r*** Mills ARE selected ****\r\n\n");
            millButton.hidden=TRUE;
            physicalButton.hidden=TRUE;
            saveScans.hidden=FALSE;
        } else {
            NSLog(@"*** Mills AREN'T selected ****\r\n\n");
            millButton.hidden=FALSE;
            physicalButton.hidden=TRUE;
            saveScans.hidden=TRUE;
        }
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        self.view.backgroundColor =[UIColor blueColor];
        physicalButton.userInteractionEnabled=YES;
        millButton.userInteractionEnabled=NO;
        //millButton.opaque=YES;
   
    }
    
    GlobalVariables *obj=[GlobalVariables getInstance];
    
    if (obj.millTo.length > 1){
        noteToUser.text=@"";
        saveScans.enabled=TRUE;
    }
    
} // end of viewWillAppear

- (void)viewDidLoad {
    [super viewDidLoad];
    GlobalVariables *obj=[GlobalVariables getInstance];
    NSLog(@"\r\n\n*** At parseView did Load ****\r\n\n");
    NSLog(@"*** At parseView rawQR = : %@", obj.rawQR);


    if ((obj.typeOfScanSelected = TRUE)) {
        saveScans.enabled=TRUE;
  
    } else {
    saveScans.enabled=FALSE;
    noteToUser.text=@"Save disabled until scan type selected.";
    }
   
    // Do any additional setup after loading the view.
    [self parseIt];
    [self showParsed];
    
    //fw added 6/13/20
    noteToUser.text = obj.rawQR;
    
   
   
}




-(void) parseIt {
    GlobalVariables *obj=[GlobalVariables getInstance];
    scanContents=obj.rawQR;
//next commented out with move to ESCBarcode101 6/13/20
    //now force caps
    /*scanContents = [NSString stringWithFormat:@"%@", [self.dicTextData objectForKey:@"Data"]] ; //dicTextData is loaded before segue in QMSampleViewController.m
;
     */
    NSString *upperString = scanContents;   //[[NSString alloc] initWithFormat:scanContents];
    NSString *changeString = [upperString uppercaseString];
    scanContents=changeString;
    //NSLog(changeString);
    upperString = nil;
    changeString = nil;
    isSingleLabel = FALSE;
    NSLog(@"*** from parseIt ***, changed to upper");
    
    
    if (([[scanContents substringWithRange:NSMakeRange(0,1)] isEqualToString:(@"(")]) != TRUE)
    {
        NSLog(@"*** from parseIt ***, this is a single sku label");
        //NSLog(@"3d Scan Contents: %@", scanContents);
        obj.numSkus = 1;
        slateColor.text=[scanContents substringWithRange:NSMakeRange(0, 5)];
        //NSLog(@"Color, parsed: %@", [scanContents substringWithRange:NSMakeRange(0, 5)]);
        sku1.text=[scanContents substringWithRange:NSMakeRange(5,10)];
        isSingleLabel = TRUE;
        lastChunk = [scanContents substringFromIndex:15];
        //NSLog(@"lastChunk, singleSKULABEL = %@", lastChunk);
        end = [lastChunk rangeOfString:@"P"];
        //NSLog(@"Pieces1 = %@", [lastChunk substringToIndex:end.location]);
        pieces1.text=[lastChunk substringToIndex:end.location];
        pieces1.text = [self padString:pieces1.text];
        lastChunk = [lastChunk substringFromIndex:end.location+1];
        //NSLog(@"Single SKU label, lastchunk after pieces %@", lastChunk);
        labelDate.text = [lastChunk substringToIndex:10];
        lastChunk = [lastChunk substringFromIndex:10];
        job.text = [lastChunk substringToIndex:lastChunk.length - 1];
        NSLog(@"*** from parseIt ***, finished parsing single on a single horiz label");
    }
    
    @try {
        NSLog(@"*** from parseIt ***, isSingleLabel: %c", isSingleLabel);
        if (isSingleLabel == FALSE)
        {
            NSLog(@"*** from parseIt ***, this is a multi: %@", scanContents);
            slateColor.text=[scanContents substringWithRange:NSMakeRange(2, 5)];
            obj.numSkus=[[scanContents substringWithRange:NSMakeRange(1, 1) ] intValue];
            
            sku1.text=[scanContents substringWithRange:NSMakeRange(7,10)];
            
            //parse the first sku pieces
            lastChunk = [scanContents substringFromIndex:17];
            //NSLog(@"lastChunk = %@", lastChunk);
            end = [lastChunk rangeOfString:@"P"];
            NSLog(@"*** from parseIt ***, Pieces1 = %@", [lastChunk substringToIndex:end.location]);
            pieces1.text=[lastChunk substringToIndex:end.location];
            pieces1.text = [self padString:pieces1.text];
            
            //treat bin, label date and job later if > 1 sku
            if (obj.numSkus==1) {
                //need to find job, bin and label date for a single sku on a multi label 2-20/13:
                NSLog(@"+++ Last chunk, for 1 SKU on a multi: %@",lastChunk);
                end = [lastChunk rangeOfString:@"P"];
                lastChunk = [lastChunk substringFromIndex:end.location+1];
                NSLog(@"+++ Last chunk, after pieces: %@",lastChunk);
                end = [lastChunk rangeOfString:@")"];
                labelDate.text = [[lastChunk substringToIndex:end.location] substringFromIndex:end.location-10];
                bin.text= [lastChunk substringToIndex:end.location-10];
                
                //now get the job.text
                end = [lastChunk rangeOfString:@")"];
                lastChunk = [lastChunk substringFromIndex:end.location+1];
                //NSLog(@"+++ Last chunk, after ): %@",lastChunk);
                job.text= [lastChunk substringToIndex:lastChunk.length-1];
            }
        }  //end of single skus: on single horizontal or on multi
    } //end of try block
    @ catch (NSException *exception) {
        NSLog(@"Bombed pasrsing first sku");
        UIAlertView *parseAlert = [[UIAlertView alloc]initWithTitle:@"Can't parse SKU #1, on  multi!"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [parseAlert show];
        
    }//end of catch block
    
    //if there's more than one sku find the second
    if (obj.numSkus  > 1)
    {
        lastChunk = [lastChunk substringFromIndex:end.location+1];
        sku2.text = [lastChunk substringToIndex:10];
        lastChunk = [lastChunk substringFromIndex:11];
        //NSLog(@"lastChunk after sku2= %@", lastChunk);
        end = [lastChunk rangeOfString:@"P"];
        //NSLog(@"Pieces2 = %@", [lastChunk substringToIndex:end.location]);
        pieces2.text=[lastChunk substringToIndex:end.location];
        pieces2.text = [self padString:pieces2.text];
        
    }
    //if there's more than two skus find the third
    if (obj.numSkus  > 2)
    {
        lastChunk = [lastChunk substringFromIndex:end.location+1];
        sku3.text = [lastChunk substringToIndex:10];
        lastChunk = [lastChunk substringFromIndex:11];
        //NSLog(@"lastChunk after sku3= %@", lastChunk);
        end = [lastChunk rangeOfString:@"P"];
        //NSLog(@"Pieces3 = %@", [lastChunk substringToIndex:end.location]);
        pieces3.text=[lastChunk substringToIndex:end.location];
        pieces3.text = [self padString:pieces3.text];
        
    }
    //if there's more than three skus find the fourth
    if (obj.numSkus > 3)
    {
        lastChunk = [lastChunk substringFromIndex:end.location+1];
        sku4.text = [lastChunk substringToIndex:10];
        lastChunk = [lastChunk substringFromIndex:11];
        end = [lastChunk rangeOfString:@"P"];
        //NSLog(@"Pieces4 = %@", [lastChunk substringToIndex:end.location]);
        pieces4.text=[lastChunk substringToIndex:end.location];
        pieces4.text = [self padString:pieces4.text];
        
    }
    //if there's more than four skus find the fifth
    if (obj.numSkus > 4)
    {
        lastChunk = [lastChunk substringFromIndex:end.location+1];
        sku5.text = [lastChunk substringToIndex:10];
        lastChunk = [lastChunk substringFromIndex:11];
        //NSLog(@"lastChunk after sku5= %@", lastChunk);
        end = [lastChunk rangeOfString:@"P"];
        //NSLog(@"Pieces5 = %@", [lastChunk substringToIndex:end.location]);
        pieces5.text=[lastChunk substringToIndex:end.location];
        pieces5.text = [self padString:pieces5.text];
        
    }
    
    //if there's more than five skus find the sixth
    if (obj.numSkus > 5)
    {
        lastChunk = [lastChunk substringFromIndex:end.location+1];
        sku6.text = [lastChunk substringToIndex:10];
        lastChunk = [lastChunk substringFromIndex:11];
        //NSLog(@"lastChunk after sku6= %@", lastChunk);
        end = [lastChunk rangeOfString:@"P"];
        //NSLog(@"Pieces6 = %@", [lastChunk substringToIndex:end.location]);
        pieces6.text=[lastChunk substringToIndex:end.location];
        pieces6.text = [self padString:pieces6.text];
        
    }
    
    @try {
        //now parse the job
        if (obj.numSkus > 1)
        {
            lastChunk = [lastChunk substringFromIndex:end.location+1];
            //NSLog(@"lastChunk after pieces6= %@", lastChunk);
            NSRange start = [lastChunk rangeOfString:@")"];
            //NSLog(@"lastChunk= %@", lastChunk);
            NSString *thisChunk=[lastChunk substringFromIndex:start.location+1];
            //NSLog(@"thisChunk= %@", thisChunk);
            job.text= [thisChunk substringToIndex:thisChunk.length -1];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Bombed trying to parse job");
        UIAlertView *parseAlert = [[UIAlertView alloc]initWithTitle:@"trouble parsing job!"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"parseIt bombed no )"
                                                  otherButtonTitles:nil];
        [parseAlert show];
        return;
    }
    //@finally {
    //    <#statements#>
    //}
    
    
    //now parse labelDate
    if (obj.numSkus > 1)
    {
        NSRange start = [lastChunk rangeOfString:@")"];
        
        lastChunk = [lastChunk substringToIndex:start.location];
        //NSLog(@"lastChunk= %@", lastChunk);
        labelDate.text = [lastChunk substringFromIndex:lastChunk.length-10];
        //NSLog(@"date parsed= %@", [[lastChunk substringToIndex:end.location] substringFromIndex:lastChunk.length-10]);
    }
    //*/
    
    //now parse the bin
    if (obj.numSkus > 1)
    {
        bin.text = [lastChunk substringToIndex:lastChunk.length-10];
    }
}

// end of ParseIt----------------------------------------------------------------------

- (IBAction)SaveScans:(id)sender {
    GlobalVariables *obj=[GlobalVariables getInstance];
    NSLog(@"\n\n-----------------------\n***!!! Made it to SaveScans !!!***\n\n");
    
    
    
    
    /*
    NSString *s = obj.physicalBin;  //sBinForPhysical;
     s = [NSString stringWithFormat:@"%@%@", @"Save PHYSICAL scan To: ", s];
     const char *c = [s UTF8String];
     [sender setTitle:@(c) forState:UIControlStateNormal];
     
     if (obj.scanTypeSelected = @"TRUE") {
     NSLog(@"***  At save Scan, slecting millin/out bins  ***");
     [self selectBin ];  //commented out 4/28/2014 to prevent dupe write to file
     [sender setTitle:@"Save MillIn/Out scan" forState:UIControlStateNormal];
     }
    */
    
    //next added 4/29 to try and prevent double printing of barcodes to file in MillIn/out
    NSLog(@"*** at ParseView millTo is: %@", obj.millTo);
/*    if ((obj.scanningMillIn=YES)){
        if (obj.millTo.length==0)
        {
            return;
        }
    }
 */
    
    //code below copied from SaveAsFileAction into this IBAction 10/26/13
    
    //for list of sounds see: http://iphonedevwiki.net/index.php/AudioServices
    //1326=ladder, 1325=fanfare, 1324=descent, 1016=tweet sent,1028 news flash,
    //1030=sherwood forest, 1020 = anticipate,1027=minuet,1029=noir
    //1324=reprint
    //1325=QR scanned//1028 = scan saved, millin/out
    //1326 = scan saved, physical
    //1028 = scan saved, millin
    //AudioServicesPlaySystemSound (1028);
    
    //[self saveScanButtonTitleChange];
    
    
    NSNumberFormatter * formatter =  [[NSNumberFormatter alloc] init];
    //[formatter setUsesSignificantDigits:YES];
    //[formatter setMaximumSignificantDigits:5];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundCeiling];
    
    // NSLog(@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:twofortythreetwentyfive]]);
    obj.numSaved += 1;
    //miscLabel.text = [NSString stringWithFormat:@"%d", numSaved];
    NSLog(@"Num Skus at calc stats= %d",obj.numSkus);
   // obj.numLinesSaved += obj.numSkus;
    //savedLines.text = [NSString stringWithFormat:@"%d", numLinesSaved];
    obj.numSquareSaved +=  (NSInteger)round(totSqFloat);
    //savedSquare.text = [formatter stringFromNumber:[NSNumber numberWithFloat:numSquareSaved]];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        NSLog(@"Route created");
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSDate *now = [[NSDate alloc] init];
    theDate = [dateFormat stringFromDate:now];
    theTime = [timeFormat stringFromDate:now];
    //miscLabel.text = theDate;
   
     NSLog(@"\n"
          "In Save Scans theDate: |%@| \n"
          "theTime: |%@| \n"
          , theDate, theTime);
    
    
    //--------------------------------
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        //saving in format for Mill In/Out
        NSLog(@"Saving in MILL format");
        //[millButton sendActionsForControlEvents:UIControlEventTouchUpInside];



        NSLog(@"\r\n\n---#2--- in ParseView Mill From = %@, mill in = %@\r\n\n",obj.millFrom,obj.millTo);
        outputString = [NSString stringWithFormat:@"%@%@,%@P,%@00,%@00, %@, %@,%@,%@, new scan %@ lines total",slateColor.text, sku1.text, pieces1.text , obj.millFrom, obj.millTo, labelDate.text, job.text, theDate, theTime, [NSString stringWithFormat:@"%ld", obj.numSkus]];  //was numskus -1 @ 5/19/17
    
    //print comment after first line 5/21/2017
    outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@", %@",obj.commentString]];
    obj.commentString=nil;
    
        outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        
        
        if (obj.numSkus >1) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@P,%@00,%@00\n",slateColor.text, sku2.text, pieces2.text, obj.millFrom, obj.millTo]];
        }
        if (obj.numSkus >2) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@P,%@00,%@00\n",slateColor.text, sku3.text, pieces3.text, obj.millFrom, obj.millTo]];
        }
        if (obj.numSkus >3) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@P,%@00,%@00\n",slateColor.text, sku4.text, pieces4.text, obj.millFrom, obj.millTo]];
        }
        if (obj.numSkus >4) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@P,%@00,%@00\n",slateColor.text, sku5.text, pieces5.text, obj.millFrom, obj.millTo]];
        }
        if (obj.numSkus >5) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@P,%@00,%@00\n",slateColor.text, sku6.text, pieces6.text, obj.millFrom, obj.millTo]];
        }
        NSLog(@"\r\n### comment string %@  ####\r\n\n",obj.commentString);
    
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"MillsSelected"];  //after saving mills no longer selected

    
    } else {
        //------------------------------------
        //---------- scanning PHYSICAL -------
        NSLog(@"Saving in PHYSICAL format");
        outputString = [NSString stringWithFormat:@"%@%@,%@, %@, %@, %@, %@, %@, new scan %@ lines follow",slateColor.text, sku1.text, pieces1.text , bin.text,  labelDate.text, job.text, theDate, theTime, [NSString stringWithFormat:@"%ld", obj.numSkus-1]];
        NSLog(@"comment string %@",obj.commentString);
        if (obj.commentString != nil){
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@", %@",obj.commentString]];
            obj.commentString=nil;
            //comment.text=nil;
        }
        outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        
        
        if (obj.numSkus >1) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@\n",slateColor.text, sku2.text, pieces2.text]];
        }
        if (obj.numSkus >2) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@\n",slateColor.text, sku3.text, pieces3.text]];
        }
        if (obj.numSkus >3) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@\n",slateColor.text, sku4.text, pieces4.text]];
        }
        if (obj.numSkus >4) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@\n",slateColor.text, sku5.text, pieces5.text]];
        }
        if (obj.numSkus >5) {
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@\n",slateColor.text, sku6.text, pieces6.text]];
        }
        
    }  //end of save format selection: mill in vs. physical
    
   //commented out save a physical on 5/17/17
    
    scanHasBeenSaved=TRUE;  //reset to FALSE in scanPressed
    //[self saveScanButtonTitleChange];
    
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
    NSLog(@"Using filename for file2write at saveAsFileAction: %@",file2Write);
    //say to handle where's the file to write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
    outputString=nil;
    
    //now flush millTo and millFrom
    obj.millTo=@"";
    obj.millFrom=@"";
    saveScans.enabled=FALSE;
    noteToUser.text=@"Scan saved so button disabled.";
    
    /*
     NSFileHandle *handle;
     handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
     NSLog(@"Using filename for file2write at saveAsFileAction: %@",file2write);
     //say to handle where's the file to write
     [handle truncateFileAtOffset:[handle seekToEndOfFile]];
     //position handle cursor to the end of file
     [handle writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
     outputString=nil;
     */
    
//    if (rawScansVisible == FALSE) {
//        resultText.text = @"";
//        [parsedView removeFromSuperview];
    
    //added Oct 17, 2017 to automatically go back to Main screen after saving
    NSLog(@"***Made it to code at end of SaveScans***");
    [self performSegueWithIdentifier:@"ReturnToScans" sender:self];
  
}
//end of saveScans--------------------------



- padString:(NSString *)stringToPad {
    stringToPad = [stringToPad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSInteger lengthToPad = 5 - stringToPad.length;
    NSLog(@"stringToPad before padding, length of trimmed: %@, %lu",stringToPad, stringToPad.length);
    
    
    if ( lengthToPad > 0 ) {
        NSLog(@"*** at length to pad/n/r");
        NSString * padding = [@"" stringByPaddingToLength:lengthToPad withString:@" " startingAtIndex:0];
        NSString * paddedString = [padding stringByAppendingString:stringToPad];
        
        return paddedString;
    } else {
        NSString *junk=@"junk";  //changed 5/12/17 from copy
        return junk;
    }
}  //end of padString----------------------------------------------------------------

- myMethodForSquaring: (NSString *)sku : (NSString *)pieceCount {
    if (sku != nil)
    {if (pieceCount != nil) {
        NSLog(@"\n*************\nSKU, pieces in squaring method: %@,%@",sku,pieceCount);
        lengthFloat= [[sku substringToIndex:2] floatValue];
        NSString *width= [[sku substringFromIndex:2] substringToIndex:2];
        widthFloat = [width floatValue];
        NSLog(@"width in squaring method %@\n", width);
        
        //check for RR in width
        if ([@"RR" isEqualToString:width]) {
            
            //TODO return after any random
            NSLog(@"this is a random!");
            if (lengthFloat == 32) piecesPerSqFloat=50;
            if (lengthFloat == 30) piecesPerSqFloat=60;
            if (lengthFloat == 28) piecesPerSqFloat=65;
            if (lengthFloat == 26) piecesPerSqFloat=80;
            if (lengthFloat == 24) piecesPerSqFloat=106;
            if (lengthFloat == 22) piecesPerSqFloat=124;
            if (lengthFloat == 20) piecesPerSqFloat=147;
            if (lengthFloat == 18) piecesPerSqFloat=176;
            if (lengthFloat == 16) piecesPerSqFloat=215;
            if (lengthFloat == 14) piecesPerSqFloat=272;
            if (lengthFloat == 12) piecesPerSqFloat=390;
            if (lengthFloat == 10) piecesPerSqFloat=536;
        } else {
            piecesPerSqFloat= 14400/(((lengthFloat-3)/2)* widthFloat);
        }
        NSLog(@"Length, Width, Pieces:  %f, %f, %@",lengthFloat, widthFloat, pieceCount);
        
        //return a string of square
        sqFloat = [pieceCount floatValue]/piecesPerSqFloat;
        sku=nil;
        pieceCount=nil;
        piecesPerSqFloat=0;
        widthInt=0;
        NSString *square = [NSString stringWithFormat:@"%.2f",sqFloat];//((sqFloat * 100 + 0.5)/100.0)];
        [self padString:square];
        NSLog(@"square returned from squaring method: %@",square);
        return square;
    }
    } else {return @"";}
    return @"";
}//end of myMethodForSquaring---------------------------------------------------------------

- (void) showParsed{
    NSLog(@"made it to showParsed");
    
    
    if (scanContents.length <1) {
        scanContents= @"(6DUGNS241825bkyn  111P241625BKYN   90P241425BKYN   80P241225BKYN   70P181025BKYN   60P180925BKYN   50P MG010506-24-2012)  SMU]";
        
        NSLog(@"Loading dummy scan /n");
    }
    NSLog(@"about to do parseIt");

/*-----------removed in ESCBarcode 70 5/12/2017-------------------------
    //update text fields
    for (UIView *view in self.parsedView.subviews){
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *aTextField = (UITextField *)view;
            aTextField.delegate = self;
            aTextField.returnKeyType = UIReturnKeyDone;
            aTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            aTextField.font = [UIFont fontWithName:@"Helvetica" size:24.0];
        }
        if ([view isKindOfClass:[UILabel class]])
        {
            UILabel *aLabel = (UILabel *)view;
            //aTextField.delegate = self;
            //aTextField.returnKeyType = UIReturnKeyDone;
            //aTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            aLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        }
        
    }
 */
    if (pieces1.text.length>0){
        //sq1.text=[self padString:sq1.text];
        sq1.text=[self myMethodForSquaring:sku1.text:pieces1.text];
    } else sq1.text = nil;
    if (pieces2.text.length>0){
        sq2.text=[self myMethodForSquaring:sku2.text:pieces2.text];
    } else sq2.text = nil;
    if (pieces3.text.length>0){
        sq3.text=[self myMethodForSquaring:sku3.text:pieces3.text];
    } else sq3.text = nil;
    if (pieces4.text.length>0){
        sq4.text=[self myMethodForSquaring:sku4.text:pieces4.text];
    } else sq4.text = nil;
    if (pieces5.text.length>0){
        sq5.text=[self myMethodForSquaring:sku5.text:pieces5.text];
    } else sq5.text = nil;
    if (pieces6.text.length>0){
        sq6.text=[self myMethodForSquaring:sku6.text:pieces6.text];
        
    } else sq6.text = nil;
    
    //self.parsedView.backgroundColor = [UIColor lightGrayColor];
    
    
    [self totalUpSquares];

}// end of showParsed----------------------------------------------

- (void) totalUpSquares {
    totSqFloat = [sq1.text floatValue] + [sq2.text floatValue] +[sq3.text floatValue] + [sq4.text floatValue]+[sq5.text floatValue] + [sq6.text floatValue];
    totSq.text = [NSString stringWithFormat:@"%.2f",totSqFloat];
}// end of totalUpSquares------------------------------------------

//next from http://stackoverflow.com/questions/10119035/create-csv-file-from-array-of-data-in-ios
-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"Documents Directory= %@", documentsDirectory);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSDate *now = [[NSDate alloc] init];
    theDate = [dateFormat stringFromDate:now];
    //miscLabel.text = theDate;
    NSLog(@"\n"
          "theDate: |%@| \n"
          , theDate);
   NSLog(@"\n5.27.2018 debug point");
    
    
    userName=@"FredTest";//@5/16/17
    userName=[[UIDevice currentDevice] name];
    NSLog(@"*** userName is %@", userName);

    
    GlobalVariables *obj=[GlobalVariables getInstance];
    if (obj.scanningMillIn){
        NSLog(@"obj.ScaningMillIn = TRUE\n");
    } else {
        NSLog(@"obj.ScaningMillIn = FALSE \n");
    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        NSLog(@"In ParseView NCUserDefault scanningMillIn is on!!\n\n");
    }
    
    //NSLog(@"*** at file2Write, scanningMillin is %@", *obj.scanningMillIn);
    

     if([[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        file2Write = theDate;
        file2Write = [file2Write stringByAppendingString:(@"MillInOut-")];
        file2Write = [file2Write stringByAppendingString:userName];
        //added 5/27/2018
        NSLog(@"\n"
              "file2write: |%@| \n"
              , file2Write)
        ;

    } else {
        
    //commented out until physbin is set
    //don't forget to uncomment if stmnt above
    //physicalBin hadn't been picked and
    //scanningMillIn didn't seem to be set @5/16/17
    
        file2Write = theDate;
        file2Write = [file2Write stringByAppendingString:(@"Physical-")];
        file2Write = [file2Write stringByAppendingString:(obj.physicalBin)];
        file2Write = [file2Write stringByAppendingString:(@"-")];
        file2Write = [file2Write stringByAppendingString:userName];
    }
 
    file2Write = [file2Write stringByAppendingString:@".csv"];
    
    NSLog(@"\r\n\n***Using file2Write= %@\r\n\n",file2Write);
    obj.fileNameToPass=file2Write;  //to pass it to SetupViewController as of 5/16/17
    return [documentsDirectory stringByAppendingPathComponent:file2Write]; //@"010413file.csv"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/* tried 5/27/2018
- (IBAction) goToMill {
    [self performSegueWithIdentifier:@"mill" sender:self];

}
*/

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    GlobalVariables *obj=[GlobalVariables getInstance];
    
    UIViewController* svc = segue.sourceViewController;
 
//commented out with move to ESCBarcode101 @ 6/13/20
/*    if ([svc isKindOfClass:[CommentViewController class]])
    {
        NSLog(@"\r\n\nIn Parse This is coming from comment\r\n");
        NSLog(@"Comment is %@\r\n\n",obj.commentString);
        
    }
    
    if ([svc isKindOfClass:[MillViewController class]])
    {
        NSLog(@"***\r\n\nIn ParseView This is returninging from millView\r\n");
        NSLog(@"MillTo is %@. MillFrom is %@ ***\r\n\n",obj.millTo, obj.millFrom);
    }
 */
   
 //   else if ([sourceViewController isKindOfClass:[blueViewController class]])
 //   {
 //       NSLog(@"Coming from blue!");
 //   }
    
 //   obj.commentString=commentText.text;
 //   commentText.text=@"";
}
//NSString * NSStringFromClass (Class aClass);
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

