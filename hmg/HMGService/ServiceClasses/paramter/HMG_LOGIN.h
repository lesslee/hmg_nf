//
//  HMG_LOGIN.h
//  hmg
//
//  Created by Lee on 15/3/25.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_LOGIN : NSObject
{
    //username
    NSString *_IN_LOGIN_ID;
    //password
    NSString *_IN_LOGIN_PW;
}

@property (nonatomic,strong)NSString *IN_LOGIN_ID;
@property (nonatomic,strong)NSString *IN_LOGIN_PW;

@end
