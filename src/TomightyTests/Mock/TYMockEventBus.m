//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYMockEventBus.h"
#import "TYPublishedEvent.h"

@implementation TYMockEventBus
{
    __strong NSMutableDictionary *subscribers;
    __strong NSMutableArray *publishedEvents;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        subscribers = [NSMutableDictionary dictionaryWithCapacity:8];
        publishedEvents = [NSMutableArray arrayWithCapacity:8];
    }
    return self;
}

- (void)subscribeTo:(TYEventType)eventType subscriber:(TYEventSubscriber)subscriber
{
    subscribers[@(eventType)] = subscriber;
}

- (void)publish:(TYEventType)eventType data:(id)data
{
    [publishedEvents addObject:[[TYPublishedEvent alloc] initWith:eventType data:data]];
    
    TYEventSubscriber subscriber = [subscribers objectForKey:@(eventType)];
    if(subscriber)
    {
        subscriber(data);
    }
}

- (void)clearPublishedEvents
{
    [publishedEvents removeAllObjects];
}

- (BOOL)hasPublishedEvent:(TYEventType)eventType withData:(id)eventData
{
    for(NSUInteger index = 0; index < [publishedEvents count]; index++)
    {
        TYPublishedEvent *publishedEvent = [publishedEvents objectAtIndex:index];
        if([publishedEvent matches:eventType data:eventData])
        {
            return true;
        }
    }
    return false;
}

- (BOOL)hasPublishedEvent:(TYEventType)eventType withData:(id)eventData atPosition:(NSUInteger)position
{
    if(position > [publishedEvents count] || position <= 0)
    {
        return false;
    }
    TYPublishedEvent *publishedEvent = [publishedEvents objectAtIndex:(position - 1)];
    if(!publishedEvent)
    {
        return false;
    }
    return [publishedEvent matches:eventType data:eventData];
}

- (NSUInteger)getPublishedEventCount
{
    return [publishedEvents count];
}

@end
