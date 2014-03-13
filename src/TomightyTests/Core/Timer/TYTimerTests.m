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

#import "TYEventBus.h"
#import "TYDefaultTimer.h"
#import "TYTimer.h"
#import "TYTimerContext.h"
#import "TYSystemTimer.h"
#import "TYMockSystemTimer.h"
#import "TYMockTimerContext.h"

@interface TYTimerTest : XCTestCase

@end

@implementation TYTimerTest

- (void)test_schedule_system_timer_to_trigger_each_second_on_start
{
    id <TYEventBus> eventBus = mockProtocol(@protocol(TYEventBus));
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    id <TYSystemTimer> systemTimer = mockProtocol(@protocol(TYSystemTimer));
    id <TYTimer> timer = [TYDefaultTimer createWith:eventBus systemTimer:systemTimer];

    [timer start:timerContext];
    
    [verify(systemTimer) triggerRepeatedly:anything() intervalInSeconds:1];
}

- (void)test_stop_system_timer_on_stop
{
    id <TYEventBus> eventBus = mockProtocol(@protocol(TYEventBus));
    id <TYSystemTimer> systemTimer = mockProtocol(@protocol(TYSystemTimer));
    id <TYTimer> timer = [TYDefaultTimer createWith:eventBus systemTimer:systemTimer];

    [timer stop];
    
    [verify(systemTimer) interrupt];
}

- (void)test_fire_TIMER_START_event_on_start
{
    id <TYEventBus> eventBus = mockProtocol(@protocol(TYEventBus));
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    id <TYSystemTimer> systemTimer = mockProtocol(@protocol(TYSystemTimer));
    id <TYTimer> timer = [TYDefaultTimer createWith:eventBus systemTimer:systemTimer];
    
    [timer start:timerContext];
    
    [verify(eventBus) publish:TIMER_START data:timerContext];
}

- (void)test_fire_TIMER_STOP_event_on_stop
{
    id <TYEventBus> eventBus = mockProtocol(@protocol(TYEventBus));
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    id <TYSystemTimer> systemTimer = mockProtocol(@protocol(TYSystemTimer));
    id <TYTimer> timer = [TYDefaultTimer createWith:eventBus systemTimer:systemTimer];
    
    [timer start:timerContext];
    [verify(eventBus) publish:TIMER_START data:timerContext];
    
    [timer stop];
    [verify(eventBus) publish:TIMER_STOP data:timerContext];
}

- (void)test_fire_TIMER_TICK_event_each_time_a_second_ellapses
{
    id <TYEventBus> eventBus = mockProtocol(@protocol(TYEventBus));
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    TYMockSystemTimer *systemTimer = [[TYMockSystemTimer alloc] init];
    id <TYTimer> timer = [TYDefaultTimer createWith:eventBus systemTimer:systemTimer];

    [given([timerContext getRemainingSeconds]) willReturnInt:999];

    [timer start:timerContext];
    [verify(eventBus) publish:TIMER_START data:timerContext];
    
    [systemTimer tick];
    [verify(eventBus) publish:TIMER_TICK data:timerContext];
    
    [systemTimer tick];
    [verifyCount(eventBus, times(2)) publish:TIMER_TICK data:timerContext];
    
    [systemTimer tick];
    [verifyCount(eventBus, times(3)) publish:TIMER_TICK data:timerContext];
}

- (void)test_subtract_one_second_from_the_timer_context_each_time_a_second_ellapses
{
    id <TYEventBus> eventBus = mockProtocol(@protocol(TYEventBus));
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    TYMockSystemTimer *systemTimer = [[TYMockSystemTimer alloc] init];
    id <TYTimer> timer = [TYDefaultTimer createWith:eventBus systemTimer:systemTimer];
    
    [given([timerContext getRemainingSeconds]) willReturnInt:999];
    
    [timer start:timerContext];
    
    [systemTimer tick];
    [verify(timerContext) addSeconds:-1];

    [systemTimer tick];
    [verifyCount(timerContext, times(2)) addSeconds:-1];
    
    [systemTimer tick];
    [verifyCount(timerContext, times(3)) addSeconds:-1];
}

- (void)test_fire_TIMER_STOP_event_when_the_timer_goes_off
{
    id <TYEventBus> eventBus = mockProtocol(@protocol(TYEventBus));
    TYMockTimerContext *timerContext = [[TYMockTimerContext alloc] initWithRemainingSeconds:3];
    TYMockSystemTimer *systemTimer = [[TYMockSystemTimer alloc] init];
    id <TYTimer> timer = [TYDefaultTimer createWith:eventBus systemTimer:systemTimer];
    
    [timer start:timerContext];
    [verify(eventBus) publish:TIMER_START data:timerContext];
    
    [systemTimer tick];
    [verify(eventBus) publish:TIMER_TICK data:timerContext];
    
    [systemTimer tick];
    [verifyCount(eventBus, times(2)) publish:TIMER_TICK data:timerContext];
    
    [systemTimer tick];
    [verify(eventBus) publish:TIMER_STOP data:timerContext];
}

- (void)test_interrupt_system_timer_when_timer_goes_off
{
    id <TYEventBus> eventBus = mockProtocol(@protocol(TYEventBus));
    TYMockTimerContext *timerContext = [[TYMockTimerContext alloc] initWithRemainingSeconds:3];
    TYMockSystemTimer *systemTimer = [[TYMockSystemTimer alloc] init];
    id <TYTimer> timer = [TYDefaultTimer createWith:eventBus systemTimer:systemTimer];
    
    [timer start:timerContext];
    XCTAssertFalse([systemTimer isInterrupted]);
    
    [systemTimer tick];
    XCTAssertFalse([systemTimer isInterrupted]);

    [systemTimer tick];
    XCTAssertFalse([systemTimer isInterrupted]);

    [systemTimer tick];
    XCTAssertTrue([systemTimer isInterrupted]);
}

@end
