//
//  HMG_UPLOAD_PHOTO.m
//  hmg
//
//  Created by Lee on 15/5/27.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "HMG_UPLOAD_PHOTO.h"

@implementation HMG_UPLOAD_PHOTO
@synthesize IN_FILE_SEQ=_IN_FILE_SEQ;
@synthesize IN_FILE_NM1=_IN_FILE_NM1;
@synthesize IN_FILE_NM2=_IN_FILE_NM2;
@synthesize IN_FILE_PATH=_IN_FILE_PATH;
@synthesize IN_INP_USER=_IN_INP_USER;
@synthesize IN_REPORT_ID=_IN_REPORT_ID;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_FILE_SEQ=[aDecoder decodeObjectForKey:@"IN_FILE_SEQ"];
        _IN_FILE_NM1=[aDecoder decodeObjectForKey:@"IN_FILE_NM1"];
        _IN_FILE_NM2=[aDecoder decodeObjectForKey:@"IN_FILE_NM2"];
        _IN_FILE_PATH=[aDecoder decodeObjectForKey:@"IN_FILE_PATH"];
        _IN_INP_USER=[aDecoder decodeObjectForKey:@"IN_INP_USER"];
        _IN_REPORT_ID=[aDecoder decodeObjectForKey:@"IN_REPORT_ID"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_FILE_SEQ forKey:@"IN_FILE_SEQ"];
    [aCoder encodeObject:_IN_FILE_NM1 forKey:@"IN_FILE_NM1"];
    [aCoder encodeObject:_IN_FILE_NM2 forKey:@"IN_FILE_NM2"];
    [aCoder encodeObject:_IN_FILE_PATH forKey:@"IN_FILE_PATH"];
    [aCoder encodeObject:_IN_INP_USER forKey:@"IN_INP_USER"];
    [aCoder encodeObject:_IN_REPORT_ID forKey:@"IN_REPORT_ID"];
}


@end
