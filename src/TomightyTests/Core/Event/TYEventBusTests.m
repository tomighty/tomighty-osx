//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <XCTest/XCTest.h>
#import "TYEventBus.h"
#import "TYDefaultEventBus.h"

@interface TYEventBusTests : XCTestCase

@end

@implementation TYEventBusTests
{
    __strong id<TYEventBus> eventBus;
}

- (void)setUp
{
    [super setUp];
    eventBus = [[TYDefaultEventBus alloc] init];
}

- (void)test_subscriber_receives_event_of_desired_type
{
    __block BOOL hasReceivedEvent = false;
    
    [eventBus subscribeTo:TIMER_START subscriber:^(id eventData)
    {
        hasReceivedEvent = true;
    }];
    
    [eventBus publish:TIMER_START data:nil];
    
    XCTAssertTrue(hasReceivedEvent);
}

- (void)test_subscriber_does_not_receive_event_of_undesired_type
{
    __block BOOL hasReceivedEvent = false;
    
    [eventBus subscribeTo:TIMER_START subscriber:^(id eventData)
     {
         hasReceivedEvent = true;
     }];
    
    [eventBus publish:TIMER_STOP data:nil];
    
    XCTAssertFalse(hasReceivedEvent);
}

- (void)test_subscriber_receives_the_correct_event_data
{
    __block id receivedEventData;
    id expectedEventData = @"Foo bar";

    [eventBus subscribeTo:TIMER_START subscriber:^(id eventData)
    {
        receivedEventData = eventData;
    }];

    [eventBus publish:TIMER_START data:expectedEventData];

    XCTAssertEqualObjects(receivedEventData, expectedEventData);
}

- (void)test_two_subscribers_receive_event_of_desired_type
{
    __block BOOL hasFirstSubscriberReceivedEvent = false;
    __block BOOL hasSecondSubscriberReceivedEvent = false;
    
    [eventBus subscribeTo:TIMER_START subscriber:^(id eventData)
     {
         hasFirstSubscriberReceivedEvent = true;
     }];
    
    [eventBus subscribeTo:TIMER_START subscriber:^(id eventData)
     {
         hasSecondSubscriberReceivedEvent = true;
     }];
    
    [eventBus publish:TIMER_START data:nil];
    
    XCTAssertTrue(hasFirstSubscriberReceivedEvent);
    XCTAssertTrue(hasSecondSubscriberReceivedEvent);
}

- (void)test_subscribers_only_receive_events_of_desired_type
{
    __block BOOL hasFirstSubscriberReceivedEvent = false;
    __block BOOL hasSecondSubscriberReceivedEvent = false;
    __block BOOL hasThirdSubscriberReceivedEvent = false;

    [eventBus subscribeTo:TIMER_START subscriber:^(id eventData)
     {
         hasFirstSubscriberReceivedEvent = true;
     }];
    
    [eventBus subscribeTo:TIMER_TICK subscriber:^(id eventData)
     {
         hasSecondSubscriberReceivedEvent = true;
     }];
    
    [eventBus subscribeTo:TIMER_START subscriber:^(id eventData)
     {
         hasThirdSubscriberReceivedEvent = true;
     }];
    
    [eventBus publish:TIMER_TICK data:nil];
    
    XCTAssertFalse(hasFirstSubscriberReceivedEvent);
    XCTAssertTrue(hasSecondSubscriberReceivedEvent);
    XCTAssertFalse(hasThirdSubscriberReceivedEvent);
}

- (void)test_do_not_give_error_when_publishing_event_with_no_subscribers
{
    [eventBus publish:TIMER_TICK data:nil];
}

@end
