//
//  HMG_NF_AGENT_QUERY.m
//  hmg
//
//  Created by hongxianyu on 2016/8/31.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_NF_AGENT_QUERY.h"

@implementation HMG_NF_AGENT_QUERY

@synthesize IN_AGENT_ID=_IN_AGENT_ID;
@synthesize IN_AGENT_NM=_IN_AGENT_NM;
@synthesize IN_CURRENT_PAGE=_IN_CURRENT_PAGE;
@synthesize IN_PAGE_SIZE=_IN_PAGE_SIZE;
@synthesize IN_CHARGE_ID=_IN_CHARGE_ID;
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_AGENT_ID=[aDecoder decodeObjectForKey:@"IN_AGENT_ID"];
        _IN_CURRENT_PAGE=[aDecoder decodeObjectForKey:@"IN_CURRENT_PAGE"];
        _IN_CHARGE_ID=[aDecoder decodeObjectForKey:@"IN_CHARGE_ID"];
        _IN_AGENT_NM=[aDecoder decodeObjectForKey:@"IN_AGENT_NM"];
        _IN_PAGE_SIZE=[aDecoder decodeObjectForKey:@"IN_PAGE_SIZE"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_AGENT_ID forKey:@"IN_AGENT_ID"];
    [aCoder encodeObject:_IN_CURRENT_PAGE forKey:@"IN_CURRENT_PAGE"];
    [aCoder encodeObject:_IN_CHARGE_ID forKey:@"IN_CHARGE_ID"];
    [aCoder encodeObject:_IN_AGENT_NM forKey:@"IN_AGENT_NM"];
    [aCoder encodeObject:_IN_PAGE_SIZE forKey:@"IN_PAGE_SIZE"];
}

@end
