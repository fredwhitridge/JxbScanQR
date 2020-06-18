//
//  ViewController.m
//  demoQRReader
//
//  Created by fred whitridge on 6/11/20.
//  Copyright © 2020 esco. All rights reserved.
//

#import "ViewController.h"
#import "GlobalVariables.h"
//next from XBScan 6/18/20
#import "QRCodeReaderViewController.h"

//#import "UIKit"

@interface ViewController ()<QRCodeReaderDelegate>



@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
-(void)loadBeepSound;
@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  [self loadBeepSound];
    self.title = @"Home Page";
    
    //fw commented out 6/18/20 was showing diff button from storyboard
    /*
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    [btn setTitle:@"Scan" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    */
}








    
    
    
    
   

/*
-(void)loadBeepSound{
    //NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"M4A1single" ofType:@"mp3"];
    // sound name is CASE SENSITIVE!!
    NSString *beepFilePath = [NSString stringWithFormat:@"%@/M4A1Single.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *beepURL = [NSURL fileURLWithPath:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)scanAction:(id)sender
{
    NSLog(@"Made it to scan action\n");
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];\
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    
    __weak typeof (self) wSelf = self;
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        [wSelf.navigationController popViewControllerAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"" message:resultAsString delegate:self cancelButtonTitle:@"OK?" otherButtonTitles: nil] show];
    }];
    
    [self presentViewController:reader animated:YES completion:NULL];
    [self.navigationController pushViewController:reader animated:YES];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}


    @end
    
