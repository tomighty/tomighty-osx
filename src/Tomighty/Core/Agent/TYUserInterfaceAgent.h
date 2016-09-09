//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

#import "TYAppUI.h"
#import "TYEventBus.h"
#import "TYPreferences.h"

@interface TYUserInterfaceAgent : NSObject

- (id)initWith:(id <TYAppUI>)ui preferences:(id <TYPreferences>)aPreferences;
- (void)updateAppUiInResponseToEventsFrom:(id <TYEventBus>)eventBus;

@end
