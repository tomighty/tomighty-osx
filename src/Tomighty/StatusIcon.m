//
//  StatusItemManager.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 23/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "StatusIcon.h"

@implementation StatusIcon
{
    __strong NSStatusItem *statusItem;
    __strong NSImage *blackIcon;
    __strong NSImage *whiteIcon;
    __strong NSImage *redIcon;
    __strong NSImage *greenIcon;
    __strong NSImage *blueIcon;
}

- (id)initWithStatusMenu:(NSMenu *)statusMenu {
    self = [super init];
    
    if(self) {
        blackIcon = [NSImage imageNamed:@"status-normal.tiff"];
        whiteIcon = [NSImage imageNamed:@"status-white.tiff"];
        redIcon = [NSImage imageNamed:@"status-pomodoro.tiff"];
        greenIcon = [NSImage imageNamed:@"status-short-break.tiff"];
        blueIcon = [NSImage imageNamed:@"status-long-break.tiff"];
        [self createStatusItem:statusMenu];
    }
    
    return self;
}

- (void)normal {
    [statusItem setImage:blackIcon];
}

- (void)pomodoro {
    [statusItem setImage:redIcon];
}

- (void)shortBreak {
    [statusItem setImage:greenIcon];
}

- (void)longBreak {
    [statusItem setImage:blueIcon];
}

- (void)createStatusItem:(NSMenu *)statusMenu {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:blackIcon];
    [statusItem setAlternateImage:whiteIcon];
    [statusItem setMenu:statusMenu];
}

@end
