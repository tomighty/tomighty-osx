//
//  PreferencesWindowController.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 28/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "Preferences.h"

@implementation PreferencesWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"PreferencesWindow"];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.time_pomodoro setIntValue:[Preferences intValue:PREF_TIME_POMODORO]];
    [self.time_shortBreak setIntValue:[Preferences intValue:PREF_TIME_SHORT_BREAK]];
    [self.time_longBreak setIntValue:[Preferences intValue:PREF_TIME_LONG_BREAK]];
    [self.sound_on_timer_start setState:[Preferences intValue:PREF_SOUND_TIMER_START]];
    [self.sound_on_timer_finish setState:[Preferences intValue:PREF_SOUND_TIMER_FINISH]];
    [self.sound_tictac_during_pomodoro setState:[Preferences intValue:PREF_SOUND_TICTAC_POMODORO]];
    [self.sound_tictac_during_break setState:[Preferences intValue:PREF_SOUND_TICTAC_BREAK]];
}

- (void)windowWillClose:(NSNotification *)notification {
    // Force text controls to end editing before close
    [self.window makeFirstResponder:nil];
}

- (IBAction)save_time_pomodoro:(id)sender {
    [Preferences setIntValue:PREF_TIME_POMODORO value:[self.time_pomodoro intValue]];
}

- (IBAction)save_time_shortBreak:(id)sender {
    [Preferences setIntValue:PREF_TIME_SHORT_BREAK value:[self.time_shortBreak intValue]];
}

- (IBAction)save_time_longBreak:(id)sender {
    [Preferences setIntValue:PREF_TIME_LONG_BREAK value:[self.time_longBreak intValue]];
}

- (IBAction)save_sound_play_on_timer_start:(id)sender {
    [Preferences setIntValue:PREF_SOUND_TIMER_START value:(int)[self.sound_on_timer_start state]];
}

- (IBAction)save_sound_play_on_timer_finish:(id)sender {
    [Preferences setIntValue:PREF_SOUND_TIMER_FINISH value:(int)[self.sound_on_timer_finish state]];
}

- (IBAction)save_sound_play_tictac_during_pomodoro:(id)sender {
    [Preferences setIntValue:PREF_SOUND_TICTAC_POMODORO value:(int)[self.sound_tictac_during_pomodoro state]];
}

- (IBAction)save_sound_play_tictac_during_break:(id)sender {
    [Preferences setIntValue:PREF_SOUND_TICTAC_BREAK value:(int)[self.sound_tictac_during_break state]];
}

@end
