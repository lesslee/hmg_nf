    //
    //  UploadViewController.h
    //  hmg
    //
    //  Created by Lee on 15/5/19.
    //  Copyright (c) 2015年 com.lz. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"
    //#import "SDPhotoBrowser.h"
@protocol PassTrendValueDelegate12

-(void)passTrendValues:(UIImage *)values;//1.1定义协议与方法

@end
@interface UploadViewController : UIViewController<ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
}

    ///1.定义向趋势页面传值的委托变量
@property (retain,nonatomic) id <PassTrendValueDelegate12> trendDelegate;
@property(nonatomic,strong)NSString *reportId;//照片关联的日报id
@property ServiceHelper *serviceHelper;
@end
