//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

#import "TYStatusIcon.h"
#import "TYImageLoader.h"

@interface TYDefaultStatusIcon : NSObject <TYStatusIcon>

- (id)initWith:(NSMenu *)menu imageLoader:(TYImageLoader *)imageLoader;

@end
