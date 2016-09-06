//
//  HMG_REPORT_CUSTOMER.m
//  hmg
//
//  Created by Hongxianyu on 16/3/2.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_REPORT_CUSTOMER.h"

@implementation HMG_REPORT_CUSTOMER
@synthesize IN_CUSTOMER_ID=_IN_CUSTOMER_ID;

@synthesize IN_TYPE = _IN_TYPE;
-(id) initWithCoder:(NSCoder *)aDecoder
{
if (self=[super init]) {
_IN_TYPE=[aDecoder decodeObjectForKey:@"_IN_TYPE"];

_IN_CUSTOMER_ID = [aDecoder decodeObjectForKey:@"_IN_CUSTOMER_ID"];
}
return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_TYPE forKey:@"_IN_TYPE"];
    [aCoder encodeObject:_IN_CUSTOMER_ID forKey:_IN_CUSTOMER_ID];
}
@end
