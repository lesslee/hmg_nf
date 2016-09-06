//
//  HMG_BOARD.m
//  hmg
//
//  Created by Hongxianyu on 16/2/22.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_BOARD.h"

@implementation HMG_BOARD

@synthesize IN_CURRENT_PAGE=_IN_CURRENT_PAGE;
@synthesize IN_PAGE_SIZE=_IN_PAGE_SIZE;


-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        _IN_CURRENT_PAGE=[aDecoder decodeObjectForKey:@"IN_CURRENT_PAGE"];
       
        _IN_PAGE_SIZE=[aDecoder decodeObjectForKey:@"IN_PAGE_SIZE"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
   
    [aCoder encodeObject:_IN_CURRENT_PAGE forKey:@"IN_CURRENT_PAGE"];
   
    [aCoder encodeObject:_IN_PAGE_SIZE forKey:@"IN_PAGE_SIZE"];
}

@end
