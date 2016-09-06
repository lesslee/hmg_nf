//
//  HMG_CHECK_IN.m
//  hmg
//
//  Created by Lee on 15/5/12.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "HMG_CHECK_IN.h"

@implementation HMG_CHECK_IN
@synthesize IN_EMP_NO=_IN_EMP_NO;
@synthesize IN_GPS_LAT=_IN_GPS_LAT;
@synthesize IN_GPS_LON=_IN_GPS_LON;
@synthesize IN_AGENT_ID=_IN_AGENT_ID;
@synthesize IN_STORE_ID=_IN_STORE_ID;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_EMP_NO=[aDecoder decodeObjectForKey:@"IN_EMP_NO"];
        _IN_GPS_LAT=[aDecoder decodeObjectForKey:@"IN_GPS_LAT"];
        _IN_GPS_LON=[aDecoder decodeObjectForKey:@"IN_GPS_LON"];
        _IN_AGENT_ID=[aDecoder decodeObjectForKey:@"IN_AGENT_ID"];
        _IN_STORE_ID=[aDecoder decodeObjectForKey:@"IN_STORE_ID"];

    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_EMP_NO forKey:@"IN_EMP_NO"];
    [aCoder encodeObject:_IN_GPS_LAT forKey:@"IN_GPS_LAT"];
    [aCoder encodeObject:_IN_GPS_LON forKey:@"IN_GPS_LON"];
    [aCoder encodeObject:_IN_AGENT_ID forKey:@"IN_AGENT_ID"];
    [aCoder encodeObject:_IN_STORE_ID forKey:@"IN_STORE_ID"];
}


@end
