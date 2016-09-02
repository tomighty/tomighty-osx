//
//  MVTHotkeyCell.h
//  MVTHotkeyViewApp
//
//  Created by Misha Tavkhelidze on 8/28/16.
//  Copyright © 2016 Misha Tavkhelidze. All rights reserved.
//

#import "MVTHotkey.h"

@interface MVTHotkeyCell : NSTextFieldCell <MVTHotkeyView>

- (void)setHotkey:(MVTHotkey*)key;

@end
