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
#import "TYDefaultAppUI.h"
#import "TYStatusIcon.h"
#import "TYStatusMenu.h"

@interface TYAppUITests : XCTestCase

@end

@implementation TYAppUITests
{
    id <TYAppUI> appUi;
    id <TYStatusMenu> statusMenu;
    id <TYStatusIcon> statusIcon;
}

- (void)setUp
{
    [super setUp];
    statusMenu = mockProtocol(@protocol(TYStatusMenu));
    statusIcon = mockProtocol(@protocol(TYStatusIcon));
    appUi = [[TYDefaultAppUI alloc] initWith:statusMenu statusIcon:statusIcon];
}

- (void)test_switch_to_idle_state
{
    [appUi switchToIdleState];
    
    [verify(statusMenu) enableStopTimerItem:false];
    [verify(statusMenu) enableStartPomodoroItem:true];
    [verify(statusMenu) enableStartShortBreakItem:true];
    [verify(statusMenu) enableStartLongBreakItem:true];
    [verify(statusMenu) setRemainingTimeText:@"00:00"];
    [verify(statusIcon) changeIcon:ICON_STATUS_IDLE];
}

- (void)test_switch_to_pomodoro_state
{
    [appUi switchToPomodoroState];
    
    [verify(statusMenu) enableStopTimerItem:true];
    [verify(statusMenu) enableStartPomodoroItem:false];
    [verify(statusMenu) enableStartShortBreakItem:true];
    [verify(statusMenu) enableStartLongBreakItem:true];
    [verifyCount(statusMenu, never()) setRemainingTimeText:anything()];
    [verify(statusIcon) changeIcon:ICON_STATUS_POMODORO];
}

- (void)test_switch_to_short_break_state
{
    [appUi switchToShortBreakState];
    
    [verify(statusMenu) enableStopTimerItem:true];
    [verify(statusMenu) enableStartPomodoroItem:true];
    [verify(statusMenu) enableStartShortBreakItem:false];
    [verify(statusMenu) enableStartLongBreakItem:true];
    [verifyCount(statusMenu, never()) setRemainingTimeText:anything()];
    [verify(statusIcon) changeIcon:ICON_STATUS_SHORT_BREAK];
}

- (void)test_switch_to_long_break_state
{
    [appUi switchToLongBreakState];
    
    [verify(statusMenu) enableStopTimerItem:true];
    [verify(statusMenu) enableStartPomodoroItem:true];
    [verify(statusMenu) enableStartShortBreakItem:true];
    [verify(statusMenu) enableStartLongBreakItem:false];
    [verifyCount(statusMenu, never()) setRemainingTimeText:anything()];
    [verify(statusIcon) changeIcon:ICON_STATUS_LONG_BREAK];
}

- (void)test_update_remaining_time_to_zero_seconds
{
    [appUi updateRemainingTime:0 withMode:TYAppUIRemainingTimeModeDefault];
    [verify(statusMenu) setRemainingTimeText:@"00:00"];
    [verify(statusIcon) setStatusText:@""];
    
    [appUi setStatusIconTextFormat:TYAppUIStatusIconTextFormatMinutes];
    [verify(statusIcon) setStatusText:@" Stopped"];
}

- (void)test_update_remaining_time_to_one_second
{
    [appUi updateRemainingTime:1 withMode:TYAppUIRemainingTimeModeDefault];
    [verify(statusMenu) setRemainingTimeText:@"00:01"];
    [verify(statusIcon) setStatusText:@""];
    
    [appUi setStatusIconTextFormat:TYAppUIStatusIconTextFormatMinutes];
    [verify(statusIcon) setStatusText:@" 1 m"];
    
    [appUi setStatusIconTextFormat:TYAppUIStatusIconTextFormatSeconds];
    [verify(statusIcon) setStatusText:@" 00:01"];
}

- (void)test_update_remaining_time_to_fifty_nine_seconds
{
    [appUi updateRemainingTime:59 withMode:TYAppUIRemainingTimeModeDefault];
    [verify(statusMenu) setRemainingTimeText:@"00:59"];
}

- (void)test_update_remaining_time_to_one_minute
{
    [appUi updateRemainingTime:60 withMode:TYAppUIRemainingTimeModeDefault];
    [verify(statusMenu) setRemainingTimeText:@"01:00"];
}

- (void)test_update_remaining_time_to_zero_fifty_nine_minutes_and_fifty_nine_seconds
{
    [appUi updateRemainingTime:59 * 60 + 59 withMode:TYAppUIRemainingTimeModeDefault];
    [verify(statusMenu) setRemainingTimeText:@"59:59"];
    [verify(statusIcon) setStatusText:@""];
    
    [appUi setStatusIconTextFormat:TYAppUIStatusIconTextFormatMinutes];
    [verify(statusIcon) setStatusText:@" 60 m"];
    
    [appUi setStatusIconTextFormat:TYAppUIStatusIconTextFormatSeconds];
    [verify(statusIcon) setStatusText:@" 59:59"];
}

- (void)test_update_remaining_time_with_start_mode
{
    [appUi setStatusIconTextFormat:TYAppUIStatusIconTextFormatMinutes];
    
    [appUi updateRemainingTime:25 * 60 withMode:TYAppUIRemainingTimeModeStart];
    [verify(statusMenu) setRemainingTimeText:@"25:00"];
    [verify(statusIcon) setStatusText:@" 25 m"];
    
    [appUi updateRemainingTime:23 * 60 + 59 withMode:TYAppUIRemainingTimeModeDefault];
    [verify(statusMenu) setRemainingTimeText:@"23:59"];
    [verify(statusIcon) setStatusText:@" 24 m"];

}

- (void)test_update_pomodoro_count_to_zero
{
    [appUi updatePomodoroCount:0];
    [verify(statusMenu) setPomodoroCountText:@"No pomodoros"];
}

- (void)test_update_pomodoro_count_to_one
{
    [appUi updatePomodoroCount:1];
    [verify(statusMenu) setPomodoroCountText:@"1 pomodoro"];
}

- (void)test_update_pomodoro_count_to_two
{
    [appUi updatePomodoroCount:2];
    [verify(statusMenu) setPomodoroCountText:@"2 pomodoros"];
}

- (void)test_disable_pomodoro_count_reset_menu_item_when_pomodoro_count_is_zero
{
    [appUi updatePomodoroCount:0];
    [verify(statusMenu) enableResetPomodoroCountItem:false];
}

- (void)test_enable_pomodoro_count_reset_menu_item_when_pomodoro_count_is_greater_than_zero
{
    [appUi updatePomodoroCount:1];
    [verify(statusMenu) enableResetPomodoroCountItem:true];
}

@end
