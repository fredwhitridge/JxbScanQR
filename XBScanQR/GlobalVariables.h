//
//  GlobalVariables.h
//  ESCBarcode70
//
//  Created by fred whitridge on 5/14/17.
//  Copyright © 2017 user. All rights reserved.
//
/*
 to call Global Variables:
 
 #import GlobalVariables.h
 GlobalVariables *obj=[GlobalVariables getInstance];
 NSLog(@"*** At Main ViewWillAppear, Color is %@ ***", obj.scanColor);
 
 */

#import <Foundation/Foundation.h>


@interface GlobalVariables : NSObject
{
NSString *scanColor;
NSString *scanTypeSelected;
bool *typeOfScanSelected;
bool *scanningMillIn;
NSString *millTo;
NSString *millFrom;
NSInteger *numSaved;
NSInteger *numLinesSaved;
NSInteger *numSquareSaved;
NSInteger *numSkus;
NSString *commentString;
NSString *physicalBin;
NSString *fileNameToPass;
    
}

//static BOOL scanTypeSelected=FALSE;

@property(nonatomic,retain)NSString *scanColor;
@property(nonatomic,retain)NSString *scanTypeSelected;
@property(nonatomic, assign)BOOL typeOfScanSelected;
@property(nonatomic, assign)BOOL *scanningMillIn;

@property(nonatomic,retain)NSString *millTo;
@property(nonatomic,retain)NSString *millFrom;
@property(nonatomic,assign)NSInteger *numSaved;
@property(nonatomic,assign)NSInteger *numLinesSaved;
@property(nonatomic,assign)NSInteger *numSquareSaved;
@property(nonatomic,assign)NSInteger *numSkus;
@property(nonatomic,retain)NSString *commentString;
@property(nonatomic,retain)NSString *physicalBin;
@property(nonatomic,retain)NSString *fileNameToPass;
@property(nonatomic,retain)NSString *rawQR;
@property(nonatomic, assign)BOOL foundQR;






+(GlobalVariables*)getInstance;

@end
