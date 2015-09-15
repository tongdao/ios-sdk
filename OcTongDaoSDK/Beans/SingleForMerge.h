//
//  SingleForMerge.h
//  TongDaoSDK
//
//  Created by bin jin on 15/9/11.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface SingleForMerge : NSObject
singleton_interface(SingleForMerge)
@property(nonatomic,assign)BOOL isMerge;
@end
