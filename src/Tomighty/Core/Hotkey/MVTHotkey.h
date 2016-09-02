//
//  MVTHotkey.h
//  Tomighty
//
//  Created by Misha Tavkhelidze on 8/27/16.
//  Copyright © 2016 Gig Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSColor;
@class NSFont;
/**
 @brief Helper object for MVTHotkeyView
 */
@interface MVTHotkey : NSObject

@property (readonly) BOOL ctrl;
@property (readonly) BOOL alt;
@property (readonly) BOOL shift;
@property (readonly) BOOL cmd;
@property (nonatomic, assign) SInt32 code;
@property (nonatomic, assign) UInt32 flags;
@property (nonatomic, strong) NSString *string;

+ (id)hotkeyWithCode:(CGKeyCode)code flags:(UInt32)flags;

- (NSMutableAttributedString*)mutableAttributedString:(NSFont*)font
                                            textColor:(NSColor*)textColor
                                        inactiveColor:(NSColor*)inactiveColor;
@end

#define enter(oid) NSLog(@"%s %@", __PRETTY_FUNCTION__, oid)
