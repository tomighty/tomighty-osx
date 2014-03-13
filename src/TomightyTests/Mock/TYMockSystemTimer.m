//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYMockSystemTimer.h"

@implementation TYMockSystemTimer
{
    __strong TYSystemTimerTrigger trigger;
    BOOL isInterrupted;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        isInterrupted = false;
    }
    return self;
}

- (void)tick
{
    trigger();
}

- (void)triggerRepeatedly:(TYSystemTimerTrigger)aTrigger intervalInSeconds:(int)seconds
{
    trigger = aTrigger;
}

- (void)interrupt
{
    isInterrupted = true;
}

- (BOOL)isInterrupted
{
    return isInterrupted;
}

@end
