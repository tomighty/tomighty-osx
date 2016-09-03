//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

@protocol TYAppUI <NSObject>

- (void)switchToIdleState;
- (void)switchToPomodoroState;
- (void)switchToShortBreakState;
- (void)switchToLongBreakState;
- (void)updateRemainingTime:(int)remainingSeconds;
- (void)updatePomodoroCount:(int)count;
- (void)handlePrerencesChange:(NSString*)which;

@end
