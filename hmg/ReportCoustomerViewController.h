//
//  ReportCoustomerViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/3/2.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
//#import "CLLRefreshHeadController.h"
@interface ReportCoustomerViewController : UIViewController<UITableViewDelegate,ServiceHelperDelgate,UITableViewDataSource>
{
MBProgressHUDManager *HUDManager;
}
@property ServiceHelper *serviceHelper;
@property (nonatomic,strong)NSString *reportcustomer;
@property (nonatomic,strong)NSString *type1;
@end
