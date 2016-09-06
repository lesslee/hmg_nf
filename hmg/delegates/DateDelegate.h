//
//  DateDelegate.h
//  hmg
//
//  Created by Lee on 15/7/17.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DateDelegate

//获取查询日期
-(void) getYEAR:(NSString *) year andSMonth:(NSString *) sMonth andEMonth:(NSString *) eMonth;

@end

