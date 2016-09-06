//
//  BrandAndPurpose.m
//  hmg
//
//  Created by Lee on 15/3/30.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "Brand.h"

@implementation Brand
@synthesize brandID=_brandID;
@synthesize brandNAME=_brandNAME;

-(id) initWithID:(NSString *)brandID andNAME:(NSString *)brandNAME
{
    if (self = [super init]) {
        self.brandID=brandID;
        self.brandNAME=brandNAME;
    }
    
    return self;
}



@end
