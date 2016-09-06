//
//  Brand1+Additions.m
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Brand1+Additions.h"
#import "Brand1.h"
@implementation Brand1 (Additions)

-(NSString *)formDisplayText
{
    return self.NAME;
}

-(id)formValue
{
    return self.ID;
}


@end

