//
//  HMG_TYPE_PRODUCT.m
//  hmg
//
//  Created by Hongxianyu on 16/4/13.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "HMG_TYPE_PRODUCT.h"

@implementation HMG_TYPE_PRODUCT
@synthesize IN_TYPE_ID = _IN_TYPE_ID;

-(id) initWithCoder:(NSCoder *)aDecoder{

    if (self = [super init]) {
        _IN_TYPE_ID = [aDecoder decodeObjectForKey:@"IN_TYPE_ID"];
    }
    return self;
}

-(void)encodeWithCode:(NSCoder *)aCoder{

    [aCoder encodeObject:_IN_TYPE_ID forKey:@"IN_TYPE_ID"];

}
@end
