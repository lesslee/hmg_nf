//
//  Prouct+Additions.m
//  hmg
//
//  Created by Hongxianyu on 16/4/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Prouct+Additions.h"
#import "Prouct.h"
@implementation Prouct (Additions)
-(NSString *)formDisplayText
{
    return self.PROD_NM;
}

-(id)formValue
{
    return self.PROD_ID;
}

@end
