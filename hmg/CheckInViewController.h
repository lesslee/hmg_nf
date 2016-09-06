//
//  CheckInViewController.h
//  hmg
//
//  Created by Lee on 15/5/12.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface CheckInViewController : XLFormViewController<ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
}

@property (nonatomic, retain) NSString * LON;//精度
@property (nonatomic, retain) NSString * LAT;//纬度
@property ServiceHelper *serviceHelper;

@end
