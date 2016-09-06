//
//  AppDelegate.h
//  hmg
//
//  Created by Lee on 15/3/23.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

  BMKMapManager * _mapManager;

}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;

//全局变量 登入的返回结果
@property UserInfo *userInfo;

@end

