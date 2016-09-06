//
//  StoreFlowViewController.h
//  hmg
//
//  Created by Lee on 15/6/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import "XLFormViewController.h"
#import "ServiceHelper.h"
#import "CLLRefreshHeadController.h"
#import "MBProgressHUDManager.h"
@interface StoreFlowViewController : XLFormViewController<UITableViewDataSource,UITableViewDelegate,ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
}


@property ServiceHelper *serviceHelper;
@end
