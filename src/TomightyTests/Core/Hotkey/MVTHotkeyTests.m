//
//  MVTHotkey.m
//  Tomighty
//
//  Created by Misha Tavkhelidze on 8/27/16.
//  Copyright © 2016 Gig Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Carbon/Carbon.h>
#import "MVTHotkey.h"

@interface MVTHotkeyTests : XCTestCase {
    MVTHotkey *key;
}

@end

@implementation MVTHotkeyTests

- (void)setUp {
    [super setUp];
    // ⇧⌘S
    key = [MVTHotkey hotkeyWithCode:0x1
                              flags:(0 | NSCommandKeyMask | NSShiftKeyMask)];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_should_have_command {
    XCTAssertTrue(key.cmd);
}

- (void)test_should_have_shift {
    XCTAssertTrue(key.shift);
}

- (void)test_should_not_have_alt {
    XCTAssertFalse(key.alt);
}

- (void)test_should_not_have_control {
    XCTAssertFalse(key.ctrl);
}

- (void)test_should_have_correct_code {
    XCTAssertTrue(key.code == 0x1);
}

- (void)test_should_have_correct_string {
    XCTAssertTrue([key.string isEqualToString:@"⇧⌘S"]);
}

- (void)test_should_return_full_attributed_string
{
    NSAttributedString *str = [key mutableAttributedString:nil
                                                 textColor:[NSColor redColor]
                                             inactiveColor:nil];
    XCTAssertTrue([str.string isEqualToString:@"^⌥⇧⌘S"]);
}

- (void)test_should_set_color_to_active_key {
    NSAttributedString *str = [key mutableAttributedString:nil
                                                 textColor:[NSColor redColor]
                                             inactiveColor:[NSColor greenColor]];
    NSDictionary *attr = [str attributesAtIndex:4 effectiveRange:nil];
    XCTAssertTrue([[attr objectForKey:NSForegroundColorAttributeName]
                   isEqual:[NSColor redColor]]);
}

- (void)test_should_set_color_to_active_modifier {
    NSAttributedString *str = [key mutableAttributedString:nil
                                                 textColor:[NSColor redColor]
                                             inactiveColor:[NSColor greenColor]];
    NSDictionary *attr = [str attributesAtIndex:3 effectiveRange:nil];
    XCTAssertTrue([[attr objectForKey:NSForegroundColorAttributeName]
                   isEqual:[NSColor redColor]]);
}

- (void)test_should_set_inactive_color_to_inactive_modifier {
    NSAttributedString *str = [key mutableAttributedString:nil
                                                 textColor:[NSColor redColor]
                                             inactiveColor:[NSColor greenColor]];
    NSDictionary *attr = [str attributesAtIndex:0 effectiveRange:nil];
    XCTAssertTrue([[attr objectForKey:NSForegroundColorAttributeName]
                   isEqual:[NSColor greenColor]]);
}

- (void)test_should_parse_string_correctly {
    key.string = @"^D";
    XCTAssertTrue(key.ctrl && key.code == 2);
}

@end
