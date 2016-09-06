//
//  prouctSection.m
//  hmg
//
//  Created by Hongxianyu on 16/5/4.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "prouctSection.h"
#import "Prouct.h"
@implementation prouctSection

- (id)initWithID:(NSString *) ID andNAME:(NSString *) NAME{
    if (self = [super initWithID:ID andNAME:NAME]) {
        _prouctArray = [[NSMutableArray alloc]init];
    }
    return self;
}
//- (NSInteger) sumAllProductCount
//{
//    NSInteger sum = 0;
//    for (id obj in _prouctArray) {
//        if ([obj isKindOfClass:[Prouct class]]) {
//            Prouct *product = (Prouct *)obj;
//            sum += product.count1.integerValue;
//        }
//    }
//    NSLog(@"%ld0000",(long)sum);
//    return sum;
//}

@end
