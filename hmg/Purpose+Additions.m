//
//  Purpose+Additions.m
//  hmg
//
//  Created by Lee on 15/5/5.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "Purpose+Additions.h"

@implementation Purpose (Additions)

-(NSString *)formDisplayText
{
    return self.NAME;
}

-(id)formValue
{
    return self.ID;
}

@end
