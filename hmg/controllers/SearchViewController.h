//
//  SearchViewController.h
//  hmg
//
//  Created by Lee on 15/4/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "XLForm.h"
#import "XLFormViewController.h"
#import "ReportDetailDelegate.h"

@interface SearchViewController : XLFormViewController

@property NSObject<ReportDetailDelegate> *delegate;

@end
