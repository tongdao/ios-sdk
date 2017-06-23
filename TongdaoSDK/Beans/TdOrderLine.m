//
//  TdOrderLine.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdOrderLine.h"

@implementation TdOrderLine
-(id)initWithProduct:(TdProduct*)product andQuantity:(NSInteger)quantity{
    self = [super self];
    if (self) {
        self.product = product;
        self.quantity = quantity;
    }
    return self;
}
@end
