//
//  MVTHotkeyView.m
//
//  Created by Misha Tavkhelidze <misha.tavkhelidze@gmail.com>
//  Copyright © 2016 Misha Tavkhelidze. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "MVTHotkeyControl.h"
#import "MVTHotkeyCell.h"
#import "MVTHotkey.h"

IB_DESIGNABLE

@implementation MVTHotkeyControl {
    BOOL _key_valid;
    MVTHotkey *_key;
}

#pragma mark Initialization

/// Sets control defaults. Those can be overriden in IB
- (void)setDefaults
{
    _key = nil;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if(self != nil) {
        [self setDefaults];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    if(self != nil) {
        [self setDefaults];
    }

    return self;
}

#pragma mark Properties
- (void)setHotkey:(MVTHotkey*)hotkey
{
    if(hotkey.valid) {
        _key = hotkey;
        [_cell setHotkey:_key];
        [self sendAction:self.action to:self.target];
    }
}

- (MVTHotkey*)hotkey
{
    return _key;
}

#pragma mark Responders

- (void)keyDown:(NSEvent *)theEvent
{
    MVTHotkey *key = [MVTHotkey hotkeyWithCode:[theEvent keyCode]
                                         flags:theEvent.modifierFlags];
    if(key.valid)
        [self setHotkey:key];
    else
        [[super window] keyDown:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    // Prevent background redraw by doing nothing.
}

@end
