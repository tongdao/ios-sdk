//
//  TDLogTool.m
//  TongdaoSDK
//
//  Created by Alex on 08/02/2017.
//  Copyright © 2017 Tongdao. All rights reserved.
//

#import "TdLogTool.h"



void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
    // Type to hold information about variable arguments.
    va_list ap;
    
    // Initialize a variable argument list.
    va_start (ap, format);
    
    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"])
    {
        format = [format stringByAppendingString: @"\n"];
    }
    
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    
    // End using variable argument list.
    va_end (ap);
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    fprintf(stderr, "(%s) (%s:%d) %s",
            functionName, [fileName UTF8String],
            lineNumber, [body UTF8String]);
}

@implementation TDLogTool

+(void) NSLogInitialDebugWarning{
    NSLog(@"TDLogging\r\r"
          "=======================\r"
          "      W A R N I N G    \r"
          "=======================\r"
          "The Tongdao SDK is in debug mode. Please make sure to turn this off before you\r"
          "ship your app for security reasons.\r\r");
}

+(void) NSLogRequestWithRequest:(NSMutableURLRequest*) request{
    if ([TdBridge isDebugMode])
        NSLog(@"TDLogging\r\r"
          "\r"
          "-------->\r"
          "REQUEST  \r"
          "-------->\r"
          "URL: %@\r"
          "METHOD: %@\r"
          "Headers: \r"
          "%@       \r"
          "\r"
          "Body:    \r"
          "%@       \r"
          "\r"
          "-------->\r"
          "END REQUEST\r"
          "-------->\r",
          [request.URL description],
          [request HTTPMethod],
          [request allHTTPHeaderFields],
          [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
}

+(void) NSLogResponseWithRequest:(NSMutableURLRequest*) request status: (NSInteger) status andData: (NSData*) data{
    if ([TdBridge isDebugMode])
        NSLog(@"TDLogging\r\r"
          "\r"
          "<--------\r"
          "RESPONSE  \r"
          "<--------\r"
          "URL: %@\r"
          "METHOD: %@\r"
          "Status: %zd\r"
          "Headers: \r"
          "%@       \r"
          "\r"
          "Body:    \r"
          "%@       \r"
          "\r"
          "<--------\r"
          "END RESPONSE\r"
          "<--------\r",
          [request.URL description],
          [request HTTPMethod],
          status,
          [request allHTTPHeaderFields],
          [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

}


@end
