//
//  Sounds.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 28/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "Sounds.h"

@implementation Sounds
{
    __strong NSSound *crankSound;
    __strong NSSound *ticTacSound;
    __strong NSSound *bell;
}

- (id)init
{
    self = [super init];
    if(self) {
        crankSound = [NSSound soundNamed:@"crank"];
        ticTacSound = [NSSound soundNamed:@"tictac"];
        bell = [NSSound soundNamed:@"deskbell"];
        
        [ticTacSound setLoops:YES];
    }
    return self;
}

- (void)crank {
    [crankSound stop];
    [crankSound play];
}

- (void)startTicTac {
    [ticTacSound stop];
    [ticTacSound play];
}

- (void)stopTicTac {
    [ticTacSound stop];
}

- (void)bell {
    [bell play];
}

@end
