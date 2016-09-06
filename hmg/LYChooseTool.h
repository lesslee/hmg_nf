//
//  LYChooseTool.h
//  test
//
//  Created by sky on 16/5/3.
//  Copyright © 2016年 vincee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "singleton.h"

@interface LYChooseTool : NSObject

/** 数组用来保存用户选择的内容, 只读*/
@property (nonatomic,strong,readonly) NSMutableArray *dataArray;

/**
 *  向数组中添加一个数据对象
 *
 *  @param obj 要添加的对象
 */
- (void) ly_addObject:(id) obj;

/** 实现单例 */
singleton_interface(LYChooseTool)

@end
