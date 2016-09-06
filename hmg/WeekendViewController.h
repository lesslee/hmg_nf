//
//  WeekendViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/4/14.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
#import "CLLRefreshHeadController.h"
#import <UIKit/UIKit.h>
#import "WeekendViewCell.h"
@class WeekendViewController;
@interface WeekendViewController : UIViewController<ServiceHelperDelgate,NSCoding,UITableViewDataSource,UITableViewDelegate,  CLLRefreshHeadControllerDelegate>
{
    MBProgressHUDManager *HUDManager;
}
@property ServiceHelper *serviceHelper;
@end
