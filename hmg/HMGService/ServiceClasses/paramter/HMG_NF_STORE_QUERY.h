//
//  HMG_NF_STORE_QUERY.h
//  hmg
//
//  Created by hongxianyu on 2016/8/31.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_NF_STORE_QUERY : NSObject

{
    
    NSString *_IN_STORE_ID;
    
    NSString *_IN_STORE_NM;
    
    NSString *_IN_STORE_MANAGER;
        //当前页索引
    NSString *_IN_CURRENT_PAGE;
        //每页条数
    NSString *_IN_PAGE_SIZE;
    
}

@property (nonatomic,strong)NSString *IN_STORE_ID;
@property (nonatomic,strong)NSString *IN_STORE_NM;
@property (nonatomic,strong)NSString *IN_STORE_MANAGER;
@property (nonatomic,strong)NSString *IN_CURRENT_PAGE;
@property (nonatomic,strong)NSString *IN_PAGE_SIZE;
@end

