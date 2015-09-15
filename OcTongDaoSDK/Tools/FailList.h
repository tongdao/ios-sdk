//
//  FailList.h
//  TongDaoSDK
//
//  Created by bin jin on 15/8/24.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface FailList : NSObject
singleton_interface(FailList)
@property(atomic)NSMutableArray* failList;
@end
