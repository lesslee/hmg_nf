//
//  HMG_REPORT_USER.m
//  hmg
//
//  Created by Hongxianyu on 16/2/29.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_REPORT_USER.h"

@implementation HMG_REPORT_USER
@synthesize IN_USER_ID=_IN_USER_ID;


-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_USER_ID=[aDecoder decodeObjectForKey:@"_IN_USER_ID"];
        
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_USER_ID forKey:@"_IN_USER_ID"];
}
@end
