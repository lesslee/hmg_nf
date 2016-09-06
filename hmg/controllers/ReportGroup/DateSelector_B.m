//
//  DateSelector_B.m
//  hmg
//
//  Created by Lee on 15/7/17.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "DateSelector_B.h"

@interface DateSelector_B ()

@end
NSString *const kDateA1 = @"DateA1";
@implementation DateSelector_B
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
    
    section.title=@"日期选择,只选择年份和月份";
    
    [formDescriptor addFormSection:section];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateA1 rowType:XLFormRowDescriptorTypeDateInline title:@"选择年月"];
    
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

-(void) saveButtonHandle
{
    NSDate *startDate=[self.form formRowWithTag:kDateA1].value;
    
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    
    fmt.dateFormat=@"yyyyMM";
    
    [self.delegate getSTART_DATE:[fmt stringFromDate:startDate]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
