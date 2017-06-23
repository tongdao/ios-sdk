//
//  TongDao.h
//  TestLayout
//
//  Created by bin jin on 11/12/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TdBridge.h"
#import "TdOrderLine.h"
#import "TdMessageBean.h"

enum TdShowTypes {
    PAGE,
    INAPPMESSAGE
};

@interface TongDao : NSObject


/*!
 *
 *@abstract 注册奖品领取结果的回调接口
 */
@property (nonatomic, copy) void (^registerOnRewardBeanUnlocked)(NSArray* rewards);

/*!
 *
 *@abstract Initialize Tongdao SDK
 *@param appKey Tongdao App Key
 *@param userId User ID
 *@param debugMode True if you want debug mode enabled
 *@return BOOL True if SDK loaded
 */
-(BOOL) initializeWithAppKey:(NSString*) appKey userId:(NSString*)userId andDebugMode:(BOOL) debugMode;

/*!
 *
 *@abstract Initialize Tongdao SDK
 *@param appKey Tongdao App Key
 *@param userId User ID
 *@param debugMode True if you want debug mode enabled
 *@return BOOL True if SDK loaded
 */
-(BOOL) initializeWithAppKey:(NSString*) appKey userId:(NSString*)userId andIgnore:(TongDaoinitData)ingoreDataType andDebugMode:(BOOL) debugMode;

-(void)loginWithUserId:(NSString*)userId;

-(void)logout;

/*!
 *@abstract 注册Track功能的回调接口
 *### TODO: THIS MIGHT BE DEPRECATED LATER ON
 *@param onErrorListener 结果回调接口
 *
 *@discussion 如果需要更新界面,建议在结果回调接口中使用 dispatch_async(dispatch_get_main_queue(), {
 * 更新界面的方法
 * })
 */
-(void) registerErrorListener:(id<OnErrorListener>)onErrorListener;

/*!
 *
 *@abstract 跟踪用户自定义事件
 *@param eventName 用户自定义事件名称(不能以!打头)
 */
-(void) trackWithEventName:(NSString*)eventName;

/*!
 *
 *@abstract 跟踪用户自定义事件
 *@param eventName 用户自定义事件名称(不能以!打头)
 *@param values 跟踪事件附带的键值对(值支持字符串和数字)
 */
-(void) trackWithEventName:(NSString *)eventName andValues:(NSDictionary*)values;

/*!
 *@abstract 开始记录用户的使用时长
 *@param viewController 当前应用程序的ViewController
 */
-(void) onSessionStart:(UIViewController*)viewController;

/*!
 *TODO: THIS MIGHT BE DEPRECATED LATER ON
 *@abstract 开始记录用户的使用时长
 *@param pageName 用户定义的页面名称
 */
-(void) onSessionStartWithPageName:(NSString*)pageName;

/*!
 *@abstract 终止记录用户的使用时长
 *@param viewController 当前应用程序的ViewController
 */
-(void) onSessionEnd:(UIViewController*)viewController;

/*!
 *TODO: THIS MIGHT BE DEPRECATED LATER ON
 *@abstract 终止记录用户的使用时长
 *@param pageName 用户定义的页面名称
 */
-(void) onSessionEndWithPageName:(NSString*)pageName;

/*!
 *@abstract 保存用户多个自定义属性
 *
 *@param values 用户的属性键值对(值支持字符串和数字)
 */
-(void) identify:(NSDictionary*)values;

/*!
 *@abstract 保存用户单个自定义属性
 *
 *@param key 属性名
 *@param value 属性值(值支持字符串和数字)
 */
-(void) identifyWithKey:(NSString*)key andValue:(id)value;

/*!
 *@abstract 保存用户的推送Token到同道平台，同道将根据用户Token推送信息
 *
 *@param push_token 用户的推送Token
 */
-(void) identifyPushToken:(id)push_token;

/*!
 *@abstract 保存用户全名
 *
 *@param fullName 用户全名
 */
-(void) identifyFullName:(NSString*)fullName;

/*!
 *@abstract 保存用户名字属性
 *
 *@param firstName 名
 *@param lastName 姓
 */
-(void) identifyFullNameWithFirstName:(NSString*)firstName andLastName:(NSString*)lastName;

