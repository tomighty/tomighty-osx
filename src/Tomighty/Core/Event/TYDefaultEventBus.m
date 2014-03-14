//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYDefaultEventBus.h"

@implementation TYDefaultEventBus
{
    NSMutableDictionary *map;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        map = [NSMutableDictionary dictionaryWithCapacity:8];
    }
    return self;
}

- (void)subscribeTo:(TYEventType)eventType subscriber:(TYEventSubscriber)subscriber
{
    NSMutableArray *subscribers;
    subscribers = [self produceSubscriberListForEventType:eventType];
    [subscribers addObject:subscriber];
}

- (void)publish:(TYEventType)eventType data:(id)data
{
    NSMutableArray *subscribers = [map objectForKey:@(eventType)];
    for(int index = 0; index < [subscribers count]; index++)
    {
        TYEventSubscriber subscriber = (TYEventSubscriber) [subscribers objectAtIndex:index];
        subscriber(data);
    }
}

- (NSMutableArray *)produceSubscriberListForEventType:(TYEventType)eventType
{
    NSMutableArray *subscribers = [map objectForKey:@(eventType)];
    if(!subscribers)
    {
        subscribers = [NSMutableArray arrayWithCapacity:8];
        map[@(eventType)] = subscribers;
    }
    return subscribers;
}

@end
