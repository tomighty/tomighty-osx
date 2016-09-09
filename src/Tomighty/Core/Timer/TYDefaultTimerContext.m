//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYDefaultTimerContext.h"

@implementation TYDefaultTimerContext
{
    TYTimerContextType contextType;
    NSString *name;
    int remainingSeconds;
}

+ (id)ofType:(TYTimerContextType)contextType name:(NSString *)name remainingSeconds:(int)initialRemainingSeconds
{
    return [[TYDefaultTimerContext alloc] initAs:contextType name:name remainingSeconds:initialRemainingSeconds];
}

- (id)initAs:(TYTimerContextType)aContextType name:(NSString *)aName remainingSeconds:(int)initialRemainingSeconds
{
    self = [super init];
    if(self) {
        contextType = aContextType;
        name = aName;
        remainingSeconds = initialRemainingSeconds;
    }
    return self;
}

- (NSString *)getName
{
    return name;
}

- (int)getRemainingSeconds
{
    return remainingSeconds;
}

- (void)addSeconds:(int)seconds
{
    remainingSeconds += seconds;
}

- (TYTimerContextType)getContextType
{
    return contextType;
}

@end
