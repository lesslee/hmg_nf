//
//  Purpose1+Additions.m
//  hmg
//
//  Created by hongxianyu on 2016/8/19.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Purpose1+Additions.h"

@implementation Purpose1 (Additions)

-(NSString *)formDisplayText
{
    return self.NAME;
}

-(id)formValue
{
    return self.ID;
}

@end
