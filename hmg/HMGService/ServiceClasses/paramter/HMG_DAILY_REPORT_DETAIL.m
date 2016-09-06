//
//  HMG_DAILY_REPORT_DETAIL.m
//  hmg
//
//  Created by Lee on 15/4/14.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "HMG_DAILY_REPORT_DETAIL.h"

@implementation HMG_DAILY_REPORT_DETAIL
@synthesize IN_REPORT_ID=_IN_REPORT_ID;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_REPORT_ID=[aDecoder decodeObjectForKey:@"IN_REPORT_ID"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_REPORT_ID forKey:@"IN_REPORT_ID"];
}

@end
