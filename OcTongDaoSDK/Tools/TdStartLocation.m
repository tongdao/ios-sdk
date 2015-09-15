//
//  TdStartLocation.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/16.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdStartLocation.h"
#import "TdDataTool.h"
#import <UIKit/UIKit.h>
@implementation TdStartLocation
singleton_implementation(TdStartLocation)
-(void)start:(id<TdLocationCallback>)tdLocationCallback{
    self.tdLocationCallback = tdLocationCallback;
    self.manager = [[CLLocationManager alloc]init];
    self.isFistLocationManager = true;
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.distanceFilter = 1;
    if ([CLLocationManager locationServicesEnabled]) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
            if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_manager requestAlwaysAuthorization];
            }
        }
        [self.manager startUpdatingLocation];

    }else{
       
        NSMutableArray* locs = [[NSMutableArray alloc]init];
        [locs addObject:@0.00];
        [locs addObject:@0.00];
        [[TdDataTool sharedTdDataTool]getAllLocationInfo:locs tdLocationCallback:tdLocationCallback];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    NSArray* locationArr = locations;
    CLLocation* locationObj = locationArr.lastObject;
    CLLocationCoordinate2D coord = locationObj.coordinate;
    NSMutableArray* locs = [[NSMutableArray alloc]init];
    [locs addObject:[NSNumber numberWithFloat:coord.latitude]];
    [locs addObject:[NSNumber numberWithFloat:coord.longitude]];
    if (self.isFistLocationManager == YES) {
        [[TdDataTool sharedTdDataTool] getAllLocationInfo:locs tdLocationCallback:self.tdLocationCallback];
        [manager stopUpdatingLocation];
        self.isFistLocationManager = NO;
    }
   
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

    NSMutableArray* locs = [[NSMutableArray alloc]init];
    [locs addObject:@0.00];
    [locs addObject:@0.00];
    [[TdDataTool sharedTdDataTool]getAllLocationInfo:locs tdLocationCallback:self.tdLocationCallback];
    [manager stopUpdatingLocation];
}
@end
