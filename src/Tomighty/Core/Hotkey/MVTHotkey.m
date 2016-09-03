//
//  MVTHotkey.m
//  Tomighty
//
//  Created by Misha Tavkhelidze on 8/27/16.
//  Copyright © 2016 Gig Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "MVTHotkey.h"

static NSString* const MVTControlKeyString = @"^";
static NSString* const MVTAlternativeKeyString = @"⌥";
static NSString* const MVTShiftKeyString = @"⇧";
static NSString* const MVTCommandKeyString = @"⌘";

@implementation MVTHotkey {
    NSDictionary *_keymap;
}

#pragma mark Init

+ (id)hotkeyWithCode:(CGKeyCode)code flags:(UInt32)flags
{
    MVTHotkey *key = [[MVTHotkey alloc] init];
    if(key) {
        [key _withCodeAndFlags:code flags:flags];
    }
    return key;
}

+ (id)hotkeyWithString:(NSString*)str
{
    MVTHotkey *key = [[MVTHotkey alloc] init];
    key.string = str;
    return key;
}

- (id)init
{
    self = [super init];
    if(self != nil)
        _keymap = [self _makeKeymap];
    return self;
}

#pragma mark Properties

- (void)setString:(NSString *)string
{
    _flags = 0;
    _code = -1;
    for(int i = 0; i < string.length; i++) {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
         if([s isEqualToString:MVTControlKeyString])
            _flags |= NSControlKeyMask;
        else if([s isEqualToString:MVTAlternativeKeyString])
            _flags |= NSAlternateKeyMask;
        else if([s isEqualToString:MVTShiftKeyString])
            _flags |= NSShiftKeyMask;
        else if([s isEqualToString:MVTCommandKeyString])
            _flags |= NSCommandKeyMask;
        else {
            NSString *s = [string
                           substringWithRange:NSMakeRange(i, string.length - i)];
            _code = [self _stringToKeyCode:s];
            break;
        }
    }
    if(![self valid]) {
        _code = -1;
        _flags = -1;
    }
}

- (NSString *)string
{
    NSMutableArray *ar = [[NSMutableArray alloc] init];
    if(self.ctrl)
        [ar addObject:MVTControlKeyString];
    if(self.alt)
        [ar addObject:MVTAlternativeKeyString];
    if(self.shift)
        [ar addObject:MVTShiftKeyString];
    if(self.cmd)
        [ar addObject:MVTCommandKeyString];
    if([ar count] != 0 && _code != -1) {
        [ar addObject:[self _keyCodeToString:_code]];
        return [ar componentsJoinedByString:@""];
    }
    return nil;
}

- (BOOL)ctrl
{
    return _flags & NSControlKeyMask ? TRUE : FALSE;
}

- (BOOL)alt
{
    return _flags & NSAlternateKeyMask ? TRUE : FALSE;
}

- (BOOL)shift
{
    return _flags & NSShiftKeyMask ? TRUE : FALSE;
}

- (BOOL)cmd
{
    return _flags & NSCommandKeyMask ? TRUE : FALSE;
}

- (BOOL)valid
{
    return (([self ctrl] || [self alt] || [self shift] || [self cmd]) &&
            (_code != -1 && _code != kVK_Tab));
}

#pragma mark Methods

- (NSMutableAttributedString*)mutableAttributedString:(NSFont*)font
                                            textColor:(NSColor *)textColor
                                        inactiveColor:(NSColor *)inactiveColor
{
    NSMutableAttributedString *ret = nil;
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",
                     MVTControlKeyString, MVTAlternativeKeyString,
                     MVTShiftKeyString, MVTCommandKeyString,
                     [self _keyCodeToString:_code ]];

    ret = [[NSMutableAttributedString alloc] initWithString:str];

    if(font)
        [ret addAttribute:NSFontAttributeName value:font
                    range:NSMakeRange(0, str.length)];

    if(textColor)
        [ret addAttribute:NSForegroundColorAttributeName value:textColor
                    range:NSMakeRange(0, str.length)];

    if(inactiveColor) {
        if(!self.ctrl)
            [ret addAttribute:NSForegroundColorAttributeName
                        value:inactiveColor
                        range:NSMakeRange(0,MVTControlKeyString.length)];
        if(!self.alt)
            [ret addAttribute:NSForegroundColorAttributeName
                        value:inactiveColor
                        range:NSMakeRange(1,1)];
        if(!self.shift)
            [ret addAttribute:NSForegroundColorAttributeName
                        value:inactiveColor
                        range:NSMakeRange(2,1)];
        if(!self.cmd)
            [ret addAttribute:NSForegroundColorAttributeName
                        value:inactiveColor
                        range:NSMakeRange(3,1)];
    }
    return ret;
    
}

