//
//  Date.m
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Date.h"

@implementation Date

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
