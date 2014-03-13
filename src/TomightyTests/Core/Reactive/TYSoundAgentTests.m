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
#import "TYPreferences.h"
#import "TYSoundAgent.h"
#import "TYSoundPlayer.h"
#import "TYTimerContext.h"

@interface TYSoundAgentTests : XCTestCase

@end

@implementation TYSoundAgentTests
{
    __strong TYSoundAgent *soundAgent;
    __strong TYMockEventBus *eventBus;
    __strong id <TYPreferences> preferences;
    __strong id <TYSoundPlayer> soundPlayer;
    __strong id <TYTimerContext> timerContext;
}

- (void)setUp
{
    [super setUp];
    
    eventBus = [[TYMockEventBus alloc] init];
    preferences = mockProtocol(@protocol(TYPreferences));
    soundPlayer = mockProtocol(@protocol(TYSoundPlayer));
    timerContext = mockProtocol(@protocol(TYTimerContext));
    soundAgent = [[TYSoundAgent alloc] initWith:soundPlayer preferences:preferences];

    [soundAgent playSoundsInResponseToEventsFrom:eventBus];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_play_sound_when_timer_starts_if_enabled_by_preference
{
    [given([preferences getInt:PREF_PLAY_SOUND_WHEN_TIMER_STARTS]) willReturnInteger:true];
    [eventBus publish:TIMER_START data:timerContext];
    [verify(soundPlayer) play:SOUND_TIMER_START];
}

- (void)test_do_not_play_sound_when_timer_starts_if_disabled_by_preference
{
    [given([preferences getInt:PREF_PLAY_SOUND_WHEN_TIMER_STARTS]) willReturnInteger:false];
    [eventBus publish:TIMER_START data:timerContext];
    [verifyCount(soundPlayer, never()) play:anything()];
}

- (void)test_play_sound_when_timer_goes_off_if_enabled_by_preference
{
    [given([preferences getInt:PREF_PLAY_SOUND_WHEN_TIMER_GOES_OFF]) willReturnInteger:true];
    [eventBus publish:TIMER_GOES_OFF data:timerContext];
    [verify(soundPlayer) play:SOUND_TIMER_GOES_OFF];
}

- (void)test_do_not_play_sound_when_timer_goes_off_if_disabled_by_preference
{
    [given([preferences getInt:PREF_PLAY_SOUND_WHEN_TIMER_GOES_OFF]) willReturnInteger:false];
    [eventBus publish:TIMER_GOES_OFF data:timerContext];
    [verifyCount(soundPlayer, never()) play:anything()];
}

- (void)test_play_ticking_sound_when_pomodoro_starts_if_enabled_by_preference
{
    [given([preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO]) willReturnInteger:true];
    [given([preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK]) willReturnInteger:false];
    [eventBus publish:POMODORO_START data:timerContext];
    [verify(soundPlayer) loop:SOUND_TIMER_TICK];
}

- (void)test_do_not_play_ticking_sound_when_pomodoro_starts_if_disabled_by_preference
{
    [given([preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO]) willReturnInteger:false];
    [given([preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK]) willReturnInteger:true];
    [eventBus publish:POMODORO_START data:timerContext];
    [verifyCount(soundPlayer, never()) loop:anything()];
}

- (void)test_play_ticking_sound_when_break_starts_if_enabled_by_preference
{
    [given([preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO]) willReturnInteger:false];
    [given([preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK]) willReturnInteger:true];
    [eventBus publish:BREAK_START data:timerContext];
    [verify(soundPlayer) loop:SOUND_TIMER_TICK];
}

- (void)test_do_not_play_ticking_sound_when_break_starts_if_disabled_by_preference
{
    [given([preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO]) willReturnInteger:true];
    [given([preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK]) willReturnInteger:false];
    [eventBus publish:BREAK_START data:timerContext];
    [verifyCount(soundPlayer, never()) loop:anything()];
}

- (void)test_stop_any_looping_sound_when_timer_stops
{
    [eventBus publish:TIMER_STOP data:timerContext];
    [verify(soundPlayer) stopCurrentLoop];
}

@end
