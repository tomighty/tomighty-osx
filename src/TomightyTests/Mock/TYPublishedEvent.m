//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYPublishedEvent.h"

@implementation TYPublishedEvent
{
    TYEventType eventType;
    __strong id eventData;
}

- (id)initWith:(TYEventType)anEventType data:(id)someEventData
{
    self = [super init];
    if(self)
    {
        eventType = anEventType;
        eventData = someEventData;
    }
    return self;
}

- (BOOL)matches:(TYEventType)anotherEventType data:(id)anotherEventData
{
    return
    eventType == anotherEventType &&
    eventData == anotherEventData;
}

@end
