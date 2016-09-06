//
//  HMG_DEPT_QUERY.m
//  hmg
//
//  Created by Lee on 15/4/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "HMG_DEPT_QUERY.h"

@implementation HMG_DEPT_QUERY
@synthesize IN_DEPT_ID=_IN_DEPT_ID;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_DEPT_ID=[aDecoder decodeObjectForKey:@"IN_DEPT_ID"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_DEPT_ID forKey:@"IN_DEPT_ID"];
}

@end
