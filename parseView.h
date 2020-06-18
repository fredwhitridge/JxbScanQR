//
//  parseView.h
//  ESCBarcode101
//
//  Created by fred whitridge on 6/12/20.
//  Copyright © 2020 esco. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GlobalVariables.h"



@interface parseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *slateColor;
@property (weak, nonatomic) IBOutlet UITextField *sku1;
@property (weak, nonatomic) IBOutlet UITextField *pieces1;
@property (weak, nonatomic) IBOutlet UITextField *labelDate;
@property (weak, nonatomic) IBOutlet UITextField *job;
@property (weak, nonatomic) IBOutlet UITextField *bin;
@property (weak, nonatomic) IBOutlet UITextField *pallet;
@property (weak, nonatomic) IBOutlet UITextField *sku2;
@property (weak, nonatomic) IBOutlet UITextField *sku3;
@property (weak, nonatomic) IBOutlet UITextField *sku4;
@property (weak, nonatomic) IBOutlet UITextField *sku5;
@property (weak, nonatomic) IBOutlet UITextField *sku6;
@property (weak, nonatomic) IBOutlet UITextField *pieces2;
@property (weak, nonatomic) IBOutlet UITextField *pieces3;
@property (weak, nonatomic) IBOutlet UITextField *pieces4;
@property (weak, nonatomic) IBOutlet UITextField *pieces5;
@property (weak, nonatomic) IBOutlet UITextField *pieces6;
@property (nonatomic, strong) IBOutlet UILabel *sq1;
@property (nonatomic, strong) IBOutlet UILabel *sq2;
@property (nonatomic, strong) IBOutlet UILabel *sq3;
@property (nonatomic, strong) IBOutlet UILabel *sq4;
@property (nonatomic, strong) IBOutlet UILabel *sq5;
@property (nonatomic, strong) IBOutlet UILabel *sq6;
@property (nonatomic, strong) IBOutlet UILabel *totSq;

@property (weak, nonatomic) IBOutlet UIButton *millButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIView *physicalButton;
@property (strong, nonatomic) IBOutlet UIView *rawQR;

@property (weak, nonatomic) IBOutlet UILabel *noteToUser;
@property (weak, nonatomic) IBOutlet UIButton *saveScans;

- (IBAction) unwindToMain:(id) sender;
- (IBAction) goToMill:(id) sender;  //tried 5/27/2018



@property (nonatomic, strong) NSDictionary *dicTextData;

- (void) padString;
- (void) parseIt;


@end



