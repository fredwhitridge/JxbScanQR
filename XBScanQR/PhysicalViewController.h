//
//  PhysicalViewController.h
//  ESCBarcode81
//
//  Created by fred whitridge on 5/15/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhysicalViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *physBin;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

//picker 1 is first component, etc
@property (strong, nonatomic) NSArray *picker1;

@end
