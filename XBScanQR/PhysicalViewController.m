//
//  PhysicalViewController.m
//  ESCBarcode81
//
//  Created by fred whitridge on 5/15/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "PhysicalViewController.h"
#import "GlobalVariables.h" //to access global vars

@interface PhysicalViewController (){
    NSArray *_pickerData;
}

@end

@implementation PhysicalViewController 

- (void) viewWillAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        self.view.backgroundColor =[UIColor greenColor];
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        self.view.backgroundColor =[UIColor blueColor];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GlobalVariables *obj=[GlobalVariables getInstance];
    obj.typeOfScanSelected = TRUE;
    //also set to true in setupView on millOrPhysicalSwitch change
    
    self.picker1=[[NSArray alloc] initWithObjects:@"MG_Mill",@"GV_Mill",@"MG0101",@"MG0201",@"MG0202",@"MG0301",@"MG0302",@"MG0401",@"MG0402",@"MG0501",@"MG0502",@"MG0601",@"MG0602",@"MG0701",@"MG0702",@"NE0101",nil];
    
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.layer.borderColor = [UIColor blackColor].CGColor;
    self.picker.layer.borderWidth = 2;

}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_picker1 count];
        
    }
    
    return [_picker1 count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    //For one component (column)
    return [_picker1 objectAtIndex:row];
    
    }
//cature the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    GlobalVariables *obj=[GlobalVariables getInstance];
    
    if (component == 0) {
        self.physBin.text=[_picker1 objectAtIndex:row];
        obj.physicalBin=self.physBin.text;
        return;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
