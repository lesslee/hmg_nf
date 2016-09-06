//
//  StoreInfoViewController.h
//  hmg
//
//  Created by Lee on 15/6/15.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import "XLFormViewController.h"
#import "ServiceHelper.h"
#import "CLLRefreshHeadController.h"
#import "MBProgressHUDManager.h"

@interface StoreInfoViewController : XLFormViewController<UITableViewDataSource,UITableViewDelegate,ServiceHelperDelgate,CLLRefreshHeadControllerDelegate>
{
    MBProgressHUDManager *HUDManager;
}


@property ServiceHelper *serviceHelper;

@end
