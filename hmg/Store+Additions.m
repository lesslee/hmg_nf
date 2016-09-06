//
//  Store+Additions.m
//  hmg
//
//  Created by Lee on 15/4/29.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "Store+Additions.h"

@implementation Store (Additions)

-(NSString *)formDisplayText
{
    return self.STORE_NM;
}

-(id)formValue
{
    return self.STORE_ID;
}
@end
