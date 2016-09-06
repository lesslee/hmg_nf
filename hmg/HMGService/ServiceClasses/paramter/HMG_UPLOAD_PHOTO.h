//
//  HMG_UPLOAD_PHOTO.h
//  hmg
//
//  Created by Lee on 15/5/27.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_UPLOAD_PHOTO : NSObject
{
    
    NSString *_IN_FILE_SEQ;
    
    NSString *_IN_FILE_NM1;
    
    NSString *_IN_FILE_NM2;
    
    NSString *_IN_FILE_PATH;
    
    NSString *_IN_INP_USER;
    
    NSString *_IN_REPORT_ID;
}

@property (nonatomic,strong)NSString *IN_FILE_SEQ;
@property (nonatomic,strong)NSString *IN_FILE_NM1;
@property (nonatomic,strong)NSString *IN_FILE_NM2;
@property (nonatomic,strong)NSString *IN_FILE_PATH;
@property (nonatomic,strong)NSString *IN_INP_USER;
@property (nonatomic,strong)NSString *IN_REPORT_ID;

@end
