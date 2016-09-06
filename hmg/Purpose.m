//
//  Purpose.m
//  hmg
//
//  Created by Lee on 15/5/5.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "Purpose.h"

@implementation Purpose
@synthesize ID=_ID;
@synthesize NAME=_NAME;

-(id) initWithID:(NSString *)ID andNAME:(NSString *)NAME
{
    if (self = [super init]) {
        self.ID=ID;
        self.NAME=NAME;
    }
    
    return self;
}

@end
