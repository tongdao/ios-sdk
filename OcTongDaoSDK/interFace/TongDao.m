//
//  TongDao.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/22.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TongDao.h"
#import "TdDataTool.h"
#import "TongDaoBridge.h"
#import "SingleForAnonymous.h"
@implementation TongDao
/**
 初始化同道服务
 
 :param: appKey 开发者从同道平台获得的AppKey
 
 :returns: Bool 同道服务的初始化结果
*/
+(BOOL)initSdkWithSdk:(NSString*)appKey{
    NSString* userId = [TongDao generateUserId];

    if ([appKey isEqualToString:@""] || [userId isEqualToString:@""]) {
        return NO;
    }else{
        [SingleForAnonymous sharedSingleForAnonymous].isAnonymous = YES;
        [[TdDataTool sharedTdDataTool] saveUuidAndKey:appKey userID:userId];
        return [[TongDaoBridge sharedTongDaoBridge] initSdk:appKey];
    }
}
+(BOOL)initSdkWithSdk:(NSString *)appKey andUserID:(NSString*)userId{
    
    if ([appKey isEqualToString:@""] || [userId isEqualToString:@""]) {
        return NO;
    }else{
        [SingleForAnonymous sharedSingleForAnonymous].isAnonymous = NO;
        [[TdDataTool sharedTdDataTool] saveUuidAndKey:appKey userID:userId];
        return [[TongDaoBridge sharedTongDaoBridge] initSdk:appKey];
    }
}
+(void)setUserId:(NSString*)userId{
    [[TongDaoBridge sharedTongDaoBridge] mergeUserId:userId];
}
+(void)setDeeplinkDictionary:(NSMutableDictionary*)dictionary{
    [[TongDaoBridge sharedTongDaoBridge]setDeeplinkDictionary:dictionary];
}

+(NSMutableDictionary*)getDeeplinkDictionary{
    return [[TongDaoBridge sharedTongDaoBridge]getDeeplinkDictionary];
    return nil;
}
/**
 获得同道SDK产生的userId
 
 :returns: 生成的userId
 */
+(NSString*)generateUserId{
    return [[TdDataTool sharedTdDataTool] generateUserId];
}
/**
 注册track返回的错误
 
 :param: OnErrorListener 返回的错误接口
 */
+(void)registerErrorListener:(id<OnErrorListener>)onErrorListener{
    [[TongDaoBridge sharedTongDaoBridge] registerErrorListener:onErrorListener];
}
/**
 下载应用广告页面信息
 
 :param: pageid 广告页面的id
 :param: OnDownloadPageListener? 结果回调接口
 
 如果需要更新界面,建议在结果回调接口中使用 dispatch_async(dispatch_get_main_queue(), {
 更新界面的方法
 })
 */
+(void)downloadPage:(NSInteger)pageId downloadListener:(id<OnDownloadPageListener>)downloadListener{
    [[TongDaoBridge sharedTongDaoBridge]downloadPage:pageId downloadListener:downloadListener];
}
/**
 下载应用消息
 
 :param: OnDownloadInAppMessageListener? 结果回调接口
 
 如果需要更新界面,建议在结果回调接口中使用 dispatch_async(dispatch_get_main_queue(), {
 更新界面的方法
 })
 */
+(void)downloadInAppMessage:(id<OnDownloadInAppMessageListener>)inAppMessageListener{
    [[TongDaoBridge sharedTongDaoBridge]downloadInAppMessage:inAppMessageListener];
}

+(void)trackEventName:(NSString*)eventName{
    [[TongDaoBridge sharedTongDaoBridge]track:eventName];
}

+(void)trackEventName:(NSString *)eventName values:(NSMutableDictionary *)values{
    [[TongDaoBridge sharedTongDaoBridge]track:eventName values:values];
}

+(void)onSessionStartWithController:(UIViewController *)viewController{
    [[TongDaoBridge sharedTongDaoBridge] onSessionStart:viewController];
}

+(void)onSessionStartWithPageName:(NSString *)pageName{
    [[TongDaoBridge sharedTongDaoBridge] onSessionStartWithPageName:pageName];
}

+(void)onSessionEndWithController:(UIViewController *)viewController{
    [[TongDaoBridge sharedTongDaoBridge]onSessionEnd:viewController];
}

+(void)onSessionEndWithPageName:(NSString *)pageName{
    [[TongDaoBridge sharedTongDaoBridge]onSessionEndWithPageName:pageName];
}

