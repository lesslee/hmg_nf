//
//  WeekViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "WeekViewController.h"
#import "XLForm.h"
#import "StoreTableViewController.h"
#import "Brand1TableViewController.h"
#import "ProuctTableViewController.h"
//#import "INSERT_WEEK_PROMOTION.h"
#import "AppDelegate.h"
#import "Store.h"
#import "Brand1.h"
#import "Prouct.h"
#import "SoapHelper.h"
#import "CommonResult.h"
#import "Common.h"
#import "ProuctViewController.h"
#import "prouctSection.h"
#import "LYChooseTool.h"
@interface WeekViewController (){
    NSString *Brandid;
    NSString *BrandName;
    NSString *data;
    NSString *storeid;
    NSString *storeName;
    NSString *storeName1;
    NSString *myDate;
    Store  *store;
    Store *store2;
    NSDate *selectedDate;
}
@end

//门店
NSString * kStore = @"store";
//品牌
NSString * kBrand = @"brand";
//产品
NSString * kProd = @"prod";
//数量
NSString * kQty = @"qty";
//时间
NSString * kProm_DTM = @"Prom_DTM";
//金额
NSString *KPOS_MONEY = @"pos_money";

@implementation WeekViewController

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

-(void)initializeForm
{
    [self readNSUserDefaults];
    self.formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"周末促信息"];
    
    self.section=[XLFormSectionDescriptor formSection];
    
    [self.formDescriptor addFormSection:self.section];
    
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kProm_DTM rowType:XLFormRowDescriptorTypeDate title:@"日期:"];
    if (selectedDate == nil) {
        self.row.value = [NSDate date];
    }else{
    self.row.value = selectedDate;
    }
    [self.section addFormRow:self.row];

    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kStore rowType:XLFormRowDescriptorTypeSelectorPush title:@"门店:"];
    self.row.selectorControllerClass = [StoreTableViewController class];
    
    if (self.row.value == nil) {

        self.row.value = store2;
        
    }else{
        //self.row.value = store2;
//        self.row.value = nil;
    }
    [self.section addFormRow:self.row];
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kBrand rowType:XLFormRowDescriptorTypeSelectorPush title:@"品牌:"];
    self.row.selectorControllerClass = [Brand1TableViewController class];
    
    [self.section addFormRow:self.row];
    
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:KPOS_MONEY rowType:XLFormRowDescriptorTypePhone
                                                       title:@"POS金额:"];
    //self.row.required = YES;
    [self.section addFormRow:self.row];
    
    
    self.form = self.formDescriptor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    self.navigationItem.title=@"填写周末促";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];

    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
     self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(savePromotion)];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回
-(void)back{
    [[LYChooseTool sharedLYChooseTool] destroy];
 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
//下一步
-(void) savePromotion
{
    NSDate *time=[self.form formRowWithTag:kProm_DTM].value;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    data = [dateFormatter stringFromDate:time];
    NSLog(@"%@",data);
    NSString *posMoney = [self.form formRowWithTag:KPOS_MONEY].value;
    NSLog(@"%@",posMoney);
    Store *tmpStore = [self.form formRowWithTag:kStore].value;
    
    Brand1 *tmpBrand = [self.form formRowWithTag:kBrand].value;
    if ((posMoney == nil) || (tmpStore == nil)||(data == nil) || (tmpBrand == nil))
    {
        [HUDManager showMessage:@"信息不完整!" mode:MBProgressHUDModeText duration:1];
        
    }
    else{
        ProuctViewController *pvc = [[ProuctViewController alloc]init];
        NSMutableArray *tempArray = [[LYChooseTool sharedLYChooseTool] dataArray];
        BOOL haveSameObj = NO;
//        for (NSInteger i = 0; i < tempArray.count; i++) {
//            prouctSection *s = tempArray[i];
//            if ([tmpBrand.NAME isEqualToString:s.NAME]) {
//                haveSameObj = YES;
//                break;
//            }
//        }
//        
//        if (!haveSameObj) {
//            prouctSection *section = [[prouctSection alloc]initWithID:tmpBrand.ID andNAME:tmpBrand.NAME];
//            [[LYChooseTool sharedLYChooseTool] ly_addObject:section];
//            [self saveNSUserDefaults];
//            [self.navigationController pushViewController:pvc animated:YES];
//        }
        
        for (NSInteger i = 0; i < tempArray.count; i++) {
            prouctSection *s = tempArray[i];
            if ([tmpBrand.NAME isEqualToString:s.NAME]) {
                haveSameObj = YES;
                [self saveNSUserDefaults];
                self.trendDelegate = pvc; //设置代理
                [self.trendDelegate passPosMoneyValues:posMoney];
                
                [self.navigationController pushViewController:pvc animated:YES];
                //break;
            }
        }

        if (!haveSameObj) {
            prouctSection *section = [[prouctSection alloc]initWithID:tmpBrand.ID andNAME:tmpBrand.NAME];
            [[LYChooseTool sharedLYChooseTool] ly_addObject:section];
            [self saveNSUserDefaults];
            self.trendDelegate = pvc; //设置代理
            [self.trendDelegate passPosMoneyValues:posMoney];
            [self.navigationController pushViewController:pvc animated:YES];
        }
  
    }
}
//还原数据
-(void)readNSUserDefaults{
    NSUserDefaults *store3 = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [store3 objectForKey:@"oneStore"];
    store2 = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
    selectedDate = [store3 objectForKey:@"selectedDate"];
}


-(void) saveNSUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:@"data"];
    NSLog(@"%@------------",data);
    
    
    selectedDate = (NSDate *) [self.form formRowWithTag:kProm_DTM].value;
    [userDefaults setObject:selectedDate forKey:@"selectedDate"];
    
    NSLog(@"%@1-1",selectedDate);
    
    [userDefaults synchronize];
}


//-(void)readNSUserDefaults1{
//    NSUserDefaults *time = [NSUserDefaults standardUserDefaults];
//    myDate = [time objectForKey:@"data"];
//    //    NSString *data2 = myDate;
//    //    NSLog(@"%@1",data2);
//    [self getTimeStrWithStr:myDate];
//    NSLog(@"%@1-1",myDate);
//    
//}
////转换时间格式
//-(NSString*)getTimeStrWithStr:(NSString*)string{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSDate *date = [formatter dateFromString:string];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSString  *str = [formatter stringFromDate:date];
//    return str;
//}

@end
