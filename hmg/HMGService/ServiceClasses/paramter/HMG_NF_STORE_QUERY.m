//
//  HMG_NF_STORE_QUERY.m
//  hmg
//
//  Created by hongxianyu on 2016/8/31.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_NF_STORE_QUERY.h"

@implementation HMG_NF_STORE_QUERY

@synthesize IN_STORE_ID=_IN_STORE_ID;
@synthesize IN_STORE_NM=_IN_STORE_NM;
@synthesize IN_CURRENT_PAGE=_IN_CURRENT_PAGE;
@synthesize IN_PAGE_SIZE=_IN_PAGE_SIZE;
@synthesize IN_STORE_MANAGER=_IN_STORE_MANAGER;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_STORE_ID=[aDecoder decodeObjectForKey:@"IN_STORE_ID"];
        _IN_CURRENT_PAGE=[aDecoder decodeObjectForKey:@"IN_CURRENT_PAGE"];
        _IN_STORE_NM=[aDecoder decodeObjectForKey:@"IN_STORE_NM"];
        _IN_PAGE_SIZE=[aDecoder decodeObjectForKey:@"IN_PAGE_SIZE"];
        _IN_STORE_MANAGER=[aDecoder decodeObjectForKey:@"IN_STORE_MANAGER"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_STORE_ID forKey:@"IN_STORE_ID"];
    [aCoder encodeObject:_IN_CURRENT_PAGE forKey:@"IN_CURRENT_PAGE"];
    [aCoder encodeObject:_IN_STORE_NM forKey:@"IN_STORE_NM"];
    [aCoder encodeObject:_IN_PAGE_SIZE forKey:@"IN_PAGE_SIZE"];
    [aCoder encodeObject:_IN_STORE_MANAGER forKey:@"IN_STORE_MANAGER"];
}
@end

