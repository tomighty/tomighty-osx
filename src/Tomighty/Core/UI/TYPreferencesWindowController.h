//
//  TYPreferencesWindowController.h
//  Tomighty
//
//  Created by Célio Cidral Jr on 12/03/14.
//  Copyright (c) 2014 Gig Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TYPreferencesWindowController : NSWindowController

- (id)initWithPreferences:(id <TYPreferences>)preferences;

@property (weak) IBOutlet NSTextField *text_time_pomodoro;
@property (weak) IBOutlet NSTextField *text_time_short_break;
@property (weak) IBOutlet NSTextField *text_time_long_break;
@property (weak) IBOutlet NSButton *check_play_sound_when_timer_starts;
@property (weak) IBOutlet NSButton *check_play_sound_when_timer_goes_off;
@property (weak) IBOutlet NSButton *check_play_ticktock_sound_during_pomodoro;
@property (weak) IBOutlet NSButton *check_play_ticktock_sound_during_break;

- (IBAction)save_time_pomodoro:(id)sender;
- (IBAction)save_time_short_break:(id)sender;
- (IBAction)save_time_long_break:(id)sender;
- (IBAction)save_play_sound_when_timer_starts:(id)sender;
- (IBAction)save_play_sound_when_timer_goes_off:(id)sender;
- (IBAction)save_play_ticktock_sound_during_pomodoro:(id)sender;
- (IBAction)save_play_ticktock_sound_during_break:(id)sender;

@end
