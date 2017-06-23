//
//  TdUrlTool.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/15.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdUrlTool.h"

#ifdef DEBUG
#define HOST @"https://api.tongdao.io/"//staging
#else
#define HOST @"https://api.tongdao.io/"//production
#endif


@implementation TdUrlTool
+(NSString*)getEventsUrl{
    return [HOST stringByAppendingString:@"v2/events"];
}
+(NSString*)getPageUrl:(NSInteger)landingPageId userId:(NSString*)userId{
    NSString* API_URI_LANDING_PAGE = [HOST stringByAppendingString:[[NSString stringWithFormat:@"v2/page?page_id=%lu&user_id=",(unsigned long)landingPageId] stringByAppendingString:userId]];
    return API_URI_LANDING_PAGE;
}
+(NSString*)getInAppMessageUrl:(NSString*)userId{
    NSString* API_URI_IN_APP_MESSAGES = [HOST stringByAppendingString:[@"v2/messages?user_id=" stringByAppendingString:userId]];
    return API_URI_IN_APP_MESSAGES;
}
@end
