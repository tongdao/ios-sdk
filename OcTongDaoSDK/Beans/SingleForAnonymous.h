//
//  SingleForAnonymous.h
//  TongDaoSDK
//
//  Created by bin jin on 15/9/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface SingleForAnonymous : NSObject
singleton_interface(SingleForAnonymous)
@property(nonatomic,assign)BOOL isAnonymous;
@end
