//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYDefaultSoundPlayer.h"

NSString * const SOUND_TIMER_START = @"timer_start";
NSString * const SOUND_TIMER_TICK = @"timer_tick";
NSString * const SOUND_TIMER_GOES_OFF = @"timer_goes_off";

@implementation TYDefaultSoundPlayer
{
    __strong NSMutableDictionary *soundClipCache;
    __strong NSSound *currentLoopingSoundClip;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        soundClipCache = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}

- (void)play:(NSString *)soundClipName
{
    [self play:soundClipName loops:false];
}

- (void)loop:(NSString *)soundClipName
{
    [self play:soundClipName loops:true];
}

- (void)stopCurrentLoop
{
    [currentLoopingSoundClip stop];
}

- (void)play:(NSString *)soundClipName loops:(BOOL)loops
{
    if(loops)
    {
        [self stopCurrentLoop];
    }
    
    NSSound *soundClip = [self getSoundClip:soundClipName];
    [soundClip setLoops:loops];
    [soundClip play];
    
    if(loops)
    {
        currentLoopingSoundClip = soundClip;
    }
}

- (NSSound *)getSoundClip:(NSString *)soundClipName
{
    NSSound *soundClip = [soundClipCache objectForKey:soundClipName];
    if(!soundClip)
    {
        soundClip = [NSSound soundNamed:soundClipName];
        soundClipCache[soundClipName] = soundClip;
    }
    return soundClip;
}

@end
