//
//  MVTHotkeyView.h
//
//  Created by Misha Tavkhelidze <misha.tavkhelidze@gmail.com>.
//  Copyright © 2016 Misha Tavkhelidze. All rights reserved.
//

#import "MVTHotkey.h"

/**
 @brief NSControl subclass for capturing user clicked hotkeys
 
 @discussion When activated, this view listens to keyboard events and records
 the keystroke. Pressed keys are highlighted.
 
 <b>MVTHotkeyView</b> ignores Tab, because it's used in navigation.

*/
@interface MVTHotkeyControl : NSControl <MVTHotkeyView>
@property (nonatomic, strong) MVTHotkey* hotkey;
@end
