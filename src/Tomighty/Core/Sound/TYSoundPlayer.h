//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

extern NSString * const SOUND_TIMER_START;
extern NSString * const SOUND_TIMER_TICK;
extern NSString * const SOUND_TIMER_GOES_OFF;

@protocol TYSoundPlayer <NSObject>

- (void)play:(NSString *)soundClipName;
- (void)loop:(NSString *)soundClipName;
- (void)stopCurrentLoop;

@end