/**
 保存用户多个自定义属性
 
 :param: values 用户的属性键值对(值支持字符串和数字)
 */
+(void)identify:(NSMutableDictionary*)values{
    [[TongDaoBridge sharedTongDaoBridge] identify:values];
}

/**
 保存用户单个自定义属性
 
 :param: name 属性名
 :param: value 属性值(值支持字符串和数字)
 */
+(void)identifyWithName:(NSString*)name Andvalue:(id)value{
    [[TongDaoBridge sharedTongDaoBridge]identifyWithName:name andValue:value];
}

/**
 保存用户的推送Token到同道平台，同道将根据用户Token推送信息
 
 :param: push_token 用户的推送Token
 */
+(void)identifyPushToken:(NSString*)pushTpken{
    [[TongDaoBridge sharedTongDaoBridge]identifyPushToken:pushTpken];
}

/**
 保存用户全名
 
 :param: fullName 用户全名
 */
+(void)identifyFullName:(NSString*)fullName{
    [[TongDaoBridge sharedTongDaoBridge]identifyFullName:fullName];
}

/**
 保存用户名字属性
 
 :param: firstName 名
 :param: lastName 姓
 */
+(void)identifyFullNameWithfirstName:(NSString*)firstName andLastName:(NSString*)lastName{
    [[TongDaoBridge sharedTongDaoBridge]identifyFullNameWithFirstName:firstName andLastName:lastName];
}

/**
 保存用户应用中的名字
 
 :param: userName 用户应用中的名字
 */
+(void)identifyUserName:(NSString*)userName{
    [[TongDaoBridge sharedTongDaoBridge]identifyUserName:userName];
}

/**
 保存用户邮件地址
 
 :param: email 用户邮件地址
 */
+(void)identifyEmail:(NSString*)email{
    [[TongDaoBridge sharedTongDaoBridge] identifyEmail:email];
}

/**
 保存用户电话号码
 
 :param: phoneNumber 用户电话号码
 */
+(void)identifyPhone:(NSString*)phoneNumber{
    [[TongDaoBridge sharedTongDaoBridge] identifyPhone:phoneNumber];
}

/**
 保存用户性别
 
 :param: gender 用户性别(枚举类型)
 */
//+(void)identifyGender:(Gender)gender;


/**
 保存用户性别(Objective-C)
 
 :param: gender 用户性别(字符串类型，具体请参考Gender enum)
 */
+(void)identifyGender:(NSString*)gender{
    if ([[gender lowercaseString] isEqualToString:@"male"] || [[gender lowercaseString] isEqualToString:@"female"]) {
        [[TongDaoBridge sharedTongDaoBridge]identifyGender:gender.lowercaseString];
    }
}

/**
 保存用户年龄
 
 :param: age 用户年龄
 */
+(void)identifyAge:(NSInteger)age{
    [[TongDaoBridge sharedTongDaoBridge]identifyAge:age];
}

/**
 保存用户头像链接地址
 
 :param: url 用户头像链接地址
 */
+(void)identifyAvatar:(NSString*)url{
    [[TongDaoBridge sharedTongDaoBridge]identifyAvatarWithUrl:url];
}

/**
 保存用户联系地址
 
 :param: address 用户联系地址
 */
+(void)identifyAddress:(NSString*)address{
    [[TongDaoBridge sharedTongDaoBridge]identifyAddress:address];
}

/**
 保存用户出生日期
 
 :param: date 用户出生日期
 */
+(void)identifyBirthday:(NSDate*)date{
    [[TongDaoBridge sharedTongDaoBridge]identifyBirthday:date];
}

/**
 保存用户应用源信息
 
 :param: tdSource 用户应用源信息对象
 */
+(void)identifySource:(TdSource*)tdSource{
    [[TongDaoBridge sharedTongDaoBridge]identifySource:tdSource];
}

/**
 跟踪应用评分
 
 :param: rating 应用评分
 */
+(void)identifyRating:(NSInteger)rating{
    [[TongDaoBridge sharedTongDaoBridge] identifyRating:rating];
}

/**
 跟踪应用注册日期
 
 :param: date 用户设置的日期对象
 */
+(void)trackRegistration:(NSDate*)date{
    [[TongDaoBridge sharedTongDaoBridge]trackRegistration:date];
}

/**
 跟踪应用注册日期(使用当前系统时间,无日期参数)
 */
