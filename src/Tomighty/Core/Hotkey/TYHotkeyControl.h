//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYHotkey.h"

/**
 @brief NSControl subclass for capturing and displaying user clicked hotkeys.
 
 @discussion When activated, this view listens to keyboard events and records
 the keystroke. Pressed keys are highlighted.
 
 <b>MVTHotkeyView</b> ignores Tab, because it's used in navigation.

*/
@interface TYHotkeyControl : NSControl <MVTHotkeyView>
@property (nonatomic, strong) TYHotkey* hotkey;
@end
