//
//  NotifyViewController.h
//  hmg
//
//  Created by Lee on 15/6/10.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
#import "CLLRefreshHeadController.h"
@interface NotifyViewController : UIViewController<ServiceHelperDelgate,UITableViewDataSource,UITableViewDelegate,CLLRefreshHeadControllerDelegate>
{
    MBProgressHUDManager *HUDManager;
}
@property ServiceHelper *serviceHelper;


@end