+(void)trackRegistration{
    [[TongDaoBridge sharedTongDaoBridge]trackRegistration];
}

/**
 跟踪浏览商品类别
 
 :param: category 商品类别
 */
+(void)trackViewProductCategory:(NSString*)category{
    [[TongDaoBridge sharedTongDaoBridge] trackViewProductCategory:category];
}

/**
 跟踪浏览商品信息
 
 :param: product 商品信息
 */
+(void)trackViewProduct:(TdProduct*)tdProduct{
    [[TongDaoBridge sharedTongDaoBridge]trackViewProduct:tdProduct];
}

/**
 跟踪添加多个订单到购物车
 
 :param: orderLines 订单列表
 */
+(void)trackAddCarts:(NSArray*)orderLines{
    [[TongDaoBridge sharedTongDaoBridge] trackAddCart:orderLines];
}

/**
 跟踪添加单个订单到购物车
 
 :param: orderLine 单个订单
 */
+(void)trackAddCart:(TdOrderLine*)orderLine{
    NSMutableArray* orderLines = [[NSMutableArray alloc]init];
    [orderLines addObject:orderLine];
    [self trackAddCarts:orderLines];
}

/**
 跟踪从购物车删除多个订单
 
 :param: orderLines 订单列表
 */
+(void)trackRemoveCarts:(NSArray*)orderLines{
    [[TongDaoBridge sharedTongDaoBridge] trackRemoveCart:orderLines];
}

/**
 跟踪从购物车删除单个订单
 
 :param: orderLine 单个订单
 */
+(void)trackRemoveCart:(TdOrderLine*)tdOrderLine{
    NSMutableArray* orderLines = [[NSMutableArray alloc]init];
    [orderLines addObject:tdOrderLine];
    [self trackRemoveCarts:orderLines];
}

/**
 跟踪提交的交易信息
 
 :param: order 交易信息
 */
+(void)trackPlaceOrder:(TdOrder*)order{
    [[TongDaoBridge sharedTongDaoBridge]trackPlaceOrder:order];
}

/**
 
 跟踪提交的交易信息
 
 :param: name 产品名称
 :param: price 产品价格
 :param: currency 产品货币
 :param: quantity 产品个数
 */
+(void)trackPlaceOrderWithName:(NSString*)name price:(float)price currency:(NSString*)currency quantity:(NSInteger)quantity{
    if ([name isEqualToString:@""] || price <= 0 || quantity <= 0) {
        return;
    }
    
    TdProduct* tempProduct = [[TdProduct alloc]initWithProductId:nil sku:nil name:name price:price currency:currency category:nil];
    TdOrderLine* tempOrderLine = [[TdOrderLine alloc]initWithProduct:tempProduct andQuantity:quantity];
    NSMutableArray* orderLines = [[NSMutableArray alloc]init];
    [orderLines addObject:tempOrderLine];
    
    TdOrder* order = [[TdOrder alloc]init];
    order.total = price*quantity;
    order.currency = currency;
    order.orderList = orderLines;
    
    [[TongDaoBridge sharedTongDaoBridge]trackPlaceOrder:order];
}

/**
 
 跟踪提交的交易信息，产品个数默认为1
 :param: name 产品名称
 :param: price 产品价格
 :param: currency 产品货币
 */
+(void)trackPlaceOrderWithName:(NSString *)name price:(float)price currency:(NSString *)currency{
    [self trackPlaceOrderWithName:name price:price currency:currency quantity:1];
}

/**
 获得SDK存储的AppKey
 
 :returns: appKey
 */
+(NSString*)getAppKey{
    return [[TdDataTool sharedTdDataTool] getAppKey];
}
#pragma mark 未完成的方法
+(NSString*)getDataWithUrl:(NSURL*)url andDataUrl:(NSString*)dataUrl{
    NSString* path  = [url absoluteString];
    if (path) {
        NSRange range = [path rangeOfString:dataUrl];
        if (range.length>0) {
//            NSInteger intindex = range.length;
            
        }

    }
    return nil;
}

//	scheme://any_deeplink?0Qpage=page_id
//	scheme://any_deeplink?0Qpromotion=promotion_id

/**
 
 通过包含Deeplink的NSURL取得广告的PageId
 
 :param: url 包含Deeplink的NSURL
 :returns: 广告的PageId
 */
