//
//  HMG_AREA_QUERY.m
//  hmg
//
//  Created by Lee on 15/4/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "HMG_AREA_QUERY.h"

@implementation HMG_AREA_QUERY
@synthesize IN_DEPT_ID=_IN_DEPT_ID;
@synthesize IN_IS_FCU=_IN_IS_FCU;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_DEPT_ID=[aDecoder decodeObjectForKey:@"IN_DEPT_ID"];
        _IN_IS_FCU=[aDecoder decodeObjectForKey:@"IN_IS_FCU"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_DEPT_ID forKey:@"IN_DEPT_ID"];
    [aCoder encodeObject:_IN_IS_FCU forKey:@"IN_IS_FCU"];
}


@end
