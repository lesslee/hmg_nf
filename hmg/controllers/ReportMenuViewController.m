//
//  ReportMenuViewController.m
//  hmg
//
//  Created by Lee on 15/6/15.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "XLForm.h"
#import "ReportMenuViewController.h"
#import "StoreInfoViewController.h"
#import "StoreVisitationViewController.h"
#import "StoreFlowViewController.h"
#import "StoreLayoutViewController.h"
#import "BChartViewController.h"
#import "UChartViewController.h"
#import "PChartViewController.h"

//#import "ChartTestViewController.h"
@interface ReportMenuViewController ()

@end

NSString * const khmg1= @"khmg1";
NSString * const khmg2 = @"khmg2";
NSString * const khmg3 = @"khmg3";
NSString * const khmg4 = @"khmg4";
NSString * const khmg5 = @"khmg5";
NSString * const khmg6 = @"khmg6";
NSString * const khmg7 = @"khmg7";

@implementation ReportMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationItem setTitle:@"数据查询"];
      //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
   // self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
  
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

#pragma mark - Helper

-(void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"汇总信息"];
    //section.footerTitle = @"ExamplesFormViewController.h, Select an option to view another example";
    [form addFormSection:section];
    
    
    // TextFieldAndTextView
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khmg1 rowType:XLFormRowDescriptorTypeButton title:@"门店信息汇总"];
    row.buttonViewController = [StoreInfoViewController class];
    [section addFormRow:row];
    
    // Selectors
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khmg2 rowType:XLFormRowDescriptorTypeButton title:@"门店拜访汇总"];
    row.buttonViewController = [StoreVisitationViewController class];
    [section addFormRow:row];
    
    // Dates
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khmg3 rowType:XLFormRowDescriptorTypeButton title:@"门店流向汇总"];
    row.buttonViewController = [StoreFlowViewController class];
    [section addFormRow:row];
    
    // Others
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khmg4 rowType:XLFormRowDescriptorTypeButton title:@"地区别门店分布"];
    row.buttonViewController = [StoreLayoutViewController class];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"流向曲线图"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khmg5 rowType:XLFormRowDescriptorTypeButton title:@"地区别流向曲线图"];
    row.buttonViewController = [BChartViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khmg6 rowType:XLFormRowDescriptorTypeButton title:@"人员别流向曲线图"];
    row.buttonViewController = [UChartViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khmg7 rowType:XLFormRowDescriptorTypeButton title:@"品别流向曲线图"];
    row.buttonViewController = [PChartViewController class];
    [section addFormRow:row];
    
    self.form = form;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
