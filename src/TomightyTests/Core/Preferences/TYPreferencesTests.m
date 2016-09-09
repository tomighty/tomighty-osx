//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <XCTest/XCTest.h>

#import "TYPreferences.h"
#import "TYUserDefaultsPreferences.h"
#import "TYEventBus.h"
#import "TYMockEventBus.h"

@interface TYPreferencesTests : XCTestCase

@end

@implementation TYPreferencesTests
{
    id <TYPreferences> preferences;
    TYMockEventBus *eventBus;
}

- (void)setUp
{
    [super setUp];
    
    [self removeUserDefaults];

    eventBus = [[TYMockEventBus alloc] init];
    preferences = [[TYUserDefaultsPreferences alloc] initWith:eventBus];
}

- (void)tearDown
{
    [self removeUserDefaults];
    [super tearDown];
}

- (void)removeUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_TIME_POMODORO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_TIME_SHORT_BREAK];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_TIME_LONG_BREAK];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_PLAY_SOUND_WHEN_TIMER_STARTS];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_PLAY_SOUND_WHEN_TIMER_GOES_OFF];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_STATUS_ICON_TIME_FORMAT];
}

- (void)test_register_default_values_on_instantiation
{
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:PREF_TIME_POMODORO], (NSInteger)25);
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:PREF_TIME_SHORT_BREAK], (NSInteger)5);
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:PREF_TIME_LONG_BREAK], (NSInteger)15);
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:PREF_PLAY_SOUND_WHEN_TIMER_STARTS], (NSInteger)true);
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:PREF_PLAY_SOUND_WHEN_TIMER_GOES_OFF], (NSInteger)true);
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO], (NSInteger)true);
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK], (NSInteger)true);
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] integerForKey:PREF_STATUS_ICON_TIME_FORMAT], (NSInteger)PREF_STATUS_ICON_TIME_FORMAT_NONE);
}

- (void)test_get_any_default_value
{
    XCTAssertEqual([preferences getInt:PREF_TIME_POMODORO], 25);
}

- (void)test_set_and_get_integer_value
{
    [preferences setInt:PREF_TIME_POMODORO value:123];
    XCTAssertEqual([preferences getInt:PREF_TIME_POMODORO], 123);
}

- (void)test_fire_event_when_integer_value_changes_on_set
{
    [preferences setInt:PREF_TIME_POMODORO value:987];
    
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)1);
    XCTAssertTrue([eventBus hasPublishedEvent:PREFERENCE_CHANGE withData:PREF_TIME_POMODORO atPosition:1]);
}

- (void)test_do_not_fire_any_event_when_integer_value_does_not_change_on_set
{
    [preferences setInt:PREF_TIME_POMODORO value:25];
    XCTAssertEqual([eventBus getPublishedEventCount], (NSUInteger)0);
}

- (void)test_fire_PREFERENCE_CHANGE_event_only_after_integer_value_is_changed
{
    __block int valueWhenEventIsFired;
    
    [eventBus subscribeTo:PREFERENCE_CHANGE subscriber:^(id eventData)
    {
        valueWhenEventIsFired = [preferences getInt:PREF_TIME_POMODORO];
    }];
    
    [preferences setInt:PREF_TIME_POMODORO value:999];
    
    XCTAssertEqual(valueWhenEventIsFired, 999);
}

@end
