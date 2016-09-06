//
//  ReportPhotoViewController.h
//  hmg
//
//  Created by Lee on 15/7/30.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"
@interface ReportPhotoViewController : UIViewController<ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
}


@end
