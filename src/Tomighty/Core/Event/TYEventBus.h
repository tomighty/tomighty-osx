//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TYEventType)
{
    TIMER_START,
    TIMER_TICK,
    TIMER_STOP,
    TIMER_ABORT,
    TIMER_GOES_OFF,
    
    POMODORO_START,
    BREAK_START,
    SHORT_BREAK_START,
    LONG_BREAK_START,
    
    POMODORO_COMPLETE,
    
    POMODORO_COUNT_CHANGE,
    
    PREFERENCE_CHANGE
};

typedef void (^TYEventSubscriber)(id eventData);

@protocol TYEventBus <NSObject>

- (void)subscribeTo:(TYEventType)eventType subscriber:(TYEventSubscriber)subscriber;
- (void)publish:(TYEventType)eventType data:(id)data;

@end
