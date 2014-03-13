//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYDefaultSystemTimer.h"

@implementation TYDefaultSystemTimer
{
    __strong NSTimer *timer;
    __strong TYSystemTimerTrigger currentTrigger;
}

- (void)triggerRepeatedly:(TYSystemTimerTrigger)trigger intervalInSeconds:(int)seconds
{
    [self interrupt];
    
    currentTrigger = trigger;
    
    timer = [NSTimer timerWithTimeInterval:seconds
                                    target:self
                                  selector:@selector(tick:)
                                  userInfo:nil
                                   repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)interrupt
{
    [timer invalidate];
    
    timer = nil;
    currentTrigger = nil;
}

- (void)tick:(NSTimer *)aTimer
{
    currentTrigger();
}

@end
