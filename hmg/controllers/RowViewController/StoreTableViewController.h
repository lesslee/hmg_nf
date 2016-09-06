//
//  StoreTableViewController.h
//  hmg
//
//  Created by Lee on 15/3/27.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "XLFormRowDescriptor.h"
#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "CLLRefreshHeadController.h"
#import "MBProgressHUDManager.h"

@interface StoreTableViewController : UIViewController<XLFormRowDescriptorViewController,UITableViewDataSource,UITableViewDelegate,ServiceHelperDelgate,CLLRefreshHeadControllerDelegate>

{
    MBProgressHUDManager *HUDManager;
}
@property ServiceHelper *serviceHelper;

@end
