//
//  HMG_DAILY_REPORT_PHOTO.m
//  hmg
//
//  Created by Lee on 15/4/15.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "HMG_DAILY_REPORT_PHOTO.h"

@implementation HMG_DAILY_REPORT_PHOTO
@synthesize IN_PHOTO_ID=_IN_PHOTO_ID;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_PHOTO_ID=[aDecoder decodeObjectForKey:@"IN_PHOTO_ID"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_PHOTO_ID forKey:@"IN_PHOTO_ID"];
}

@end
