//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

typedef void (^TYSystemTimerTrigger)();

@protocol TYSystemTimer <NSObject>

- (void)triggerRepeatedly:(TYSystemTimerTrigger)trigger intervalInSeconds:(int)seconds;
- (void)interrupt;

@end
