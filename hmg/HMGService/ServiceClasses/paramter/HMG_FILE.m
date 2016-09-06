//
//  HMG_FILE.m
//  hmg
//
//  Created by Hongxianyu on 16/4/15.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_FILE.h"

@implementation HMG_FILE
@synthesize IN_FILE_ID = _IN_FILE_ID;


-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _IN_FILE_ID = [aDecoder decodeObjectForKey:@"IN_FILE_ID"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_IN_FILE_ID forKey:@"IN_FILE_ID"];
    
}

@end
