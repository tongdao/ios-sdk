//
//  TongDaoBridge.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/16.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TongDaoBridge.h"
#import "TdService.h"
#import "TongDaoApi.h"
#import "TdDataTool.h"
@implementation TongDaoBridge

singleton_implementation(TongDaoBridge)

-(BOOL)initSdk:(NSString*)appKey{

    if (appKey != nil) {
        [[TdService sharedTdService] sendInitialData];
        return YES;
    }
    return NO;
}

-(void)sendEvent:(ACTION_TYPE)action event:(NSString*)event properties:(NSMutableDictionary*)properties{
    TdEventBean* tdEvent = [[TdEventBean alloc]initWithaction:action event:event andProperties:properties];
    [[TdService sharedTdService]sendTrackEvent:tdEvent];
}


-(void)sendEvent:(ACTION_TYPE)action event:(NSString*)event propertiesForOpenMessage:(NSMutableDictionary*)properties{
    TdEventBean* tdEvent = [[TdEventBean alloc]initWithaction:action event:event andProperties:properties];
    [[TdService sharedTdService]sendOpenMessageTrackEvent:tdEvent];
}

-(void)setDeeplinkDictionary:(NSMutableDictionary*)dictionary{
    self.dictionary = dictionary;
}

-(NSMutableDictionary*)getDeeplinkDictionary{
    return self.dictionary;
}

-(void)registerErrorListener:(id<OnErrorListener>)onErrorListener{
    self.onErrorListener = onErrorListener;
}

-(void)downloadPage:(NSInteger)pageId downloadListener:(id<OnDownloadPageListener>)downloadListener{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [TongDaoApi downloadPage:pageId downloadListener:downloadListener];
    });
}

-(void)downloadInAppMessage:(id<OnDownloadInAppMessageListener>)inAppMessageListener{
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
         [TongDaoApi downloadInAppMessage:inAppMessageListener];
     });
}

-(void)track:(NSString*)action{
    [self track:action values:nil];
}

-(void)track:(NSString *)action values:(NSMutableDictionary*)values{
    if ([action isEqualToString:@""] || [action hasPrefix:@"!"]) {
        NSLog(@"! is not allowed start for action name and the action @"" not allowed");
    }else{
        [self sendEvent:track event:action properties:values];
    }
}

-(void)onSessionStart:(id)objc{
    
    if (NSStringFromClass([objc class]) != nil) {
        //NSArray* objArray = [NSStringFromClass([objc class]) componentsSeparatedByString:@"."];
       // if (objArray.count > 0) {
            [self onSessionStartWithPageName:NSStringFromClass([objc class])];
      //  }
    }
}

-(void)onSessionStartWithPageName:(NSString *)pageName{
    self.pageNameStart = pageName;
    self.startTime  = [NSDate date];
    
    if (self.pageNameStart == nil || self.startTime == nil) {
        return;
    }
    NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
    [values setValue:pageName forKey:@"!name"];
//    self.sendEvent(TdEventBean.ACTION_TYPE.track, event: "!open_page", properties: values);
    [self sendEvent:track event:@"!open_page" properties:values];
}

-(void)onSessionEnd:(id)objc{
    if (NSStringFromClass([objc class]) != nil) {
        [self onSessionEndWithPageName:NSStringFromClass([objc class])];
       // NSArray* objArray = [NSStringFromClass([objc class]) componentsSeparatedByString:@"."];
       // if (objArray.count > 0) {
       //     [self onSessionEndWithPageName:objArray.lastObject];
//        }else{
//            NSLog(@"%@",@"No last name");
//        }
    }else{
        NSLog(@"%@",@"No page name");
    }
}

-(void)onSessionEndWithPageName:(NSString *)pageName{
    self.pageNameEnd = pageName;
    
    if (self.pageNameStart == nil || self.pageNameEnd == nil || ![self.pageNameStart isEqualToString:self.pageNameEnd ]) {
        return;
    }
    if(self.startTime == nil){
        return;
    }
    NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
    [values setValue:pageName forKey:@"!name"];
    [values setValue:[[TdDataTool sharedTdDataTool] getTimeStamp:self.startTime] forKey:@"!started_at"];

    [self sendEvent:track event:@"!close_page" properties:values];
    
    self.startTime = nil;
    self.pageNameStart = nil;
    self.pageNameEnd = nil;

    /*
     self.pageNameEnd = pageName;
     
     if (self.pageNameStart == nil || self.pageNameEnd == nil || !(self.pageNameStart == self.pageNameEnd)) {
     return;
     }
     
     if(self.startTime == nil){
     return;
     }
     
     var values=Dictionary<String, AnyObject>();
     values["!name"]=pageName;
     values["!started_at"]=TdDataTool.getTimeStamp(self.startTime!);
     
     self.sendEvent(TdEventBean.ACTION_TYPE.track, event: "!close_page", properties: values);
     
     self.startTime=nil;
     self.pageNameStart=nil;
     self.pageNameEnd=nil;*/
}
-(void)identify:(NSMutableDictionary*)values{
    if (values == nil) {
        return;
    }
    [self sendEvent:identify event:nil properties:values];
}

