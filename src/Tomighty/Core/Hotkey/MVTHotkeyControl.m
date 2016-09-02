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
    _key_valid = FALSE;
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
    if([self isKeyValid:hotkey]) {
        _key = hotkey;
        [_cell setHotkey:_key];
    }
}

- (MVTHotkey*)hotkey
{
    return _key;
}

#pragma mark Responders

- (void)keyDown:(NSEvent *)theEvent
{
    enter(nil);
    _key = [MVTHotkey hotkeyWithCode:[theEvent keyCode] flags:theEvent.modifierFlags];
    if([self isKeyValid:_key]) {
        [_cell setHotkey:_key];
        [self sendAction:self.action to:self.target];
    } else
        [[super window] keyDown:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    // Prevent background redraw by doing nothing.
}

#pragma mark Utilities
- (BOOL)isKeyValid:(MVTHotkey*)key
{
    return
    (_key.ctrl || _key.alt || _key.shift || _key.cmd) &&
    (_key.code != kVK_Tab) ? TRUE : FALSE;

}

@end
