//
//  HMG_CUSTOMER_LOCATION.m
//  hmg
//
//  Created by Hongxianyu on 16/5/24.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_CUSTOMER_LOCATION.h"

@implementation HMG_CUSTOMER_LOCATION
@synthesize IN_CUSTOMER_ID = _IN_CUSTOMER_ID;
@synthesize IN_CUSTOMER_TYPE = _IN_CUSTOMER_TYPE;
@synthesize IN_GPS_LON = _IN_GPS_LON;
@synthesize IN_GPS_LAT = _IN_GPS_LAT;
@synthesize IN_FILE_NM1 = _IN_FILE_NM1;
@synthesize IN_FILE_NM2 = _IN_FILE_NM2;
@synthesize IN_SABEON = _IN_SABEON;

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _IN_CUSTOMER_ID = [aDecoder decodeObjectForKey:@"IN_CUSTOMER_ID"];
        _IN_CUSTOMER_TYPE = [aDecoder decodeObjectForKey:@"IN_CUSTOMER_TYPE"];
        _IN_GPS_LON = [aDecoder decodeObjectForKey:@"IN_GPS_LON"];
        _IN_GPS_LAT = [aDecoder decodeObjectForKey:@"IN_GPS_LAT"];
        _IN_FILE_NM1 = [aDecoder decodeObjectForKey:@"IN_FILE_NM1"];
        _IN_FILE_NM2 = [aDecoder decodeObjectForKey:@"IN_FILE_NM2"];
        _IN_SABEON = [aDecoder decodeObjectForKey:@"IN_SABEON"];
        
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_IN_CUSTOMER_ID forKey:@"IN_CUSTOMER_ID"];
    [aCoder encodeObject:_IN_CUSTOMER_TYPE forKey:@"IN_CUSTOMER_TYPE"];
    [aCoder encodeObject:_IN_GPS_LON forKey:@"IN_GPS_LON"];
    [aCoder encodeObject:_IN_GPS_LAT forKey:@"IN_GPS_LAT"];
    [aCoder encodeObject:_IN_FILE_NM1 forKey:@"IN_FILE_NM1"];
    [aCoder encodeObject:_IN_FILE_NM2 forKey:@"IN_FILE_NM2"];
    [aCoder encodeObject:_IN_SABEON forKey:@"IN_SABEON"];
}


@end
