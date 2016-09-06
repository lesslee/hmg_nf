//
//  prouctSection.h
//  hmg
//
//  Created by Hongxianyu on 16/5/4.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Brand1.h"

@interface prouctSection : Brand1

@property(nonatomic, strong)NSMutableArray *prouctArray;
/**
 *  统计prouctArray里面所有产品的 数量总和
 *
 *  @return 返回产品的总数量
 */
@property(nonatomic,strong) NSString *count;

@end

