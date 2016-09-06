//
//  QueryReportViewController.h
//  hmg
//
//  Created by Lee on 15/3/26.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//


#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
#import "CLLRefreshHeadController.h"
#import <UIKit/UIKit.h>
#import "ReportCell.h"
@class QueryReportViewController;

@protocol PassValueDelegate
-(void)passTrendValues:(NSString *)values;
@end

@interface QueryReportViewController : UIViewController<ServiceHelperDelgate,NSCoding,UITableViewDataSource,UITableViewDelegate,CLLRefreshHeadControllerDelegate>
{
       MBProgressHUDManager *HUDManager;
}
@property (nonatomic, strong)NSString *stringInt;
@property (nonatomic, strong) id <PassValueDelegate> trendDelegate;
@property ServiceHelper *serviceHelper;
@end
