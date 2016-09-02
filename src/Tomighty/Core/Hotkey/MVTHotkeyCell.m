//
//  MVTHotkeyCell.m
//  MVTHotkeyViewApp
//
//  Created by Misha Tavkhelidze on 8/28/16.
//  Copyright © 2016 Misha Tavkhelidze. All rights reserved.
//

#import "MVTHotkey.h"
#import "MVTHotkeyCell.h"

@implementation MVTHotkeyCell

- (void)setHotkey:(MVTHotkey*)key
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = self.alignment;
    NSMutableAttributedString *as;
    as = [key mutableAttributedString:self.font
                            textColor:self.textColor
                        inactiveColor:[NSColor controlHighlightColor]];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, as.length)];
    [self setAttributedStringValue:as];
}

@end
