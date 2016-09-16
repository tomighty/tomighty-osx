//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <XCTest/XCTest.h>
#import <Carbon/Carbon.h>
#import "TYHotkey.h"

@interface TYHotkeyTests : XCTestCase {
    TYHotkey *key;
}

@end

@implementation TYHotkeyTests

- (void)setUp {
    [super setUp];
    // ⇧⌘S
    key = [TYHotkey hotkeyWithCode:0x1
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

- (void)test_should_report_invalid_without_key_code {
    key.string = @"^";
    XCTAssertFalse(key.valid);
}

- (void)test_should_report_invalid_if_tab {
    key = [TYHotkey hotkeyWithCode:kVK_Tab
                              flags:(0 | NSCommandKeyMask)];
    XCTAssertFalse(key.valid);
}

- (void)test_should_report_invalid_if_no_modifier
{
    key = [TYHotkey hotkeyWithCode:0x1 flags:0];
    XCTAssertFalse(key.valid);
}

- (void)test_should_have_code_minum_one_if_invalid
{
    key.string = @"R";
    XCTAssertTrue(key.code == -1);
}

- (void)test_should_have_flags_minus_one_if_invalid
{
    key.string = @"";
    XCTAssertTrue(key.flags == -1);
}

- (void)test_string_should_return_nil_if_invalid
{
    key.string = @"";
    XCTAssertTrue(key.string == nil);
}

- (void)test_sets_correct_carbon_flags {
    key.string = @"⇧⌘S";
    XCTAssertTrue(key.carbonFlags & (shiftKey + cmdKey));
}

- (void)test_does_not_set_incorrect_carbon_flags
{
    key.string = @"⇧⌘S";
    XCTAssertFalse(key.carbonFlags & optionKey);
}

@end
