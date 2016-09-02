//
//  MVTHotkeyView.h
//
//  Created by Misha Tavkhelidze <misha.tavkhelidze@gmail.com>.
//  Copyright © 2016 Misha Tavkhelidze. All rights reserved.
//

#import "MVTHotkey.h"

/**
 @brief NSView subclass for capturing user clicked hotkeys
 
 @discussion When activated, this view listens to keyboard events and records
 the keystroke. Pressed keys are highlighted.
 
 To use this class in IB select <b>CustomView</b> object from the library, plase
 it in your window and assign <b>MVTHotkeyView</b> as a class to it.
 
 @remarks To be able capture Command (⌘) key controlling NSApplication's
 <code>sendAction</code> must be overriden.
 
 <b>MVTHotkeyView</b> ignores Tab, because it's used in navigation.

*/
@interface MVTHotkeyControl : NSControl <MVTHotkeyView>
@property (nonatomic, strong) MVTHotkey* hotkey;
@end
