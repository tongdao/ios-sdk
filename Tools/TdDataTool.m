//
//  TdDataTool.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AdSupport/AdSupport.h>
#import <AdSupport/ASIdentifierManager.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "TdDataTool.h"
#import "sys/utsname.h"
#import "TongDaoReachability.h"
#import "NSString+MD5.h"
#import "TdOrderLine.h"
//#import

//#define DeviceList @{@"iPod5,1": @"iPod Touch 5",@"iPhone3,1":@"iPhone 4",@"iPhone3,2":@"iPhone 4",@"iPhone3,3":@"iPhone 4",@"iPhone4,1":@"iPhone 4S",@"iPhone5,1":@"iPhone 5",@"iPhone5,2":@"iPhone 5",@"iPhone5,3":@"iPhone 5C", @"iPhone5,4":@"iPhone 5C",@"iPhone6,1":@"iPhone 5S",@"iPhone6,2":@"iPhone 5S",@"iPhone7,2":@"iPhone 6",@"iPhone7,1": @"iPhone 6 Plus",@"iPad2,1":@"iPad 2",@"iPad2,2":@"iPad 2",@"iPad2,3":@"iPad 2",@"iPad2,4":@"iPad 2",@"iPad3,1":@"iPad 3",@"iPad3,2":@"iPad 3",@"iPad3,3":@"iPad 3",@"iPad3,4":@"iPad 4",@"iPad3,5":@"iPad 4",@"iPad3,6":@"iPad 4",@"iPad4,1": @"iPad Air",@"iPad4,2":@"iPad Air",@"iPad4,3":@"iPad Air",@"iPad5,1":@"iPad Air 2",@"iPad5,3":@"iPad Air 2",@"iPad5,4": @"iPad Air 2",@"iPad2,5":@"iPad Mini",@"iPad2,6":@"iPad Mini",@"iPad2,7":@"iPad Mini",@"iPad4,4":@"iPad Mini",@"iPad4,5": @"iPad Mini",@"iPad4,6":@"iPad Mini",@"iPad4,7":@"iPad Mini",@"iPad4,8":@"iPad Mini",@"iPad4,9":@"iPad Mini",@"x86_64": @"Simulator",@"i386":@"Simulator"}
@implementation TdDataTool

singleton_implementation(TdDataTool)
-(NSString*)generateUserId{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [userDefaults stringForKey:@"TD_USER_ID"];
    if (userId) {
        return userId;
    }else{
        return [UIDevice currentDevice].identifierForVendor.UUIDString;
    }
}

-(void)saveUuidAndKey:(NSString*)appKey userID:(NSString*)userId{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:appKey forKeyPath:@"APP_KEY"];
    [userDefaults setValue:userId forKeyPath:@"TD_USER_ID"];
    [userDefaults synchronize];
}

