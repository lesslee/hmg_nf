//
//  SearchViewController.m
//  hmg
//
//  Created by Lee on 15/4/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()



@end

//
NSString *const kStartDate = @"startDate";
//
NSString *const kEndDate = @"endDate";

NSString *const kSearch = @"search";

@implementation SearchViewController
@synthesize delegate=_delegate;
XLFormDescriptor * formDescriptor;
XLFormSectionDescriptor * section;
XLFormRowDescriptor * row;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    
    return self;
}

-(id) init
{
    self = [super init];
    if (self) {
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

-(void)initializeForm
{
    
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"日报录入"];
    
    //formDescriptor.assignFirstResponderOnShow = YES;
    
    section=[XLFormSectionDescriptor formSection];
    
    [formDescriptor addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kStartDate rowType:XLFormRowDescriptorTypeDateInline title:@"开始日期"];
    NSTimeInterval secondsPerDay1 = 24*60*60*7;
    NSDate *now = [NSDate date];
    NSDate *lastWeek = [now dateByAddingTimeInterval:-secondsPerDay1];
    
    row.value = lastWeek;
    
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEndDate rowType:XLFormRowDescriptorTypeDateInline title:@"结束日期"];
    
    row.value =[NSDate date];
    [section addFormRow:row];
    
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSearch rowType:XLFormRowDescriptorTypeButton title:@"确 定"];
//    [row.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
//    row.action.formSelector = @selector(didTouchButton:);
//    [section addFormRow:row];
    
    self.form = formDescriptor;
}

-(void)didTouchButton:(XLFormRowDescriptor *)sender
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar.backItem setTitle:@""];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setTitle:@"筛选日期"];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self  action:@selector(saveButtonHandle)];
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) goBack
{
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void) saveButtonHandle
{
    NSDate *startDate=[self.form formRowWithTag:kStartDate].value;
    
    NSDate *endDate=[self.form formRowWithTag:kEndDate].value;
    
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.dateFormat=@"yyyyMMdd";
    
    
    
    [self.delegate getSTART_DATE:[fmt stringFromDate:startDate] andEND_DATE:[fmt stringFromDate:endDate]];
    [self.navigationController popViewControllerAnimated:YES];

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
