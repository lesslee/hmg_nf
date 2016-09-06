//
//  HMG_NF_AGENT_QUERY.h
//  hmg
//
//  Created by hongxianyu on 2016/8/31.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_NF_AGENT_QUERY : NSObject
{
    
    NSString *_IN_AGENT_ID;
    
    NSString *_IN_AGENT_NM;
    
    NSString *_IN_CHARGE_ID;
        //当前页索引
    NSString *_IN_CURRENT_PAGE;
        //每页条数
    NSString *_IN_PAGE_SIZE;
}

@property (nonatomic,strong)NSString *IN_AGENT_ID;
@property (nonatomic,strong)NSString *IN_AGENT_NM;
@property (nonatomic,strong)NSString *IN_CHARGE_ID;
@property (nonatomic,strong)NSString *IN_CURRENT_PAGE;
@property (nonatomic,strong)NSString *IN_PAGE_SIZE;
@end
