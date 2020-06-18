//
//  GlobalVariables.m
//  ESCBarcode70
//
//  Created by fred whitridge on 5/14/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "GlobalVariables.h"





@implementation GlobalVariables
@synthesize scanColor;
@synthesize scanTypeSelected;

static GlobalVariables *instance = nil;

+(GlobalVariables *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [GlobalVariables new];
        }
    }
    return instance;
}

@end
