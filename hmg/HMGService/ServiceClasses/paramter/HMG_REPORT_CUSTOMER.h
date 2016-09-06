//
//  HMG_REPORT_CUSTOMER.h
//  hmg
//
//  Created by Hongxianyu on 16/3/2.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_REPORT_CUSTOMER : NSObject
{
    NSString *_IN_CUSTOMER_ID;
    NSString *_IN_TYPE;
}
@property (nonatomic,strong)NSString *IN_CUSTOMER_ID;
@property (nonatomic,strong)NSString *IN_TYPE;

@end
