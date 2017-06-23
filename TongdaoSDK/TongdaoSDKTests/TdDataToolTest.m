//
//  TdDataToolTest.m
//  TongdaoSDK
//
//  Created by Alex on 29/03/2017.
//  Copyright © 2017 Tongdao. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TdDataToolTest : XCTestCase

@end

@implementation TdDataToolTest

- (void)setUp {
    [super setUp];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"APP_KEY"];
    [userDefaults removeObjectForKey:@"TD_USER_ID"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGenerateUserId{
    // first test general user ID
    NSString *userId = [[TdDataTool sharedTdDataTool]generateUserId];
    XCTAssertNotNil(userId);
    
    //save a test user ID
    NSString *userIdTest = @"testuserid";
    [[TdDataTool sharedTdDataTool] saveUuidAndKey:@"testkey" userID:userIdTest];
    NSString *resultUserId = [[TdDataTool sharedTdDataTool]generateUserId];
    XCTAssertEqualObjects(userIdTest, resultUserId);
}

-(void)testSaveUuidAppKeyAnduserId{
    //app key and user ID should be nil
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    XCTAssertNil([userDefaults stringForKey:@"TD_USER_ID"]);
    XCTAssertNil([userDefaults stringForKey:@"APP_KEY"]);
}

@end
