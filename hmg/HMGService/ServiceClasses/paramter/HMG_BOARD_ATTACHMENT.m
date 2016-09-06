//
//  HMG_BOARD_ATTACHMENT.m
//  hmg
//
//  Created by Hongxianyu on 16/2/25.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_BOARD_ATTACHMENT.h"

@implementation HMG_BOARD_ATTACHMENT
@synthesize  IN_SEQ = _IN_SEQ;
@synthesize  IN_BOARD_ID = _IN_BOARD_ID;

-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _IN_BOARD_ID = [aDecoder decodeObjectForKey:@"_IN_BOARD_ID"];
        _IN_SEQ = [aDecoder decodeObjectForKey:@"_IN_SEQ"];
    }
    return self;
}

@end
