//
//  ConsumerViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/4/19.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
#import "CLLRefreshHeadController.h"

@interface ConsumerViewController : UIViewController<ServiceHelperDelgate,UITableViewDataSource,UITableViewDelegate,CLLRefreshHeadControllerDelegate>
{
    MBProgressHUDManager *HUDManager;
}
@property ServiceHelper *serviceHelper;
@property(nonatomic, retain) NSString *consumerId;

@end
