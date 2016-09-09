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
    if (subscriber == nil)
        return;

    NSMutableArray *subscribers = [self produceSubscriberListForEventType:eventType];
    [subscribers addObject:[subscriber copy]];
}

- (void)publish:(TYEventType)eventType data:(id)data
{
    NSMutableArray *subscribers = map[@(eventType)];
    for(TYEventSubscriber subscriber in subscribers)
    {
        subscriber(data);
    }
}

- (NSMutableArray *)produceSubscriberListForEventType:(TYEventType)eventType
{
    NSMutableArray *subscribers = map[@(eventType)];
    if(!subscribers)
    {
        subscribers = [NSMutableArray arrayWithCapacity:8];
        map[@(eventType)] = subscribers;
    }
    return subscribers;
}

@end
