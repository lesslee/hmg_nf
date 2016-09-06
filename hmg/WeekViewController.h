//
//  WeekViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"
#import "Brand1.h"

@protocol PassTrendValueDelegate

-(void)passPosMoneyValues:(NSString *)values;//1.1定义协议与方法

@end


@interface WeekViewController :XLFormViewController <ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
    
}
@property ServiceHelper *serviceHelper;

//1.定义向趋势页面传值的委托变量
@property (nonatomic, strong) id <PassTrendValueDelegate> trendDelegate;

@property XLFormDescriptor * formDescriptor;
@property XLFormSectionDescriptor * section;
@property XLFormRowDescriptor * row;
@property(nonatomic, strong)Brand1 *brand;


@end
