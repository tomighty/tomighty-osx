//
//  TimerContext.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 29/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "TimerContext.h"

@implementation TimerContext
{
    __strong NSString *name;
}

- (id)initWithName:(NSString *)aName {
    self = [super init];
    if(self) {
        name = aName;
    }
    return self;
}

- (NSString *)name {
    return name;
}

@end
