//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYHotkey.h"
#import "TYHotkeyCell.h"

@implementation TYHotkeyCell

- (void)setHotkey:(TYHotkey*)key
{
    // Respect IB text alignment settings
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = self.alignment;
    NSMutableAttributedString *as;
    as = [key mutableAttributedString:self.font
                            textColor:self.textColor
                        inactiveColor:[NSColor controlHighlightColor]];
    [as addAttribute:NSParagraphStyleAttributeName value:ps
               range:NSMakeRange(0, as.length)];

    [self setAttributedStringValue:as];
}

@end