-(NSString*)getAppURL{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"API_URL"];
}
-(NSString *)getAppKey{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"APP_KEY"];
}
-(NSString*)getUUID{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"TD_USER_ID"]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:@"TD_USER_ID"];
    }
    return nil;
}
-(NSMutableArray*)getDeviceInfo{
    NSMutableArray *infoList = [[NSMutableArray alloc]initWithCapacity:10];
    [infoList addObject:[self getModelName]];
    [infoList addObject:@"Apple"];
    [infoList addObject:[UIDevice currentDevice].name];
    [infoList addObject:@"ios"];
    [infoList addObject:[UIDevice currentDevice].systemVersion];
    [infoList addObject:[NSNumber numberWithInteger:(NSInteger)[UIScreen mainScreen].bounds.size.width*2]];
    [infoList addObject:[NSNumber numberWithInteger:(NSInteger)[UIScreen mainScreen].bounds.size.height*2]];
    [infoList addObject:[NSLocale preferredLanguages][0]];
    return infoList;
}
#pragma mark  为实现完成的方法
-(NSString*)getModelName{
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
#pragma mark  为实现完成的方法
-(NSMutableArray*)getAppInfor{
    NSMutableArray* infoList = [[NSMutableArray alloc]initWithCapacity:10];
    id code = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
    if (code) {
        [infoList addObject:code];
    }else{
        [infoList addObject:@0];
    }
    
    id name = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (name) {
        [infoList addObject:name];
    }else{
        [infoList addObject:@""];
    }
    
   NSString* device = [UIDevice currentDevice].systemVersion;
    NSInteger d = [device integerValue];
    [infoList addObject:[NSNumber numberWithInteger:d]];
    return infoList;
}

-(NSMutableArray*)getConnectInfo{
    NSMutableArray* infoList = [[NSMutableArray alloc]initWithCapacity:10];
    NSString* connectType = @"unknown";
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    switch ([[TongDaoReachability reachabilityWithAddress:&zeroAddress] currentReachabilityStatus]) {
        case ReachableViaWiFi:
            connectType = @"wifi";
            break;
            case ReachableViaWWAN:
            connectType = @"celluar";
            break;
            case NotReachable:
            connectType = @"others";
            break;
        default:
            break;
    }
    [infoList addObject:connectType];
    [infoList addObject:@0];
    
    id cttelephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc]init];
    NSString* carrierName = [cttelephonyNetworkInfo subscriberCellularProvider].carrierName;
    NSString* countryCode = [cttelephonyNetworkInfo subscriberCellularProvider].mobileCountryCode;
    NSString* networkCode = [cttelephonyNetworkInfo subscriberCellularProvider].mobileNetworkCode;
    
    NSString* carrierCode = @"0";
    if (carrierName==nil) {
        [infoList addObject:@""];
    }else{
        [infoList addObject:carrierName];
    }
    
    if (countryCode==nil||networkCode==nil ) {
        carrierCode=@"0";
    }else{
        carrierCode = [countryCode stringByAppendingString:networkCode];
    }
    
    [infoList addObject:carrierCode];
    return infoList;
}

-(NSMutableArray*)getFingerPrintInfo{

    NSMutableArray* infoList = [[NSMutableArray alloc]initWithCapacity:10];
    [infoList addObject:@"ios"];
    //for idfv
    NSString* idfvString = [UIDevice currentDevice].identifierForVendor.UUIDString.lowercaseString;
    [infoList addObject:idfvString];
    [infoList addObject:[idfvString md5String].lowercaseString];
    [infoList addObject:[idfvString sha1String].lowercaseString];
    //for idfa
    NSString* idfaString = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString.lowercaseString;
    [infoList addObject:idfaString];
    [infoList addObject:[idfaString md5String].lowercaseString];
    [infoList addObject:[idfaString sha1String].lowercaseString];
    
    return infoList;
}

-(NSString*)getTimeStamp{
    NSDate* newdate = [[NSDate alloc]init];
    return [self getTimeStamp:newdate];
}

-(NSString*)getTimeStamp:(NSDate*)newDate{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormat.timeZone = [[NSTimeZone alloc]initWithName:@"UTC"];
    return [dateFormat stringFromDate:newDate];
}

