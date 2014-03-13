//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

#import "TYEventBus.h"
#import "TYPreferences.h"
#import "TYTimer.h"
#import "TYTomighty.h"

@interface TYDefaultTomighty : NSObject <TYTomighty>

- (id)initWith:(id <TYTimer>)timer
   preferences:(id <TYPreferences>)preferences
      eventBus:(id <TYEventBus>)eventBus;

@end
