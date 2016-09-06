//
//  HMG_STORE_FLOW_BRAND.m
//  hmg
//
//  Created by Hongxianyu on 16/3/10.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_STORE_FLOW_BRAND.h"

@implementation HMG_STORE_FLOW_BRAND

@synthesize IN_AREA_ID=_IN_AREA_ID;
@synthesize IN_DEPT_CD=_IN_DEPT_CD;
@synthesize IN_YEAR=_IN_YEAR;
@synthesize IN_S_MONTH=_IN_S_MONTH;
@synthesize IN_E_MONTH=_IN_E_MONTH;


-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_AREA_ID=[aDecoder decodeObjectForKey:@"IN_AREA_ID"];
        _IN_DEPT_CD=[aDecoder decodeObjectForKey:@"IN_DEPT_CD"];
        _IN_YEAR=[aDecoder decodeObjectForKey:@"IN_YEAR"];
        _IN_S_MONTH=[aDecoder decodeObjectForKey:@"IN_S_MONTH"];
        _IN_E_MONTH=[aDecoder decodeObjectForKey:@"IN_E_MONTH"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_AREA_ID forKey:@"IN_AREA_ID"];
    [aCoder encodeObject:_IN_DEPT_CD forKey:@"IN_DEPT_CD"];
    [aCoder encodeObject:_IN_YEAR forKey:@"IN_YEAR"];
    [aCoder encodeObject:_IN_S_MONTH forKey:@"IN_S_MONTH"];
    [aCoder encodeObject:_IN_E_MONTH forKey:@"IN_E_MONTH"];
}
@end
