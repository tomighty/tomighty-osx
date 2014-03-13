//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>
#import "TYEventBus.h"
#import "TYSystemTimer.h"
#import "TYTimerContext.h"
#import "TYTimer.h"

@interface TYDefaultTimer : NSObject <TYTimer>

+ (id)createWith:(id<TYEventBus>)anEventBus systemTimer:(id<TYSystemTimer>)aSystemTimer;

@end
