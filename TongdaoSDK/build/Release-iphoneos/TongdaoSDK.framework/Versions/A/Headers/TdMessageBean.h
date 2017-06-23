//
//  TdMessageBean.h
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TdMessageButtonBean.h"
@interface TdMessageBean : NSObject


///获得应用消息的显示位置
@property(nonatomic,copy)NSString* layout;
///获得应用消息的messageId
@property(nonatomic,retain)NSNumber* mid;
///获得应用消息的CampainId
@property(nonatomic,retain)NSNumber* cid;
///
@property(nonatomic,copy)NSString* htmlTemplate;
///
@property(nonatomic,copy)NSString* style;
///
@property(nonatomic,copy)NSString* script;

-(id)initWithLayout:(NSString*)layout mid:(NSNumber*)mid cid:(NSNumber*)cid htmlTemplate:(NSString*)htmlTemplate style:(NSString*)style andScript:(NSString*)script;

-(NSString*)getHtml;

@end
