//
//  HMG_CHECK_IN_LAST.m
//  hmg
//
//  Created by Hongxianyu on 16/5/25.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_CHECK_IN_LAST.h"

@implementation HMG_CHECK_IN_LAST
@synthesize IN_EMP_NO=_IN_EMP_NO;
@synthesize IN_GPS_LAT=_IN_GPS_LAT;
@synthesize IN_GPS_LON=_IN_GPS_LON;
@synthesize IN_AGENT_ID=_IN_AGENT_ID;
@synthesize IN_STORE_ID=_IN_STORE_ID;
@synthesize IN_ADDRESS=_IN_ADDRESS;
@synthesize IN_BENCHMARK_LAT=_IN_BENCHMARK_LAT;
@synthesize IN_BENCHMARK_LON=_IN_BENCHMARK_LON;
@synthesize IN_DISTANCE=_IN_DISTANCE;
@synthesize IN_ERROR_CODE=_IN_ERROR_CODE;
@synthesize IN_DISTANCE_DESCRIPTION=_IN_DISTANCE_DESCRIPTION;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_EMP_NO=[aDecoder decodeObjectForKey:@"IN_EMP_NO"];
        _IN_GPS_LAT=[aDecoder decodeObjectForKey:@"IN_GPS_LAT"];
        _IN_GPS_LON=[aDecoder decodeObjectForKey:@"IN_GPS_LON"];
        _IN_AGENT_ID=[aDecoder decodeObjectForKey:@"IN_AGENT_ID"];
        _IN_STORE_ID=[aDecoder decodeObjectForKey:@"IN_STORE_ID"];
        _IN_ADDRESS = [aDecoder decodeObjectForKey:@"IN_ADDRESS"];
        _IN_BENCHMARK_LAT = [aDecoder decodeObjectForKey:@"IN_BENCHMARK_LAT"];
        _IN_BENCHMARK_LON = [aDecoder decodeObjectForKey:@"IN_BENCHMARK_LON"];
        _IN_ERROR_CODE = [aDecoder decodeObjectForKey:@"IN_ERROR_CODE"];
        _IN_DISTANCE = [aDecoder decodeObjectForKey:@"IN_DISTANCE"];
        _IN_DISTANCE_DESCRIPTION = [aDecoder decodeObjectForKey:@"IN_DISTANCE_DESCRIPTION"];
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
    [aCoder encodeObject:_IN_ADDRESS forKey:@"IN_ADDRESS"];
    [aCoder encodeObject:_IN_BENCHMARK_LAT forKey:@"IN_BENCHMARK_LAT"];
    [aCoder encodeObject:_IN_BENCHMARK_LON forKey:@"IN_BENCHMARK_LON"];
    [aCoder encodeObject:_IN_ERROR_CODE forKey:@"IN_ERROR_CODE"];
    [aCoder encodeObject:_IN_DISTANCE forKey:@"IN_DISTANCE"];
    [aCoder encodeObject:_IN_DISTANCE_DESCRIPTION forKey:@"IN_DISTANCE_DESCRIPTION"];
    
    
}


@end
