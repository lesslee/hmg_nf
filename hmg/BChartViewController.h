//
//  BChartViewController.h
//  hmg
//
//  Created by Lee on 15/6/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
@interface BChartViewController : UIViewController<ServiceHelperDelgate>

{
    MBProgressHUDManager *HUDManager;
}

@property ServiceHelper *serviceHelper;


@end
