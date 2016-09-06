//
//  Brand1.m
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Brand1.h"

@implementation Brand1
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
