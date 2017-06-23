//
//  DemoPage1.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "DemoPage1ViewController.h"
#import <TongdaoSDK/TongdaoSDK.h>
@implementation DemoPage1ViewController

- (IBAction)closeUI:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[TongDao sharedManager] onSessionStart:self];
    [[TongDao sharedManager] displayInAppMessage:self.view];
    
    // retrieve metadata
    
    // get from api http://api.taobao.com/product/metadata["product_id"]
    
    // render the view with product information
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[TongDao sharedManager] onSessionEnd:self];
}


@end
