//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TYTimerContextType)
{
    POMODORO,
    SHORT_BREAK,
    LONG_BREAK
};

@protocol TYTimerContext <NSObject>

- (NSString *)getName;
- (int)getRemainingSeconds;
- (void)addSeconds:(int)seconds;
- (TYTimerContextType)getContextType;

@end
