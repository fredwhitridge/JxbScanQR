//
//  SetupViewController.h
//  ESCBarcode70
//
//  Created by fred whitridge on 5/12/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h" //to access global vars


@interface SetupViewController : UIViewController
- (IBAction)millOrPhysical:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *Test;
@property (weak, nonatomic) IBOutlet UISwitch *millOrPhysicalSwitch;


@end