-(void)identifyWithName:(NSString*)name andValue:(id)value{
    if (![name isEqualToString:@""]) {
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setObject:value forKey:name];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyPushToken:(NSString*)pushToken{
    NSLog(@"the---pushtoken %@",pushToken);
    if ([pushToken isEqualToString:@""]) {
        return;
    }else{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setObject:pushToken forKey:@"!push_token"];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyFullName:(NSString*)fullName{
    if ([fullName isEqualToString:@""]) {
        return;
    }else{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setObject:fullName forKey:@"!name"];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyFullNameWithFirstName:(NSString*)firstName andLastName:(NSString*)lastName{
    if ([firstName isEqualToString:@""] && [lastName isEqualToString:@""]) {
        return;
    }else{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        if (![firstName isEqualToString:@""] && [lastName isEqualToString:@""]) {
            [values setObject:firstName forKey:@"!first_name"];
        }else if([firstName isEqualToString:@""]&&![lastName isEqualToString:@""]){
            [values setObject:lastName forKey:@"!last_name"];
        }else{
            [values setObject:firstName forKey:@"!first_name"];
            [values setObject:lastName forKey:@"!last_name"];
        }
        
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyUserName:(NSString*)userName{
    if ([userName isEqualToString:@""]) {
        return;
    }else{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setValue:userName forKey:@"!username"];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyEmail:(NSString*)email{
    if ([email isEqualToString:@""]) {
        return;
    }else{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setValue:email forKey:@"!email"];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyPhone:(NSString*)phoneNumber{
    if ([phoneNumber isEqualToString:@""]) {
        return;
    }else{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setValue:phoneNumber forKey:@"!phone"];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyGender:(NSString*)gender{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setValue:gender forKey:@"!gender"];
        [self sendEvent:identify event:nil properties:values];
}

-(void)identifyAge:(NSInteger)age{
    if (age>0) {
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        NSNumber* ageNum = [NSNumber numberWithInteger:age];
        [values setValue:ageNum forKey:@"!age"];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyAvatarWithUrl:(NSString*)url{
    if ([url isEqualToString:@""]) {
        return;
    }else{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setValue:url forKey:@"!avatar"];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyAddress:(NSString*)address{
    if ([address isEqualToString:@""]) {
        return;
    }else{
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        [values setValue:address forKey:@"!address"];
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyBirthday:(NSDate*)date{
    NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
    [values setValue:[[TdDataTool sharedTdDataTool]getTimeStamp:date] forKey:@"!birthday"];
    [self sendEvent:identify event:nil properties:values];
}

-(void)identifySource:(TdSource*)tdSource{
    NSMutableDictionary* values = [[TdDataTool sharedTdDataTool]makeSourceProperties:tdSource];
    if (values) {
        [self sendEvent:identify event:nil properties:values];
    }
}

-(void)identifyRating:(NSInteger)rating{
    [self sendEvent:identify event:nil properties:[[TdDataTool sharedTdDataTool] makeRatingProperties:rating]];
}

-(void)trackRegistration:(NSDate*)date{
    [self sendEvent:track event:@"!registration" properties:[[TdDataTool sharedTdDataTool] makeRegisterProperties:date]];
}

-(void)trackRegistration{
    [self sendEvent:track event:@"!registration" properties:[[TdDataTool sharedTdDataTool] makeRegisterProperties]];
}

-(void)trackViewProductCategory:(NSString*)category{
    if (![category isEqualToString:@""]) {
        NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
        values[@"!category"] = category;
        [self sendEvent:track event:@"!view_product_category" properties:values];
    }
}

-(void)trackViewProduct:(TdProduct*)tdProduct{
    NSMutableDictionary* values = [[TdDataTool sharedTdDataTool]makeProductProperties:tdProduct];
    if (values) {
        [self sendEvent:track event:@"!view_product" properties:values];
    }
}

-(void)trackAddCart:(NSArray*)orderLines{
    NSMutableDictionary* values = [[TdDataTool sharedTdDataTool]makeOrderLinesProperties:orderLines];
    if (values) {
        [self sendEvent:track event:@"!add_cart" properties:values];
    }
}

-(void)trackRemoveCart:(NSArray*)orderLines{
    NSMutableDictionary *values = [[TdDataTool sharedTdDataTool]makeOrderLinesProperties:orderLines];
    if (values) {
        [self sendEvent:track event:@"!remove_cart" properties:values];
    }
}

-(void)trackPlaceOrder:(TdOrder*)tdOrder{
    NSMutableDictionary* values = [[TdDataTool sharedTdDataTool]makeOrderProperties:tdOrder];
    if (values) {
        [self sendEvent:track event:@"!place_order" properties:values];
    }
}

-(void)sendOpenMessageWithEventName:(NSString*)eventName andMid:(NSInteger)mid andCid:(NSInteger)cid{
    NSMutableDictionary* values = [[NSMutableDictionary alloc]init];
    values[@"!message_id"] =[NSNumber numberWithInteger:mid];
    values[@"!campaign_id"] =[NSNumber numberWithInteger:cid];
    [self sendEvent:track event:eventName propertiesForOpenMessage:values];

}

@end
