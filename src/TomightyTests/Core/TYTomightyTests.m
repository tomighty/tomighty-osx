//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import <XCTest/XCTest.h>

#import "TYDefaultTomighty.h"
#import "TYMockEventBus.h"
#import "TYPreferences.h"
#import "TYTimer.h"
#import "TYTimerContext.h"
#import "TYTomighty.h"

@interface TYTomightyTests : XCTestCase

@end

@implementation TYTomightyTests
{
    __strong id <TYTomighty> tomighty;
    __strong id <TYTimer> timer;
    __strong id <TYPreferences> preferences;
    __strong TYMockEventBus *eventBus;
    __strong MKTArgumentCaptor *timerContextArgument;
}

- (void)setUp
{
    [super setUp];
    timer = mockProtocol(@protocol(TYTimer));
    preferences = mockProtocol(@protocol(TYPreferences));
    eventBus = [[TYMockEventBus alloc] init];
    tomighty = [[TYDefaultTomighty alloc] initWith:timer preferences:preferences eventBus:eventBus];
    timerContextArgument = [[MKTArgumentCaptor alloc] init];
    
    [given([preferences getInt:PREF_TIME_POMODORO]) willReturnInt:25];
    [given([preferences getInt:PREF_TIME_LONG_BREAK]) willReturnInt:15];
    [given([preferences getInt:PREF_TIME_SHORT_BREAK]) willReturnInt:5];
}

- (void)assertTimerContext:(id <TYTimerContext>)timerContext isOfType:(TYTimerContextType)type hasName:(NSString*)name hasRemainingSeconds:(int)remainingSeconds
{
    assertThat([timerContext getName], equalTo(name));
    assertThatInt([timerContext getContextType], equalToInt(type));
    assertThatInt([timerContext getRemainingSeconds], equalToInt(remainingSeconds));
}

- (void)test_start_timer_in_pomodoro_context_when_starting_a_pomodoro
{
    [tomighty startPomodoro];
    
    [verify(timer) start:[timerContextArgument capture]];
    
    [self assertTimerContext:[timerContextArgument value]
                    isOfType:POMODORO
                    hasName:@"Pomodoro"
                    hasRemainingSeconds:25 * 60];
}

- (void)test_start_timer_in_short_break_context_when_starting_a_short_break
{
    [tomighty startShortBreak];
    
    [verify(timer) start:[timerContextArgument capture]];
    
    [self assertTimerContext:[timerContextArgument value]
                    isOfType:SHORT_BREAK
                    hasName:@"Short break"
                    hasRemainingSeconds:5 * 60];
}

- (void)test_start_timer_in_long_break_context_when_starting_a_long_break
{
    [tomighty startLongBreak];
    
    [verify(timer) start:[timerContextArgument capture]];
    
    [self assertTimerContext:[timerContextArgument value]
                    isOfType:LONG_BREAK
                    hasName:@"Long break"
                    hasRemainingSeconds:15 * 60];
}

- (void)test_stop_timer
{
    [tomighty stopTimer];
    [(id<TYTimer>) verify(timer) stop];
}

- (void)test_publish_POMODORO_COUNT_CHANGE_each_time_when_a_POMODORO_COMPLETE_event_is_published
{
    NSNumber *expectedPomodoroCount;
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    
    
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    
    expectedPomodoroCount = [NSNumber numberWithInt:1];
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)2);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COMPLETE withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COUNT_CHANGE withData:expectedPomodoroCount atPosition:2]);
    
    
    [eventBus clearPublishedEvents];
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    
    expectedPomodoroCount = [NSNumber numberWithInt:2];
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)2);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COMPLETE withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COUNT_CHANGE withData:expectedPomodoroCount atPosition:2]);
    
    
    [eventBus clearPublishedEvents];
    [eventBus publish:POMODORO_COMPLETE data:timerContext];

    expectedPomodoroCount = [NSNumber numberWithInt:3];
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)2);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COMPLETE withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COUNT_CHANGE withData:expectedPomodoroCount atPosition:2]);
}

- (void)test_set_pomodoro_count_back_to_one_when_a_pomodoro_completes_after_four_completed_pomodoros
{
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    
    [eventBus clearPublishedEvents];
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    
    NSNumber *expectedPomodoroCount = [NSNumber numberWithInt:1];
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)2);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COMPLETE withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COUNT_CHANGE withData:expectedPomodoroCount atPosition:2]);
}

- (void)test_reset_pomodoro_count
{
    [tomighty resetPomodoroCount];
    
    NSNumber *expectedPomodoroCount = [NSNumber numberWithInt:0];
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)1);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COUNT_CHANGE withData:expectedPomodoroCount atPosition:1]);
}

- (void)test_pomodoro_count_after_the_count_is_reset
{
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    
    [tomighty resetPomodoroCount];
    
    [eventBus clearPublishedEvents];
    [eventBus publish:POMODORO_COMPLETE data:timerContext];
    
    NSNumber *expectedPomodoroCount = [NSNumber numberWithInt:1];
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)2);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COMPLETE withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COUNT_CHANGE withData:expectedPomodoroCount atPosition:2]);
}

@end
