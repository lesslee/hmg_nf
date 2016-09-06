//
//  HMG_BOARD_ATTACHMENT.h
//  hmg
//
//  Created by Hongxianyu on 16/2/25.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_BOARD_ATTACHMENT : NSObject
{
    NSString *_IN_BOARD_ID;
    NSString *_IN_SEQ;
    
}

@property (nonatomic , strong) NSString *IN_BOARD_ID;
@property (nonatomic , strong) NSString *IN_SEQ;
@end
