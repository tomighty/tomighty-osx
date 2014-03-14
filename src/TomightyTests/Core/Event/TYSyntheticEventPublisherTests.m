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

#import "TYMockEventBus.h"
#import "TYSyntheticEventPublisher.h"
#import "TYTimerContext.h"

@interface TYSyntheticEventPublisherTests : XCTestCase

@end

@implementation TYSyntheticEventPublisherTests
{
    TYSyntheticEventPublisher *syntheticEventPublisher;
    TYMockEventBus *eventBus;
    id <TYTimerContext> timerContext;
}

- (void)setUp
{
    [super setUp];
    
    eventBus = [[TYMockEventBus alloc] init];
    timerContext = mockProtocol(@protocol(TYTimerContext));
    syntheticEventPublisher = [[TYSyntheticEventPublisher alloc] init];
    
    [syntheticEventPublisher publishSyntheticEventsInResponseToOtherEventsFrom:eventBus];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_publish_POMODORO_START_event_when_timer_starts_in_pomodoro_context
{
    [given([timerContext getContextType]) willReturnInt:POMODORO];
    
    [eventBus publish:TIMER_START data:timerContext];
    
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)2);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_START withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_START withData:timerContext atPosition:2]);
}

- (void)test_publish_BREAK_START_and_SHORT_BREAK_START_events_when_timer_starts_in_short_break_context
{
    [given([timerContext getContextType]) willReturnInt:SHORT_BREAK];
    
    [eventBus publish:TIMER_START data:timerContext];
    
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)3);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_START withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:BREAK_START withData:timerContext atPosition:2]);
    XCTAssertTrue([eventBus hasPublishedEvent:SHORT_BREAK_START withData:timerContext atPosition:3]);
}

- (void)test_publish_BREAK_START_and_LONG_BREAK_START_events_when_timer_starts_in_long_break_context
{
    [given([timerContext getContextType]) willReturnInt:LONG_BREAK];
    
    [eventBus publish:TIMER_START data:timerContext];
    
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)3);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_START withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:BREAK_START withData:timerContext atPosition:2]);
    XCTAssertTrue([eventBus hasPublishedEvent:LONG_BREAK_START withData:timerContext atPosition:3]);
}

- (void)test_publish_TIMER_GOES_OFF_event_when_timer_stops_and_remaining_seconds_is_zero
{
    [given([timerContext getContextType]) willReturnInt:-1];
    [given([timerContext getRemainingSeconds]) willReturnInt:0];
    
    [eventBus publish:TIMER_STOP data:timerContext];
    
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)2);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_STOP withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_GOES_OFF withData:timerContext atPosition:2]);
}

- (void)test_publish_POMODORO_COMPLETE_event_when_timer_stops_in_pomodoro_context_and_remaining_seconds_is_zero
{
    [given([timerContext getContextType]) willReturnInt:POMODORO];
    [given([timerContext getRemainingSeconds]) willReturnInt:0];
    
    [eventBus publish:TIMER_STOP data:timerContext];
    
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)3);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_STOP withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_GOES_OFF withData:timerContext atPosition:2]);
    XCTAssertTrue([eventBus hasPublishedEvent:POMODORO_COMPLETE withData:timerContext atPosition:3]);
}

- (void)test_publish_TIMER_ABORT_event_when_timer_stops_and_remaining_seconds_is_greater_than_zero
{
    [given([timerContext getRemainingSeconds]) willReturnInt:1];
    
    [eventBus publish:TIMER_STOP data:timerContext];
    
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)2);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_STOP withData:timerContext atPosition:1]);
    XCTAssertTrue([eventBus hasPublishedEvent:TIMER_ABORT withData:timerContext atPosition:2]);
}

@end
