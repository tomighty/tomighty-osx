//
//  Timer.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 24/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "Timer.h"
#import "TimerContext.h"
#import "TimerListener.h"

#define SIXTY_SECONDS 60

@implementation Timer
{
    int secondsRemaining;
    __strong NSTimer *timer;
    __strong TimerContext *context;
    __weak id <TimerListener> listener;
}

- (id)initWithListener:(id <TimerListener>)aListener {
    self = [super init];
    if(self) {
        listener = aListener;
    }
    return self;
}

- (void)start:(int)minutes context:(TimerContext *)aContext {
    secondsRemaining = minutes * SIXTY_SECONDS;
    context = aContext;
    [self startTimer];
    [listener timerStarted:secondsRemaining context:context];
}

- (void)startTimer {
    [timer invalidate];
    timer = [NSTimer timerWithTimeInterval:1.0
                     target:self
                     selector:@selector(tick:)
                     userInfo:nil
                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [timer invalidate];
    timer = nil;
    [listener timerStopped];
}

- (void)tick:(NSTimer *)aTimer {
    secondsRemaining--;
    if(secondsRemaining > 0) {
        [listener timerTick:secondsRemaining];
    }
    else {
        [self finished];
    }
}

- (void)finished {
    [self stop];
    [listener timerFinished:context];
    context = nil;
}

@end
