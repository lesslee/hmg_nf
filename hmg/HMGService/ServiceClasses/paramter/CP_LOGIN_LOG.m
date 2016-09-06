//
//  CP_LOGIN_LOG.m
//  hmg
//
//  Created by Hongxianyu on 16/5/26.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "CP_LOGIN_LOG.h"

@implementation CP_LOGIN_LOG
@synthesize IN_SABEON =_IN_SABEON;
@synthesize IN_COMPANY=_IN_COMPANY;
@synthesize IN_IMEI_CODE = _IN_IMEI_CODE;
@synthesize IN_VERSION = _IN_VERSION;
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_SABEON=[aDecoder decodeObjectForKey:@"IN_SABEON"];
        _IN_COMPANY=[aDecoder decodeObjectForKey:@"IN_COMPANY"];
        _IN_IMEI_CODE=[aDecoder decodeObjectForKey:@"IN_IMEI_CODE"];
        _IN_VERSION=[aDecoder decodeObjectForKey:@"IN_VERSION"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_SABEON forKey:@"IN_SABEON"];
    [aCoder encodeObject:_IN_COMPANY forKey:@"IN_COMPANY"];
    [aCoder encodeObject:_IN_IMEI_CODE forKey:@"IN_IMEI_CODE"];
    [aCoder encodeObject:_IN_VERSION forKey:@"IN_VERSION"];
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"CP_LOGIN_LOG<IN_SABEON=%@,IN_COMPANY=%@,IN_IMEI_CODE=%@,IN_VERSION=%@>",_IN_SABEON,_IN_COMPANY,_IN_IMEI_CODE,_IN_VERSION];
}

@end
