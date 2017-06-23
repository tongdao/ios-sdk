//
//  TdMessageBean.m
//  TongDaoOcSdk
//
//  Created by bin jin on 15/7/8.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdMessageBean.h"

@implementation TdMessageBean

-(id)initWithLayout:(NSString*)layout mid:(NSNumber*)mid cid:(NSNumber*)cid htmlTemplate:(NSString*)htmlTemplate style:(NSString*)style andScript:(NSString*)script{
    self = [super init];
    if (self) {
        self.layout = layout;
        self.mid = mid;
        self.cid = cid;
        self.htmlTemplate = htmlTemplate;
        self.style = style;
        self.script = script;
    }
    return self;
}

-(NSString*)getHtml{
     NSString* html = [NSString stringWithFormat:@"<html>\n"
        "<head>\n"
    "<link rel='stylesheet' href='%@' />\n"
    "</head>\n"
    "<body style='margin:0;padding:0;'>\n"
    "%@\n"
    "<script type='text/javascript' src='%@?%f'></script>\n"
    "</body>\n"
    "</html>\n",self.style, self.htmlTemplate, self.script,[NSDate timeIntervalSinceReferenceDate]];
    return [html stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
}

@end
