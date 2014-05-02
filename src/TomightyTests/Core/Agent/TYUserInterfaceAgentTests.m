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

#import "TYAppUI.h"
#import "TYMockEventBus.h"
#import "TYTimerContext.h"
#import "TYUserInterfaceAgent.h"

@interface TYUserInterfaceAgentTests : XCTestCase

@end

@implementation TYUserInterfaceAgentTests
{
    id <TYAppUI> ui;
    id <TYPreferences> preferences;
    TYMockEventBus *eventBus;
    TYUserInterfaceAgent *uiAgent;
}

- (void)setUp
{
    [super setUp];
    ui = mockProtocol(@protocol(TYAppUI));
    preferences = mockProtocol(@protocol(TYPreferences));
    [given([preferences getInt:PREF_STATUS_ICON_TIME_FORMAT]) willReturnInt:PREF_STATUS_ICON_TIME_FORMAT_MINUTES];
    
    eventBus = [[TYMockEventBus alloc] init];
    uiAgent = [[TYUserInterfaceAgent alloc] initWith:ui preferences:preferences];
    
    [uiAgent updateAppUiInResponseToEventsFrom:eventBus];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_switch_ui_to_idle_state_when_application_is_initialized
{
    [eventBus publish:APP_INIT data:nil];
    [verify(ui) switchToIdleState];
}

- (void)test_update_remaining_time_to_zero_when_application_is_initialized
{
    [eventBus publish:APP_INIT data:nil];
    [verify(ui) updateRemainingTime:0 withMode:TYAppUIRemainingTimeModeDefault];
}

- (void)test_update_pomodoro_count_to_zero_when_application_is_initialized
{
    [eventBus publish:APP_INIT data:nil];
    [verify(ui) updatePomodoroCount:0];
}

- (void)test_read_status_text_format_from_preferences_when_initialized
{
    [eventBus publish:APP_INIT data:nil];
    [verify(ui) setStatusIconTextFormat:TYAppUIStatusIconTextFormatMinutes];
}

- (void)test_switch_ui_to_idle_state_when_timer_stops
{
    [eventBus publish:TIMER_STOP data:nil];
    [verify(ui) switchToIdleState];
}

- (void)test_switch_ui_to_pomodoro_state_when_pomodoro_starts
{
    [eventBus publish:POMODORO_START data:nil];
    [verify(ui) switchToPomodoroState];
}

- (void)test_switch_ui_to_short_break_state_when_short_break_starts
{
    [eventBus publish:SHORT_BREAK_START data:nil];
    [verify(ui) switchToShortBreakState];
}

- (void)test_switch_ui_to_long_break_state_when_long_break_starts
{
    [eventBus publish:LONG_BREAK_START data:nil];
    [verify(ui) switchToLongBreakState];
}

- (void)test_update_remaining_time_when_timer_ticks
{
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    
    [given([timerContext getRemainingSeconds]) willReturnInt:270];
    
    [eventBus publish:TIMER_TICK data:timerContext];
    [verify(ui) updateRemainingTime:[timerContext getRemainingSeconds] withMode:TYAppUIRemainingTimeModeDefault];
}

- (void)test_update_remaining_time_when_timer_starts
{
    id <TYTimerContext> timerContext = mockProtocol(@protocol(TYTimerContext));
    
    [given([timerContext getRemainingSeconds]) willReturnInt:270];
    
    [eventBus publish:TIMER_START data:timerContext];
    [verify(ui) updateRemainingTime:[timerContext getRemainingSeconds] withMode:TYAppUIRemainingTimeModeStart];
}

- (void)test_update_pomodoro_count_when_it_changes
{
    NSNumber *pomodoroCount = [NSNumber numberWithInt:3];
    [eventBus publish:POMODORO_COUNT_CHANGE data:pomodoroCount];
    [verify(ui) updatePomodoroCount:3];
}

- (void)test_change_status_text_format_when_preferences_change
{
    [given([preferences getInt:PREF_STATUS_ICON_TIME_FORMAT]) willReturnInt:PREF_STATUS_ICON_TIME_FORMAT_SECONDS];

    [eventBus publish:PREFERENCE_CHANGE data:PREF_STATUS_ICON_TIME_FORMAT];
    
    [verify(ui) setStatusIconTextFormat:TYAppUIStatusIconTextFormatSeconds];
}

@end
