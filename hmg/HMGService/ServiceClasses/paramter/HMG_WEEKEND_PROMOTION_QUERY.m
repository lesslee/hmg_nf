//
//  HMG_WEEKEND_PROMOTION_QUERY.m
//  hmg
//
//  Created by Hongxianyu on 16/4/14.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_WEEKEND_PROMOTION_QUERY.h"

@implementation HMG_WEEKEND_PROMOTION_QUERY

@synthesize IN_STORE_ID = _IN_STORE_ID;
@synthesize IN_EMP_NO = _IN_EMP_NO;
@synthesize IN_AREA_ID = _IN_AREA_ID;
@synthesize IN_DEPT_ID = _IN_DEPT_ID;
@synthesize IN_TYPE_ID = _IN_TYPE_ID;
@synthesize IN_END_DATE = _IN_END_DATE;
@synthesize IN_PAGE_SIZE = _IN_PAGE_SIZE;
@synthesize IN_START_DATE = _IN_START_DATE;
@synthesize IN_CURRENT_PAGE = _IN_CURRENT_PAGE;

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _IN_STORE_ID = [aDecoder decodeObjectForKey:@"IN_STORE_ID"];
        _IN_TYPE_ID = [aDecoder decodeObjectForKey:@"IN_TYPE_ID"];
        _IN_CURRENT_PAGE = [aDecoder decodeObjectForKey:@"IN_CURRENT_PAGE"];
        _IN_START_DATE = [aDecoder decodeObjectForKey:@"IN_START_DATE"];
        _IN_PAGE_SIZE = [aDecoder decodeObjectForKey:@"IN_PAGE_SIZE"];
        _IN_END_DATE = [aDecoder decodeObjectForKey:@"IN_END_DATE"];
        _IN_DEPT_ID = [aDecoder decodeObjectForKey:@"IN_DEPT_ID"];
        _IN_AREA_ID = [aDecoder decodeObjectForKey:@"IN_AREA_ID"];
        _IN_EMP_NO = [aDecoder decodeObjectForKey:@"IN_EMP_NO"];
        
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:_IN_STORE_ID forKey:@"IN_STORE_ID"];
    [aCoder encodeObject:_IN_TYPE_ID forKey:@"IN_TYPE_ID"];
    [aCoder encodeObject:_IN_EMP_NO forKey:@"IN_EMP_NO"];
    [aCoder encodeObject:_IN_AREA_ID forKey:@"IN_AREA_ID"];
    [aCoder encodeObject:_IN_DEPT_ID forKey:@"IN_DEPT_ID"];
    [aCoder encodeObject:_IN_END_DATE forKey:@"IN_END_DATE"];
    [aCoder encodeObject:_IN_PAGE_SIZE forKey:@"IN_PAGE_SIZE"];
    [aCoder encodeObject:_IN_DEPT_ID forKey:@"IN_DEPT_ID"];
    [aCoder encodeObject:_IN_START_DATE forKey:@"IN_START_DATE"];
}


@end
