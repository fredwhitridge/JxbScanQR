//
//  SetupViewController.m
//  ESCBarcode70
//
//  Created by fred whitridge on 5/12/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "SetupViewController.h"
#import "GlobalVariables.h"
#import <MessageUI/MessageUI.h>

@interface SetupViewController ()

@end

@implementation SetupViewController

@synthesize Test;

- (void) viewWillAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        self.view.backgroundColor =[UIColor greenColor];
        [self.millOrPhysicalSwitch setOn:YES animated:YES];
    }
    
    //if scanningMillIn is FALSE
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        self.view.backgroundColor =[UIColor blueColor];
        [self.millOrPhysicalSwitch setOn:NO animated:YES];
        GlobalVariables *obj=[GlobalVariables getInstance];
        NSString *physbin = obj.physicalBin;
        physbin = [physbin stringByAppendingString:@" = Physical Bin"];
        Test.text = physbin;
        NSLog(@"*** At Setup, Phys Bin is %@ ***", obj.physicalBin);

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //_millOrPhysicalSwitch=FALSE;
    GlobalVariables *obj=[GlobalVariables getInstance];
    //Test.text=obj.scanColor;
    //next overrides choice beween mill and physical
    
  /*  obj.scanColor=@"green";
    NSLog(@"*** from ParseIt ViewdidLoad, Color is %@ ***", obj.scanColor);
    if ([obj.scanColor  isEqual: @"green"])
    {self.view.backgroundColor =[UIColor greenColor];}
    
    if ([obj.scanColor  isEqual: @"green"])
    {self.view.backgroundColor =[UIColor greenColor];

            if ([obj.scanColor  isEqual: @"Red!"])
            {self.view.backgroundColor =[UIColor redColor];}
    Test.text=obj.scanColor;
    // Do any additional setup after loading the view.
    */

    [_millOrPhysicalSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)millOrPhysical:(id)sender {
   
    
    GlobalVariables *obj=[GlobalVariables getInstance];
    if ([sender isOn]) {
        NSLog(@"*** millOrPhysical is on");
        obj.scanColor= @"green";
        self.view.backgroundColor =[UIColor greenColor];
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"scanningMillIn"];

    } else {
        NSLog(@"*** millOrPhysical is off");
        self.view.backgroundColor =[UIColor blueColor];
        obj.scanColor= @"blue";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"scanningMillIn"];

        

    }
    Test.text=obj.scanColor;
    obj.scanTypeSelected=@"TRUE";  //scan type won't be reset in mid-program so no need to check this before switch method is checked
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"scanningMillIn"]) {
        NSLog(@"At SetupView scanningMillIn is on!!");
    }
}

-(NSString *)dataFilePath {
    GlobalVariables *obj=[GlobalVariables getInstance];

       //old as of 5/19/17
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
    path = [path stringByAppendingPathComponent:obj.fileNameToPass];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        //File exists
        NSData *file1 = [[NSData alloc] initWithContentsOfFile:path];
        if (file1)
        {
            NSLog(@"\r\n\n-------#3 Path name is %@", path);
            return path;
        }
    }
    else
    {
        NSLog(@"File does not exist");
        NSLog(@"\r\n\n-------#4 Path name is %@", path);

    }
    
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"myfile.csv"];
     */
    return path;
}

//now mail it
//from http://mobile.tutsplus.com/tutorials/iphone/mfmailcomposeviewcontroller/?search_index=1
- (IBAction)openMail:(id)sender
{
    GlobalVariables *obj=[GlobalVariables getInstance];
    NSString *file2write=obj.fileNameToPass;
    NSLog(@"\r\n\n*** At setup, fileNameToPass is: %@", obj.fileNameToPass);

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSString *deviceName= @"Scans From: ";
        deviceName = [deviceName stringByAppendingString:[[UIDevice currentDevice] name]];
        [mailer setSubject: deviceName];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"shumphrey@evergreenslate.com", nil];
        [mailer setToRecipients:toRecipients];  //shumphrey@evergreenslate.com
        
        NSArray *ccRecipients = [NSArray arrayWithObjects:@"lisafogo@evergreenslate.com",@"fred@whitridge.us", nil];
      //  [mailer setCcRecipients:ccRecipients];
        
        //need to create "dataFilePath", stmnt copied from ParseViewController
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
            [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
            NSLog(@"*** Path created at SetupViewController");
        }

        
        [mailer addAttachmentData:[NSData dataWithContentsOfFile:[self dataFilePath]] mimeType:@"text.csv" fileName:obj.fileNameToPass];
        
        NSLog(@"\r\n\n*** file2write while adding attachment %@***\r\n\n",file2write);
        
        NSString *emailBody = @"Test2 from the ESC Barcode app";
        [mailer setMessageBody:emailBody isHTML:NO];
    //    [self presentModalViewController:mailer animated:YES];/ /deprecated in IOS 6.0
        [self presentViewController:mailer animated:YES completion:nil];
       // [self dismissViewControllerAnimated:YES completion:nil];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

// 5/17/17 attempt to fix dismissing popup after sending mail
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            //Email sent
            break;
        case MFMailComposeResultSaved:
            //Email saved
            break;
        case MFMailComposeResultCancelled:
            //Handle cancelling of the email
            break;
        case MFMailComposeResultFailed:
            //Handle failure to send.
            break;
        default:
            //A failure occurred while completing the email
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)Directory:(id)sender{
    [self listAllCsvFiles];
}

-(void) listAllCsvFiles   {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError * error;
    NSArray * directoryContents = [[NSArray alloc] init];
    
    directoryContents =  [[NSFileManager defaultManager]
                          contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    NSLog(@"====== directoryContents ====== %@",directoryContents);
    
}

- (void)setState:(id)sender
{
    //to catch millOrPhysicalSwitch change
    GlobalVariables *obj=[GlobalVariables getInstance];
    obj.typeOfScanSelected = TRUE;
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"MILL" : @"PHYS";
    NSLog(@"millOrPhysicalSwitch: %@", rez);
}



@end
