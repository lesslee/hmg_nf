//
//  CustomerLocationViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/5/24.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"
#import <CoreLocation/CoreLocation.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface CustomerLocationViewController : XLFormViewController<ServiceHelperDelgate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BMKLocationServiceDelegate>
{
    MBProgressHUDManager *HUDManager;
}


@property ServiceHelper *serviceHelper;

@end
