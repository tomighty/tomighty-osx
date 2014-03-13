//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>
#import "TYEventBus.h"
#import "TYPreferences.h"
#import "TYSoundPlayer.h"

@interface TYSoundAgent : NSObject

- (id)initWith:(id <TYSoundPlayer>)soundPlayer preferences:(id <TYPreferences>)preferences;
- (void)playSoundsInResponseToEventsFrom:(id <TYEventBus>)eventBus;

@end
