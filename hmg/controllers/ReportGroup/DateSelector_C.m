//
//  DateSelector_C.m
//  hmg
//
//  Created by Lee on 15/7/17.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "DateSelector_C.h"

@interface DateSelector_C()

@end


NSString *const kDateB1 = @"DateB1";
NSString *const kDateB2 = @"DateB2";
NSString *const kDateB3 = @"DateB3";
@implementation DateSelector_C
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
    
    section.title=@"开始月份和结束月份只选择月份，年和日不用选";
    
    [formDescriptor addFormSection:section];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateB1 rowType:XLFormRowDescriptorTypeDateInline title:@"选择年份"];
    
    row.value =[NSDate date];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateB2 rowType:XLFormRowDescriptorTypeDateInline title:@"开始月份"];
    
    row.value =[NSDate date];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateB3 rowType:XLFormRowDescriptorTypeDateInline title:@"结束月份"];
    
    row.value =[NSDate date];
    [section addFormRow:row];
    
    //    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSearch rowType:XLFormRowDescriptorTypeButton title:@"确 定"];
    //    [row.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
    //    row.action.formSelector = @selector(didTouchButton:);
    //    [section addFormRow:row];
    
    self.form = formDescriptor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];

    [self.navigationController.navigationBar.backItem setTitle:@""];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setTitle:@"日期选择"];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self  action:@selector(saveButtonHandle)];
}


-(void) goBack
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//保存日期
-(void) saveButtonHandle
{
    NSDate *year=[self.form formRowWithTag:kDateB1].value;
    NSDate *sMonth=[self.form formRowWithTag:kDateB2].value;
    NSDate *eMonth=[self.form formRowWithTag:kDateB3].value;
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    
    fmt.dateFormat=@"yyyy";
    
    NSDateFormatter *fmt1=[[NSDateFormatter alloc] init];
    
    fmt1.dateFormat=@"M";
    
    if ([[fmt1 stringFromDate:sMonth] intValue] <=[[fmt1 stringFromDate:eMonth] intValue]) {
        [self.delegate getYEAR:[fmt stringFromDate:year] andSMonth:[fmt1 stringFromDate:sMonth] andEMonth:[fmt1 stringFromDate:eMonth]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [HUDManager showMessage:@"日期选择错误" duration:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
