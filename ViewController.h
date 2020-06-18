//
//  ViewController.h
//  demoQRReader
//
//  Created by fred whitridge on 6/11/20.
//  Copyright © 2020 esco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GlobalVariables.h"

@interface ViewController : UIViewController



 


@property (strong, nonatomic) IBOutlet UIButton *Scan;
@property (strong, nonatomic) IBOutlet UIButton *Parse;


    
- (IBAction)startStopReading:(id)sender;

//for xbscan 6/18/20
- (IBAction)scanAction:(id)sender;

@end

