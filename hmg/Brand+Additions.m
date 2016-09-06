//
//  BrandAndPurpose+Additions.m
//  hmg
//
//  Created by Lee on 15/3/31.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "Brand+Additions.h"
#import "Brand.h"
@implementation Brand (Additions)

-(NSString *)formDisplayText
{
    return self.brandNAME;
}

-(id)formValue
{
    return self.brandID;
}


@end
