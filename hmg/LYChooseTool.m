//
//  LYChooseTool.m
//  test
//
//  Created by sky on 16/5/3.
//  Copyright © 2016年 vincee. All rights reserved.
//

#import "LYChooseTool.h"

@interface LYChooseTool ()

/** 私有变量，保存用户选择的数据*/
@property (nonatomic,strong) NSMutableArray *array;

@end



@implementation LYChooseTool

/** 懒加载 */
- (NSMutableArray *)array
{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }    
    return _array;
}

- (NSMutableArray *)dataArray
{
    return self.array;
}

- (void) ly_addObject:(id)obj
{
    [self.array addObject:obj];
}

singleton_implementation(LYChooseTool)

@end