-(void)getAllLocationInfo:(NSArray*)loc tdLocationCallback:(id<TdLocationCallback>)tdLocationCallback{
//    NSMutableArray* inforList = [[NSMutableArray alloc]initWithCapacity:10];
    NSString* connectType = @"unknown";
    struct sockaddr_in locationZeroAddress;
    bzero(&locationZeroAddress, sizeof(locationZeroAddress));
    locationZeroAddress.sin_len = sizeof(locationZeroAddress);
    locationZeroAddress.sin_family = AF_INET;
    switch ([[TongDaoReachability reachabilityWithAddress:&locationZeroAddress] currentReachabilityStatus]) {
        case ReachableViaWiFi:
            connectType = @"coarse";
            break;
        case ReachableViaWWAN:
            connectType = @"fine";
            break;
        case NotReachable:
            connectType = @"unknown";
            break;
        default:
            break;
    }
    NSMutableDictionary* locDic = [[NSMutableDictionary alloc]init];
    [locDic setValue:loc[0] forKey:@"!latitude"];
    [locDic setValue:loc[1] forKey:@"!longitude"];
    [locDic setValue:connectType forKey:@"!source"];
    [tdLocationCallback onSuccess:locDic];
}
-(NSMutableDictionary*)makeSourceProperties:(TdSource*)tdSource{
    if (tdSource.advertisementId != nil && tdSource.advertisementGroupId == nil && tdSource.campaignId == nil && tdSource.sourceId == nil) {
        return nil;
    }
    
    NSMutableDictionary* sourceObj = [[NSMutableDictionary alloc]init];
    
    if (tdSource.advertisementId != nil) {
        [sourceObj setValue:tdSource.advertisementId forKey:@"!ad_id"];
    }
    
    if (tdSource.advertisementGroupId != nil) {
        [sourceObj setValue:tdSource.advertisementGroupId forKey:@"!adgroup_id"];
    }
    
    if(tdSource.campaignId != nil){
        [sourceObj setValue:tdSource.campaignId forKey:@"!campaign_id"];
    }
    
    if(tdSource.sourceId != nil){
        [sourceObj setValue:tdSource.sourceId forKey:@"!source_id"];
    }
    
    NSMutableDictionary* propertiesObj = [[NSMutableDictionary alloc]init];
    [propertiesObj setValue:sourceObj forKey:@"!source"];
    return propertiesObj;
}

-(NSMutableDictionary*)makeRatingProperties:(NSInteger)rating{
    NSMutableDictionary* appObj = [[NSMutableDictionary alloc]init];
    NSNumber* ratingNum = [NSNumber numberWithInteger:rating];
    [appObj setValue:ratingNum forKey:@"!rating"];
    NSMutableDictionary* propertiesObj = [[NSMutableDictionary alloc]init];
    [propertiesObj setValue:appObj forKey:@"!application"];
    return propertiesObj;
}

-(NSMutableDictionary*)makeRegisterProperties:(NSDate*)date{
    NSString* timeString = [self getTimeStamp:date];
    NSMutableDictionary* propertiesObj = [[NSMutableDictionary alloc]init];
    [propertiesObj setValue:timeString forKey:@"!register_at"];
    return propertiesObj;
}

-(NSMutableDictionary*)makeRegisterProperties{
    NSString* timeString = [self getTimeStamp];
    NSMutableDictionary* propertiesObj = [[NSMutableDictionary alloc]init];
    [propertiesObj setValue:timeString forKey:@"!register_at"];
    return propertiesObj;
}

-(NSMutableDictionary*)makeProductProperties:(TdProduct*)product{
    if (product.productId != nil || product.sku != nil || product.name != nil || product.currency != nil || product.category != nil) {
        NSMutableDictionary* productObj = [[NSMutableDictionary alloc]init];
        
        if (product.productId != nil) {
            [productObj setValue:product.productId forKey:@"!id"];
        }
        
        if (product.sku != nil) {
            [productObj setValue:product.sku forKey:@"!sku"];
        }
        
        if (product.name != nil) {
            [productObj setValue:product.name forKey:@"!name"];
        }
        
        if (product.price) {
            NSNumber* priceNum = [NSNumber numberWithFloat:product.price];
            [productObj setValue:priceNum forKey:@"!price"];
        }
        
        if (product.currency != nil) {
           NSString* realCurrency = [[TdDataTool sharedTdDataTool]checkCurrency:product.currency];
            if (realCurrency) {
                [productObj setValue:realCurrency forKey:@"!currency"];
            }
        }
        
        if (product.category != nil) {
            [productObj setValue:product.category forKey:@"!category"];
        }
        
        if (!(productObj.allValues)) {
            return nil;
        }
        
        return productObj;
    }
    return nil;
}