/*!
 *@abstract 保存用户应用中的名字
 *
 *@param userName 用户应用中的名字
 */
-(void) identifyUserName:(NSString*)userName;

/*!
 *@abstract 保存用户邮件地址
 *
 *@param email 用户邮件地址
 */
-(void) identifyEmail:(NSString*)email;

/*!
 *@abstract 保存用户电话号码
 *
 *@param phoneNumber 用户电话号码
 */
-(void) identifyPhone:(NSString*)phoneNumber;

/*!
 *@abstract 保存用户性别
 *
 *@param gender 用户性别(字符串类型，具体请参考sdk)
 */
-(void) identifyGender:(NSString*)gender;

/*!
 *@abstract 保存用户年龄
 *
 *@param age 用户年龄
 */
-(void) identifyAge:(int)age;

/*!
 *@abstract 保存用户头像链接地址
 *
 *@param url 用户头像链接地址
 */
-(void) identifyAvatar:(NSString*)url;

/*!
 *@abstract 保存用户联系地址
 *
 *@param address 用户联系地址
 */
-(void) identifyAddress:(NSString*)address;

/*!
 *@abstract 保存用户出生日期
 *
 *@param date 用户出生日期
 */
-(void) identifyBirthday:(NSDate*)date;

/*!
 *@abstract 保存用户应用源信息
 *
 *@param tdSource 用户应用源信息对象
 */
-(void) identifySource:(TdSource*)tdSource;

/*!
 *@abstract 跟踪应用评分
 *
 *@param rating 应用评分
 */
-(void) identifyRating:(int)rating;

/*!
 *@abstract 跟踪应用注册日期
 *
 *@param date 用户设置的日期对象
 */
-(void) trackRegistrationWithDate:(NSDate*)date;

/*!
 *
 *@abstract 跟踪应用注册日期(使用当前系统时间,无日期参数)
 *
 */
-(void) trackRegistration;

/*!
 *@abstract 跟踪提交的交易信息
 *
 *@param order 交易信息
 */
-(void) trackPlaceOrder:(TdOrder*)order;

/*!
 *
 *@abstract 跟踪提交的交易信息
 *
 *@param name 产品名称
 *@param price 产品价格
 *@param currency 产品货币
 *@param quantity 产品个数
 */
-(void) trackPlaceOrder:(NSString*)name andPrice:(double)price andCurrency:(NSString*)currency andQuantity:(int)quantity;

/*!
 *
 *@abstract 跟踪提交的交易信息，产品个数默认为1
 *
 *@param name 产品名称
 *@param price 产品价格
 *@param currency 产品货币
 */
-(void) trackPlaceOrder:(NSString*)name andPrice:(double)price andCurrency:(NSString*)currency;


/**
*
*@brief 显示应用消息的界面
*@param view 传递外部容器的view

*/
-(void) displayInAppMessage:(UIView*)view;

/**
 @brief 跟踪用户打开了百度或JPush推送消息
 @param userInfo 推送消息的附加信息
 */
-(void)trackOpenPushMessage:(NSDictionary*)userInfo;

/**
  @brief 跟踪用户点击了应用内消息
  @param tdMessageBean 同道返回的TdMessageBean
 */
-(void)trackOpenInAppMessage:(TdMessageBean*)tdMessageBean;

/**
 @brief 跟踪用户收到了应用内消息
 @param tdMessageBean 同道返回的TdMessageBean
 */
-(void)trackReceivedInAppMessage:(TdMessageBean*)tdMessageBean;

-(void)openPage:(UIViewController*)rootViewController andUserInfo:(NSDictionary*)userInfo andDeeplinkAndControllerId:(NSMutableDictionary*)deeplinkAndControllerId;

-(void)reset;

-(void)setDeeplinkDictionary:(NSMutableDictionary*)dictionary;

-(NSMutableDictionary*)getDeeplinkDictionary;

+(TongDao*)sharedManager;

-(void)sendOpenMessageWithEventName:(NSString*)eventName andMid:(NSInteger)mid andCid:(NSInteger)cid;

/**
 *
 *@brief 获得SDK保存的AppKey
 *@result appKey
 */
-(NSString*) getAppKey;


-(NSString*) getUserId;

@end
