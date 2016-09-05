//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYHotkey.h"
/**
 @brief NSTextFieldCell subclass to draw hotkey string.
 
 @discussion TYHotkeyCell respects IB's text alignment settings. Nothing else yet.
 */
@interface TYHotkeyCell : NSTextFieldCell <MVTHotkeyView>

- (void)setHotkey:(TYHotkey*)key;

@end
