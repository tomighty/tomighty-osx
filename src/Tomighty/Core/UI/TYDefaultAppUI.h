//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

#import "TYAppUI.h"
#import "TYStatusIcon.h"
#import "TYStatusMenu.h"

@interface TYDefaultAppUI : NSObject <TYAppUI>

- (id)initWith:(id <TYStatusMenu>)statusMenu statusIcon:(id<TYStatusIcon>)statusIcon;

@property (nonatomic) TYAppUIStatusIconTextFormat statusIconTextFormat;

@end
