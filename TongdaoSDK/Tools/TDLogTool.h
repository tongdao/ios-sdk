//
//  TDLogTool.h
//  TongdaoSDK
//
//  Created by Alex on 08/02/2017.
//  Copyright © 2017 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TdBridge.h"

//#ifdef DEBUG
//#define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
//#else
//#define NSLog(x...)
//#endif

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

@interface TDLogTool : NSObject
+(void) NSLogInitialDebugWarning;
+(void) NSLogRequestWithRequest:(NSMutableURLRequest*) request;
+(void) NSLogResponseWithRequest:(NSMutableURLRequest*) request status: (NSInteger) status andData: (NSData*) data;

@end
