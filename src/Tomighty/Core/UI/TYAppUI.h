//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, TYAppUIRemainingTimeMode) {
      TYAppUIRemainingTimeModeDefault = 0, // no special treatment of seconds - display as is
      TYAppUIRemainingTimeModeStart, // timer just started - in minute view substract one second to prevent displaying 26m as remaining time
      TYAppUIRemainingTimeModeUseLastTime, // refresh status bar after settings change - use last known value passed with other modes
};

typedef NS_ENUM(int, TYAppUIStatusIconTextFormat) {
    TYAppUIStatusIconTextFormatNone = 0,
    TYAppUIStatusIconTextFormatMinutes,
    TYAppUIStatusIconTextFormatSeconds
};

@protocol TYAppUI <NSObject>

- (void)switchToIdleState;
- (void)switchToPomodoroState;
- (void)switchToShortBreakState;
- (void)switchToLongBreakState;
- (void)updateRemainingTime:(int)remainingSeconds withMode:(TYAppUIRemainingTimeMode)mode;
- (void)updatePomodoroCount:(int)count;
- (void)setStatusIconTextFormat:(TYAppUIStatusIconTextFormat)textFormat;

@end
