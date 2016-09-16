//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//


/// @credits
#import <Foundation/Foundation.h>

@class NSColor;
@class NSFont;
@class TYHotkey;

@protocol MVTHotkeyView <NSObject>

- (void)setHotkey:(TYHotkey*)hotkey;

@optional
- (TYHotkey*)hotkey;

@end
/**
 @brief A helper class to handle and represent OS X hotkey.
 */
@interface TYHotkey : NSObject

@property (readonly) BOOL ctrl;
@property (readonly) BOOL alt;
@property (readonly) BOOL shift;
@property (readonly) BOOL cmd;
@property (readonly) BOOL valid;
@property (nonatomic, assign) SInt32 code;
@property (nonatomic, assign) UInt32 flags;
@property (readonly) UInt32 carbonFlags;
@property (nonatomic, strong) NSString *string;

+ (id)hotkeyWithCode:(CGKeyCode)code flags:(UInt32)flags;
+ (id)hotkeyWithString:(NSString*)string;

- (NSMutableAttributedString*)mutableAttributedString:(NSFont*)font
                                            textColor:(NSColor*)textColor
                                        inactiveColor:(NSColor*)inactiveColor;
@end

#define enter(oid) NSLog(@"%s %@", __PRETTY_FUNCTION__, oid)
