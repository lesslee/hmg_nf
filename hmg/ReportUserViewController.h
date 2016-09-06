//
//  ReportUserViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/2/29.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
#import "CLLRefreshHeadController.h"
@interface ReportUserViewController : UIViewController <ServiceHelperDelgate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUDManager *HUDManager;
}
@property (nonatomic ,strong) NSString *reportuser;
@property ServiceHelper *serviceHelper;
@end
