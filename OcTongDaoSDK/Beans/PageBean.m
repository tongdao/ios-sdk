//
//  PageBean.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "PageBean.h"

@implementation PageBean

-(NSString *)getPageImage{
    return self.image;
}

-(NSMutableArray *)getTdRewards{
    return self.rewards;
}

-(void)setImage:(NSString *)image{
    self.image = image;
}

-(void)setRewards:(NSMutableArray *)rewards{
    self.rewards = rewards;
}

@end