- (void)_withCodeAndFlags:(CGKeyCode)code flags:(UInt32)flags
{
    _code = code;
    _flags = flags;
    if(![self valid]) {
        _code = -1;
        _flags = -1;
    }
}

- (NSString*)_keyCodeToString:(CGKeyCode)code
{
    return [_keymap objectForKey:@(code)];
}

- (SInt32)_stringToKeyCode:(NSString*)str
{
    SInt32 __block ret = -1;
    [_keymap keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        *stop = [obj isEqualToString:str] ? YES : NO;
        if(stop) ret = [key intValue];
        return *stop;
    }];
    return ret;
}

- (NSDictionary*)_makeKeymap
{
    static dispatch_once_t once;
    static NSDictionary *keymap = nil;
    dispatch_once (&once, ^{
        keymap = @{
                    @(kVK_F1): @"F1",
                    @(kVK_F2): @"F2",
                    @(kVK_F3): @"F3",
                    @(kVK_F4): @"F4",
                    @(kVK_F5): @"F5",
                    @(kVK_F6): @"F6",
                    @(kVK_F7): @"F7",
                    @(kVK_F8): @"F8",
                    @(kVK_F9): @"F9",
                    @(kVK_F10): @"F10",
                    @(kVK_F11): @"F11",
                    @(kVK_F12): @"F12",
                    @(kVK_F13): @"F13",
                    @(kVK_F14): @"F14",
                    @(kVK_F15): @"F15",
                    @(kVK_F16): @"F16",
                    @(kVK_F17): @"F17",
                    @(kVK_F18): @"F18",
                    @(kVK_F19): @"F19",
                    @(kVK_ANSI_0): @"0",
                    @(kVK_ANSI_1): @"1",
                    @(kVK_ANSI_2): @"2",
                    @(kVK_ANSI_3): @"3",
                    @(kVK_ANSI_4): @"4",
                    @(kVK_ANSI_5): @"5",
                    @(kVK_ANSI_6): @"6",
                    @(kVK_ANSI_7): @"7",
                    @(kVK_ANSI_8): @"8",
                    @(kVK_ANSI_9): @"9",
                    @(kVK_ANSI_A): @"A",
                    @(kVK_ANSI_B): @"B",
                    @(kVK_ANSI_C): @"C",
                    @(kVK_ANSI_D): @"D",
                    @(kVK_ANSI_E): @"E",
                    @(kVK_ANSI_F): @"F",
                    @(kVK_ANSI_G): @"G",
                    @(kVK_ANSI_H): @"H",
                    @(kVK_ANSI_I): @"I",
                    @(kVK_ANSI_J): @"J",
                    @(kVK_ANSI_K): @"K",
                    @(kVK_ANSI_L): @"L",
                    @(kVK_ANSI_M): @"M",
                    @(kVK_ANSI_N): @"N",
                    @(kVK_ANSI_O): @"O",
                    @(kVK_ANSI_P): @"P",
                    @(kVK_ANSI_Q): @"Q",
                    @(kVK_ANSI_R): @"R",
                    @(kVK_ANSI_S): @"S",
                    @(kVK_ANSI_T): @"T",
                    @(kVK_ANSI_U): @"U",
                    @(kVK_ANSI_V): @"V",
                    @(kVK_ANSI_W): @"W",
                    @(kVK_ANSI_X): @"X",
                    @(kVK_ANSI_Y): @"Y",
                    @(kVK_ANSI_Z): @"Z",
                    @(kVK_ANSI_Grave): @"`",
                    @(kVK_ANSI_Minus): @"-",
                    @(kVK_ANSI_Equal): @"=",
                    @(kVK_Delete): @"Delete",
                    @(kVK_ANSI_LeftBracket): @"[",
                    @(kVK_ANSI_RightBracket): @"]",
                    @(kVK_ANSI_Backslash): @"\\",
                    @(kVK_ANSI_RightBracket): @"]",
                    @(kVK_CapsLock): @"Capslock",
                    @(kVK_ANSI_Semicolon): @";",
                    @(kVK_ANSI_Quote): @"'",
                    @(kVK_ANSI_Comma): @",",
                    @(kVK_ANSI_Period): @".",
                    @(kVK_ANSI_Slash): @"/",
                    @(kVK_Space): @"Space",
                    @(kVK_LeftArrow): @"←",
                    @(kVK_DownArrow): @"↓",
                    @(kVK_RightArrow): @"→",
                    @(kVK_UpArrow): @"↑",
                    @(kVK_Return): @"Enter",
                    @(kVK_Escape): @"Escape"
                    };
    });
    return keymap;
}

@end
