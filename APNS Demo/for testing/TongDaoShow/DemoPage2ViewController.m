//
//  DemoPage2ViewController.m
//  TongDaoShow
//
//  Created by bin jin on 5/9/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "DemoPage2ViewController.h"
#import <TongdaoSDK/TongdaoSDK.h>
@interface DemoPage2ViewController ()

@end

@implementation DemoPage2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)closeUI:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[TongDao sharedManager] onSessionStart:self];
    [[TongDao sharedManager] displayInAppMessage:self.view];
    [[TongDao sharedManager]identifyEmail:@"haha@gmail.com"];
    [[TongDao sharedManager]identifyPhone:@"+13787231843"];
    [[TongDao sharedManager]identifyWithKey:@"favoritSport" andValue:@"basketball"];
    [[TongDao sharedManager]trackWithEventName:@"finishLevel"];
//    [[TongDao sharedManager]identifyGender:MALE];
//    [[TongDao sharedManager]identifyGender:FEMALE];
    NSString* name = @"VIP Package";
    float price = 10.0f;
    NSString* currency = @"CNY";
    int quantity = 2;
    [[TongDao sharedManager]trackPlaceOrder:name andPrice:price andCurrency:currency andQuantity:quantity];
    
    TdProduct* product = [[TdProduct alloc]init];
    product.name = @"E-reader";
    product.price = 100.0;
    
    TdOrderLine* orderLine1 = [[TdOrderLine alloc]init];
    orderLine1.product = product;
    orderLine1.quantity = 2;
    
    TdOrderLine* orderLine2 = [[TdOrderLine alloc]init];
    orderLine2.product = product;
    orderLine2.quantity = 3;
    
    NSArray* OrderLines = @[orderLine1,orderLine2];
    
    TdOrder* order = [[TdOrder alloc]init];
    order.currency = @"CNY";
    order.orderId = @"1234";
    order.total = 200.0;
    order.orderList = OrderLines;
    
    [[TongDao sharedManager]trackPlaceOrder:order];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[TongDao sharedManager] onSessionEnd:self];
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
