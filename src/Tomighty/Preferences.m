//
//  Preferences.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 28/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "Preferences.h"

NSString * const PREF_TIME_POMODORO = @"time_pomodoro";
NSString * const PREF_TIME_SHORT_BREAK = @"time_short_break";
NSString * const PREF_TIME_LONG_BREAK = @"time_long_break";
NSString * const PREF_SOUND_TIMER_START = @"sound_timer_start";
NSString * const PREF_SOUND_TIMER_FINISH = @"sound_timer_finish";
NSString * const PREF_SOUND_TICTAC_POMODORO = @"sound_tictac_pomodoro";
NSString * const PREF_SOUND_TICTAC_BREAK = @"sound_tictac_break";

@implementation Preferences

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        
        NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
        [defaultValues setObject:[NSNumber numberWithInt:25] forKey:PREF_TIME_POMODORO];
        [defaultValues setObject:[NSNumber numberWithInt:5] forKey:PREF_TIME_SHORT_BREAK];
        [defaultValues setObject:[NSNumber numberWithInt:15] forKey:PREF_TIME_LONG_BREAK];
        [defaultValues setObject:[NSNumber numberWithInt:1] forKey:PREF_SOUND_TIMER_START];
        [defaultValues setObject:[NSNumber numberWithInt:1] forKey:PREF_SOUND_TIMER_FINISH];
        [defaultValues setObject:[NSNumber numberWithInt:1] forKey:PREF_SOUND_TICTAC_POMODORO];
        [defaultValues setObject:[NSNumber numberWithInt:1] forKey:PREF_SOUND_TICTAC_BREAK];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    }
}

+ (int)intValue:(NSString *)key {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)setIntValue:(NSString *)key value:(int)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

@end
