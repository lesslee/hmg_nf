//
//  HMG_BOARD.h
//  hmg
//
//  Created by Hongxianyu on 16/2/22.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_BOARD : NSObject
{
    
    //当前页索引
    NSString *_IN_CURRENT_PAGE;
    //每页条数
    NSString *_IN_PAGE_SIZE;
}
@property (nonatomic,strong)NSString *IN_CURRENT_PAGE;
@property (nonatomic,strong)NSString *IN_PAGE_SIZE;
@end
