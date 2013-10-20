//
//  AppDelegate.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 23/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "AppDelegate.h"
#import "Preferences.h"
#import "PreferencesWindowController.h"
#import "Sounds.h"
#import "StatusIcon.h"
#import "Timer.h"
#import "Tomighty.h"

@implementation AppDelegate
{
    __strong Tomighty *tomighty;
    __strong Timer *timer;
    __strong StatusIcon *statusIcon;
    __strong PreferencesWindowController *preferencesWindow;
    __strong Sounds *sounds;
    __strong TimerContext *pomodoroContext;
    __strong TimerContext *shortBreakContext;
    __strong TimerContext *longBreakContext;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    tomighty = [[Tomighty alloc] init];
    timer = [[Timer alloc] initWithListener:self];
    statusIcon = [[StatusIcon alloc] initWithStatusMenu:[self statusMenu]];
    sounds = [[Sounds alloc] init];
    pomodoroContext = [[TimerContext alloc] initWithName:@"Pomodoro"];
    shortBreakContext = [[TimerContext alloc] initWithName:@"Short break"];
    longBreakContext = [[TimerContext alloc] initWithName:@"Long break"];
    
    [self updateRemainingTime:0];
    
}

- (IBAction)showPreferences:(id)sender {
    if(!preferencesWindow) {
        preferencesWindow = [[PreferencesWindowController alloc] init];
    }
    [preferencesWindow showWindow:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)startPomodoro:(id)sender {
    int minutes = [Preferences intValue:PREF_TIME_POMODORO];
    [self activateTimerMenuItem:self.startPomodoroMenuItem];
    [statusIcon pomodoro];
    [timer start:minutes context:pomodoroContext];
}

- (IBAction)startShortBreak:(id)sender {
    int minutes = [Preferences intValue:PREF_TIME_SHORT_BREAK];
    [self activateTimerMenuItem:self.startShortBreakMenuItem];
    [statusIcon shortBreak];
    [timer start:minutes context:shortBreakContext];
}

- (IBAction)startLongBreak:(id)sender {
    int minutes = [Preferences intValue:PREF_TIME_LONG_BREAK];
    [self activateTimerMenuItem:self.startLongBreakMenuItem];
    [statusIcon longBreak];
    [timer start:minutes context:longBreakContext];
}

- (IBAction)resetPomodoroCount:(id)sender {
    [tomighty resetPomodoroCount];
    [self updatePomodoroCountText];
    [self.resetPomodoroCountMenuItem setEnabled:NO];
}

- (void)stopTimer:(id)sender {
    [timer stop];
}

- (void)timerTick:(int)secondsRemaining {
    [self updateRemainingTime:secondsRemaining];
}

- (void)timerStarted:(int)secondsRemaining context:(TimerContext *)context {
    [self updateRemainingTime:secondsRemaining];
    [self.stopTimerMenuItem setEnabled:YES];
    
    if([Preferences intValue:PREF_SOUND_TIMER_START]) {
        [sounds crank];
    }
    
    if([self shouldPlayTicTacSound:context]) {
        [sounds startTicTac];
    }
}

- (void)timerStopped {
    [sounds stopTicTac];
    [statusIcon normal];
    [self updateRemainingTime:0];
    [self.stopTimerMenuItem setEnabled:NO];
    [self deactivateAllTimerMenuItems];
}

- (void)timerFinished:(TimerContext *)context {
    if([Preferences intValue:PREF_SOUND_TIMER_FINISH]) {
        [sounds bell];
    }
    
    if(context == pomodoroContext) {
        [self incrementPomodoroCount];
    }
    
    [self showFinishNotification:context];
}

- (void)activateTimerMenuItem:(NSMenuItem *)menuItem {
    [self deactivateAllTimerMenuItems];
    [self activateTimerMenuItem:NSOnState menuItem:menuItem];
}

- (void)activateTimerMenuItem:(NSInteger)activate menuItem:(NSMenuItem *)menuItem {
    BOOL enabled = activate == NSOnState ? NO : YES;
    [menuItem setEnabled:enabled];
    [menuItem setState:activate];
}

- (void)deactivateAllTimerMenuItems {
    [self activateTimerMenuItem:NSOffState menuItem:self.startPomodoroMenuItem];
    [self activateTimerMenuItem:NSOffState menuItem:self.startShortBreakMenuItem];
    [self activateTimerMenuItem:NSOffState menuItem:self.startLongBreakMenuItem];
}

- (void)updateRemainingTime:(int)secondsRemaining {
    int minutes = secondsRemaining / 60;
    int seconds = secondsRemaining % 60;
    
    NSString *text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    [self.remainingTimeMenuItem setTitle:text];
}

- (void)updatePomodoroCountText {
    int pomodoroCount = [tomighty pomodoroCount];
    BOOL isPlural = pomodoroCount > 1;
    NSString *text =
        pomodoroCount > 0 ?
            [NSString stringWithFormat:@"%d full pomodoro%@", pomodoroCount, isPlural ? @"s" : @""]
            : @"No full pomodoro yet";
    [self.pomodoroCountMenuItem setTitle:text];
}

- (void)incrementPomodoroCount {
    [tomighty incrementPomodoroCount];
    [self updatePomodoroCountText];
    [self.resetPomodoroCountMenuItem setEnabled:YES];
}

- (BOOL)shouldPlayTicTacSound:(TimerContext *)context {
    if(context == pomodoroContext)
        return [Preferences intValue:PREF_SOUND_TICTAC_POMODORO];
    else
        return [Preferences intValue:PREF_SOUND_TICTAC_BREAK];
}

- (void)showFinishNotification:(TimerContext *)context {
    NSString *title = [NSString stringWithFormat:@"%@ finished", [context name]];
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:title];
    [notification setSoundName:NSUserNotificationDefaultSoundName];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end
