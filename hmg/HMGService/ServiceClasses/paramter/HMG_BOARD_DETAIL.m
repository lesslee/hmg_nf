//
//  HMG_BOARD_DETAIL.m
//  hmg
//
//  Created by Hongxianyu on 16/2/23.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_BOARD_DETAIL.h"

@implementation HMG_BOARD_DETAIL
@synthesize  IN_SEQ = _IN_SEQ;
@synthesize  IN_BOARD_ID = _IN_BOARD_ID;

-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _IN_BOARD_ID = [aDecoder decodeObjectForKey:@"_IN_BOARD_ID"];
        _IN_SEQ = [aDecoder decodeObjectForKey:@"_IN_SEQ"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:_IN_SEQ forKey:@"IN_SEQ"];
    [aCoder encodeObject:_IN_BOARD_ID forKey:@"IN_BOARD_ID"];

}
@end
