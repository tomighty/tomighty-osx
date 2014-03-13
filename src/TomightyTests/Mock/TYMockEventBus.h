//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>
#import "TYEventBus.h"

@interface TYMockEventBus : NSObject <TYEventBus>

- (void)clearPublishedEvents;
- (NSUInteger)getPublishedEventCount;
- (BOOL)hasPublishedEvent:(TYEventType)eventType withData:(id)eventData;
- (BOOL)hasPublishedEvent:(TYEventType)eventType withData:(id)eventData atPosition:(NSUInteger)position;

@end
