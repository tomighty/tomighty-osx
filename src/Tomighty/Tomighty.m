//
//  Tomighty.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 29/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "Tomighty.h"

@implementation Tomighty
{
    int pomodoroCount;
}

- (int)pomodoroCount {
    return pomodoroCount;
}

- (void)incrementPomodoroCount {
    pomodoroCount++;
    if(pomodoroCount > 4) {
        pomodoroCount = 1;
    }
}

- (void)resetPomodoroCount {
    pomodoroCount = 0;
}

@end