-(NSMutableDictionary*)makeOrderLinesProperties:(NSArray*)orderLines{
     NSArray* tempOrderLinesArray = [self makeOrderLinesArrayProperties:orderLines];
    if (tempOrderLinesArray){
        NSMutableDictionary* propertiesObj = [[NSMutableDictionary alloc]init];
        [propertiesObj setValue:tempOrderLinesArray forKey:@"!order_lines"];
        return propertiesObj;
    }
    return nil;
}

-(NSArray*)makeOrderLinesArrayProperties:(NSArray*)orderLines{
    if(orderLines.count==0){
        return nil;
    }
    NSMutableArray* tempOrderLinesArray = [[NSMutableArray alloc]init];
    for( TdOrderLine* eachTdOrderLine in orderLines){
        TdProduct* tempProduct = eachTdOrderLine.product;
        NSInteger quantity = eachTdOrderLine.quantity;
        NSNumber* quantityNum = [NSNumber numberWithInteger:quantity];
        if (quantity>0) {
           NSMutableDictionary* tempProductObj = [self makeProductProperties:tempProduct];
            if (tempProductObj) {
                NSMutableDictionary* tempOrderLine = [[NSMutableDictionary alloc]init];
                [tempOrderLine setValue:tempProductObj forKey:@"!product"];
                [tempOrderLine setValue:quantityNum forKey:@"!quantity"];
                
                [tempOrderLinesArray addObject:tempOrderLine];
            }
        }
    }
    if (tempOrderLinesArray.count == 0) {
        return nil;
    }
    return tempOrderLinesArray;
}

-(NSMutableDictionary*)makeOrderProperties:(TdOrder*)order{
    NSString* orderId=order.orderId;
    float total=order.total;
    float revenue=order.revenue;
    float shipping=order.shipping;
    float tax=order.tax;
    float discount=order.discount;
    NSString* couponId=order.couponId;
    NSString* currency=order.currency;
    NSArray* orderlines=order.orderList;
    
    NSMutableDictionary* propertiesObj=[[NSMutableDictionary alloc]init];
    
    if (currency == nil && total <= 0){
        return nil;
    }
    
    if(orderId != nil){
        [propertiesObj setValue:orderId forKey:@"!order_id"];
    }
    
    if(total){
        propertiesObj[@"!total"]=[NSNumber numberWithFloat:total];
    }
    
    if(revenue){
        propertiesObj[@"!revenue"]=[NSNumber numberWithFloat:revenue];
    }
    
    if(shipping){
        propertiesObj[@"!shipping"]=[NSNumber numberWithFloat:shipping];
    }
    
    if(tax){
        propertiesObj[@"!tax"]=[NSNumber numberWithFloat:tax];
    }
    
    if(discount){
        propertiesObj[@"!discount"]=[NSNumber numberWithFloat:discount];
    }
    
    if(couponId != nil){
        propertiesObj[@"!coupon_id"]= couponId;
    }
    
    if(currency != nil){
        NSString* realCurrency = [self checkCurrency:currency];
        if ([self checkCurrency:currency]) {
            propertiesObj[@"!currency"]=realCurrency;
        }
    }

    
    if(orderlines != nil){
        NSArray* orderlinesArray = [self makeOrderLinesArrayProperties:orderlines];
        if (orderlinesArray){
            propertiesObj[@"!order_lines"]=orderlinesArray;
        }
    }
    
    if(propertiesObj.allValues){
        return nil;
    }
    return propertiesObj;
}

-(NSString*)checkCurrency:(NSString*)currencyCode{
    NSString* realCurrencyCode = currencyCode.uppercaseString;
    NSString* result = [[NSLocale currentLocale] displayNameForKey:NSLocaleCurrencySymbol value:realCurrencyCode];
    if (result) {
        return realCurrencyCode;
    }
    return nil;
}
@end
