//
//  Date+Additions.m
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Date+Additions.h"
#import "Date.h"
@implementation Date (Additions)
-(NSString *)formDisplayText
{
    return self.NAME;
}

-(id)formValue
{
    return self.ID;
}


@end

