//
//  storeMonthViewController.h
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
#import "CLLRefreshHeadController.h"
#import <UIKit/UIKit.h>
#import "MonthReportCell.h"

@protocol PassMonthTrendValueDelegate

-(void)passTrendValues:(NSString *)storeName AndBrandName:(NSString *)brandName AndInvertoy:(NSString *)invertory AndSealQty:(NSString *)sealQty AndStoreID:(NSString *)StoreID AndBrandID:(NSString *)BrandID;//1.1定义协议与方法

@end


@interface storeMonthViewController : UIViewController<ServiceHelperDelgate,UITableViewDataSource,UITableViewDelegate,CLLRefreshHeadControllerDelegate>
{
    MBProgressHUDManager *HUDManager;
}
@property (retain,nonatomic) id <PassMonthTrendValueDelegate> trendMonthDelegate;
@property ServiceHelper *serviceHelper;
@end