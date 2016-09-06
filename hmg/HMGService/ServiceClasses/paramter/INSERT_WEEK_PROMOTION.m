//
//  INSERT_WEEK_PROMOTION.m
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "INSERT_WEEK_PROMOTION.h"

@implementation INSERT_WEEK_PROMOTION

@synthesize IN_STORE_ID =_IN_STORE_ID;
@synthesize IN_PROD_ID =_IN_PROD_ID;
@synthesize IN_QTY = _IN_QTY;
@synthesize IN_PROM_DTM = _IN_PROM_DTM;
@synthesize IN_INP_USER = _IN_INP_USER;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_STORE_ID=[aDecoder decodeObjectForKey:@"IN_STORE_ID"];
        _IN_PROD_ID=[aDecoder decodeObjectForKey:@"IN_PROD_ID"];
        _IN_QTY=[aDecoder decodeObjectForKey:@"IN_QTY"];
        _IN_PROM_DTM=[aDecoder decodeObjectForKey:@"IN_PROM_DTM"];
        _IN_INP_USER=[aDecoder decodeObjectForKey:@"IN_INP_USER"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_STORE_ID forKey:@"IN_STORE_ID"];
    [aCoder encodeObject:_IN_PROD_ID forKey:@"IN_PROD_ID"];
    [aCoder encodeObject:_IN_QTY forKey:@"IN_QTY"];
    [aCoder encodeObject:_IN_PROM_DTM forKey:@"IN_PROM_DTM"];
    [aCoder encodeObject:_IN_INP_USER forKey:@"IN_INP_USER"];
}
@end
