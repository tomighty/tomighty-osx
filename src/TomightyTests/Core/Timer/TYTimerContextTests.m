//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <XCTest/XCTest.h>
#import "TYTimerContext.h"
#import "TYDefaultTimerContext.h"

@interface TYTimerContextTests : XCTestCase

@end

@implementation TYTimerContextTests
{
    __strong id <TYTimerContext> timerContext;
}

- (void)test_context_type
{
    timerContext = [TYDefaultTimerContext ofType:SHORT_BREAK name:nil remainingSeconds:0];
    XCTAssertEqual(SHORT_BREAK, [timerContext getContextType]);
    
    timerContext = [TYDefaultTimerContext ofType:POMODORO name:nil remainingSeconds:0];
    XCTAssertEqual(POMODORO, [timerContext getContextType]);
}

- (void)test_context_name
{
    timerContext = [TYDefaultTimerContext ofType:POMODORO name:@"Foo bar" remainingSeconds:0];
    XCTAssertEqualObjects([timerContext getName], @"Foo bar");
    
    timerContext = [TYDefaultTimerContext ofType:POMODORO name:@"Hello" remainingSeconds:0];
    XCTAssertEqualObjects([timerContext getName], @"Hello");
}

- (void)test_initial_remaining_seconds
{
    timerContext = [TYDefaultTimerContext ofType:POMODORO name:nil remainingSeconds:579];
    XCTAssertEqual([timerContext getRemainingSeconds], 579);
}

- (void)test_add_seconds
{
    timerContext = [TYDefaultTimerContext ofType:POMODORO name:nil remainingSeconds:10];
    [timerContext addSeconds:3];
    XCTAssertEqual([timerContext getRemainingSeconds], 13);
}

- (void)test_subtract_seconds
{
    timerContext = [TYDefaultTimerContext ofType:POMODORO name:nil remainingSeconds:10];
    [timerContext addSeconds:-2];
    XCTAssertEqual([timerContext getRemainingSeconds], 8);
}

@end
