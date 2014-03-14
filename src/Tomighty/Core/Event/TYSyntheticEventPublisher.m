//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYSyntheticEventPublisher.h"
#import "TYTimerContext.h"

@implementation TYSyntheticEventPublisher

- (void)publishSyntheticEventsInResponseToOtherEventsFrom:(id <TYEventBus>)eventBus
{
    [eventBus subscribeTo:TIMER_START subscriber:^(id eventData)
    {
        id <TYTimerContext> timerContext = eventData;
        
        if([timerContext getContextType] == POMODORO)
        {
            [eventBus publish:POMODORO_START data:timerContext];
        }
        else if([timerContext getContextType] == SHORT_BREAK)
        {
            [eventBus publish:BREAK_START data:timerContext];
            [eventBus publish:SHORT_BREAK_START data:timerContext];
        }
        else if([timerContext getContextType] == LONG_BREAK)
        {
            [eventBus publish:BREAK_START data:timerContext];
            [eventBus publish:LONG_BREAK_START data:timerContext];
        }
    }];
    
    [eventBus subscribeTo:TIMER_STOP subscriber:^(id eventData)
    {
        id <TYTimerContext> timerContext = eventData;
        
        if([timerContext getRemainingSeconds] > 0)
        {
            [eventBus publish:TIMER_ABORT data:eventData];
        }
        else
        {
            [eventBus publish:TIMER_GOES_OFF data:eventData];
            if([timerContext getContextType] == POMODORO)
            {
                [eventBus publish:POMODORO_COMPLETE data:timerContext];
            }
        }
    }];
}

@end
