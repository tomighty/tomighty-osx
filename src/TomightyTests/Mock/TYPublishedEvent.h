//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>
#import "TYEventBus.h"

@interface TYPublishedEvent : NSObject

- (id)initWith:(TYEventType)eventType data:(id)data;
- (BOOL)matches:(TYEventType)eventType data:(id)data;

@end