+(NSString*)getPageIdWithUrl:(NSURL*)url{
    if (url != nil) {
        return [self getDataWithUrl:url andDataUrl:@"0Qpage="];
    }
    return nil;
}
/**
 跟踪用户打开了同道的推送消息
 :param: userInfo 推送消息的附加信息
 */
+(void)trackOpenMesageForTongDaoPush:(NSDictionary *)userInfo{
//    NSLog(@"进入了同道的推送函数中");
    [self trackOpenMessageForBaiduAndJPush:userInfo];
}

/**
 
 跟踪用户打开了百度或JPush推送消息(已过时，请使用trackOpenPushMessageForBaiduAndJPush)
 
 :param: userInfo 推送消息的附加信息
 
 */
+(void)trackOpenMessageForBaiduAndJPush:(NSDictionary*)userInfo{
    if (userInfo == nil) {
        return;
    }
//    NSLog(@"这是trackOpenMessageForBaiduAndJPush函数");
    NSNumber* tempmsgId = [userInfo valueForKey:@"tongrd_mid"];
    NSNumber* tempcliId = [userInfo valueForKey:@"tongrd_cid"];
    
    if (tempmsgId == nil || tempcliId == nil) {
        return;
    }
    
    NSInteger msgId = [tempmsgId integerValue];
    NSInteger cliId = [tempcliId integerValue];
    
    if (msgId != 0 && cliId != 0) {
//        NSLog(@"这是sendOpenMessageWithEventName名字叫做open_message");
        [self sendOpenMessageWithEventName:@"!open_message" andMid:msgId andCid:cliId];
    }
    
}

/**
 
 跟踪用户打开了百度或JPush推送消息
 
 :param: userInfo 推送消息的附加信息
 
 */
+(void)trackOpenPushMessageForBaiduAndJPush:(NSDictionary*)userInfo{
    [self trackOpenMessageForBaiduAndJPush:userInfo];
}

/**
 
 跟踪用户打开了个推推送消息(已过时，请使用trackOpenPushMessageForGeTui)
 
 :param: userInfo 推送消息的附加信息
 
 */
+(void)trackOpenMessageForGeTui:(NSDictionary*)userInfo{
    if (userInfo == nil) {
        return;
    }
    
    NSString*tempData = [userInfo valueForKey:@"payload"];
    
    if (tempData == nil) {
        return;
    }
    
    NSData* data = [tempData dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data == nil) {
        return;
    }
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    [self trackOpenMessageForBaiduAndJPush:dic];
}

/**
 
 跟踪用户打开了个推推送消息
 
 :param: userInfo 推送消息的附加信息
 
 */
+(void)trackOpenPushMessageForGeTui:(NSDictionary*)userInfo{
    [self trackOpenMessageForGeTui:userInfo];
}

/**
 跟踪用户点击了应用内消息
 
 :param tdMessageBean 同道返回的TdMessageBean
 */
+(void)trackOpenInAppMessage:(TdMessageBean*)tdMessageBean{
    if (tdMessageBean == nil) {
        return;
    }
    
    NSNumber* messageId = tdMessageBean.mid;
    NSNumber* clientId = tdMessageBean.cid;
    
    if (messageId != nil && clientId != nil) {
        NSInteger mid = [messageId integerValue];
        NSInteger cid = [clientId integerValue];
        if (mid == 0 || cid == 0) {
            return;
        }else{
            [self sendOpenMessageWithEventName:@"!open_message" andMid:mid andCid:cid];
        }
    }
}

/**
 跟踪用户收到了应用内消息
 
 :param tdMessageBean 同道返回的TdMessageBean
 */
+(void)trackReceivedInAppMessage:(TdMessageBean*)tdMessageBean{
    if (tdMessageBean == nil) {
        return;
    }
    
    NSNumber* messageId = tdMessageBean.mid;
    NSNumber* clientId = tdMessageBean.cid;
    
    if (messageId != nil && clientId != nil) {
        NSInteger mid = [messageId integerValue];
        NSInteger cid = [clientId integerValue];
        
        if (mid == 0 || cid == 0) {
            return;
        }else{
            [self sendOpenMessageWithEventName:@"!receive_message" andMid:mid andCid:cid];
        }
    }
}


+(void)sendOpenMessageWithEventName:(NSString*)eventName andMid:(NSInteger)mid andCid:(NSInteger)cid{
    [[TongDaoBridge sharedTongDaoBridge] sendOpenMessageWithEventName:eventName andMid:mid andCid:cid];
}





@end
