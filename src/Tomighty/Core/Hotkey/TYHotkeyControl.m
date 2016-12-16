//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Carbon/Carbon.h>
#import "TYHotkeyControl.h"
#import "TYHotkeyCell.h"
#import "TYHotkey.h"

IB_DESIGNABLE

@implementation TYHotkeyControl {
    BOOL _key_valid;
    TYHotkey *_key;
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
- (void)setHotkey:(TYHotkey*)hotkey
{
    if(hotkey.valid) {
        _key = hotkey;
        [_cell setHotkey:_key];
        [self sendAction:self.action to:self.target];
    }
}

- (TYHotkey*)hotkey
{
    return _key;
}

#pragma mark Responders

- (void)keyDown:(NSEvent *)theEvent
{
    TYHotkey *key = [TYHotkey hotkeyWithCode:[theEvent keyCode]
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
