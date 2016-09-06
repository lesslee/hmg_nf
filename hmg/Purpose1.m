//
//  Purpose1.m
//  hmg
//
//  Created by hongxianyu on 2016/8/19.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Purpose1.h"

@implementation Purpose1
@synthesize ID=_ID;
@synthesize NAME=_NAME;

-(id) initWithID:(NSString *)ID andNAME:(NSString *)NAME
{
    if (self = [super init]) {
        self.ID=ID;
        self.NAME=NAME;
    }
    
    return self;
}

@end
