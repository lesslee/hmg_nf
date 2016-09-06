//
//  addMonthReportViewController.m
//  hmg
//
//  Created by hongxianyu on 2016/8/16.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "addMonthReportViewController.h"
#import "XLForm.h"
#import "SoapHelper.h"
#import "CommonResult.h"
#import "Common.h"
#import "NF_UPLOAD_MONTHLY_REPORT.h"
#import "StoreTableViewController.h"
#import "BrandTableViewController.h"
#import "Store.h"
#import "Brand.h"
#import "AppDelegate.h"
#import "UserInfo.h"
@interface addMonthReportViewController ()<UIAlertViewDelegate>
//{
//
//    int *month2;
//    int *month1;
//
//}
@end
    //月份
NSString *const kDate = @"kDate";
    //门店
NSString *const kStoreName = @"kStoreName";
    //品牌
NSString *const kBrandName = @"kBrandName";
    //月末库存
NSString *const kVentory = @"kVentory";
    //月累计销量
NSString *const kSALES_QTY = @"kSALES_QTY";

@implementation addMonthReportViewController

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
    
    self.formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"新建月报"];
    
    self.section=[XLFormSectionDescriptor formSection];
    
    [self.formDescriptor addFormSection:self.section];
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kDate rowType:XLFormRowDescriptorTypeInfo title:@"日期"];
    [self.row.cellConfig setObject:[UIColor grayColor] forKey:@"textLabel.textColor"];
    [self.section addFormRow:self.row];
    
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kStoreName rowType:XLFormRowDescriptorTypeSelectorPush title:@"门店"];
    self.row.selectorControllerClass = [StoreTableViewController class];
    [self.section addFormRow:self.row];

    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kBrandName rowType:XLFormRowDescriptorTypeSelectorPush title:@"品牌"];
    self.row.selectorControllerClass = [BrandTableViewController class];
    [self.section addFormRow:self.row];

    
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kVentory rowType:XLFormRowDescriptorTypeNumber title:@"月末库存:"];
    [self.section addFormRow:self.row];
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kSALES_QTY rowType:XLFormRowDescriptorTypeNumber title:@"月累积销量:"];
    [self.section addFormRow:self.row];

    self.form = self.formDescriptor;

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    [self.form formRowWithTag:kDate].value = appDelegate.userInfo.V_MONTH;
    NSLog(@"%@1234",appDelegate.userInfo.V_MONTH);
    [self.tableView reloadData];
    }

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    self.navigationItem.title=@"月报录入";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    
        //[self.navigationController.navigationBar.backItem setTitle:@""];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveMonthReport)];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveMonthReport{
    
//    NSDate *time=[self.form formRowWithTag:kDate].value;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyyMM"];
//    
//    NSString *date = [dateFormatter stringFromDate:time];
//    NSLog(@"%@",date);
//    
//    NSString  *month = [date substringWithRange:NSMakeRange(4, 2)];
//    NSLog(@"%@",month);
//    month1 = [month intValue];
//    NSLog(@"%d",month1);
    NSString *VentoryString = [self.form formRowWithTag:kVentory].value;
    NSString *Ventory = VentoryString.description;
    NSLog(@"%@",Ventory);
    
    NSString *sealQtyString = [self.form formRowWithTag:kSALES_QTY].value;
    NSString *sealQty = sealQtyString.description;
    NSLog(@"%@",sealQty);
    
    Store *tmpStore = [self.form formRowWithTag:kStoreName].value;
    NSLog(@"%@,%@",tmpStore.STORE_ID,tmpStore.STORE_NM);
    Brand *tmpBrand = [self.form formRowWithTag:kBrandName].value;
    NSLog(@"%@,%@",tmpBrand.brandID,tmpBrand.brandNAME);
    if ([Ventory isEqualToString:@""]|| [sealQty isEqualToString:@""]||tmpBrand==nil||tmpStore==nil) {
        [HUDManager showMessage:@"信息不完整!" mode:MBProgressHUDModeText duration:1];
    }
    else
        {
//       
//        if ((month1 > month2) || (month1 < month2)) {
//            [HUDManager showMessage:@"请选择当月日期" mode:MBProgressHUDModeText duration:2];;
//        }else
//            {
            Common *common=[[Common alloc] initWithView:self.view];
            
            if (common.isConnectionAvailable) {
                
                [HUDManager showMessage:@"正在提交"];
                AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
                
                NF_UPLOAD_MONTHLY_REPORT *param=[[NF_UPLOAD_MONTHLY_REPORT alloc] init];
                param.IN_EMP_NO=appDelegate.userInfo.EMP_NO;
                
                param.IN_PRODUCT_ID=tmpBrand.brandID;
                param.IN_STORE_ID=tmpStore.STORE_ID;
                param.IN_INVENTORY=Ventory;
                param.IN_SALES_QTY=sealQty;
                param.IN_DEPT_CD=appDelegate.userInfo.DEPT_CD;
                NSLog(@"%@,%@,%@,%@,%@,%@",param.IN_DEPT_CD,param.IN_SALES_QTY,param.IN_INVENTORY,param.IN_STORE_ID,param.IN_EMP_NO,param.IN_PRODUCT_ID);
                NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
                
                [self.serviceHelper resetQueue];
                
                ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod1:@"NF_UPLOAD_MONTHLY_REPORT" soapMessage:paramXml];
                [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"NF_UPLOAD_MONTHLY_REPORT",@"name", nil]];
                [self.serviceHelper addRequestQueue:request1];
                
                [self.serviceHelper startQueue];
            }
            
        }
    }
    //}


#pragma ---------------调用服务代码-------------------

-(void) finishQueueComplete
{
    
}

-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
        //error.description
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
    
}

    //请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    /**上传月报接口**/
    if ([@"NF_UPLOAD_MONTHLY_REPORT" isEqualToString:[dic objectForKey:@"name"]]) {
        CommonResult *result3=[[CommonResult alloc] init];
        NSMutableArray *array =[[NSMutableArray alloc] init];
        [array addObjectsFromArray:[result3 searchNodeToArray:xml nodeName:@"NewDataSet"]];
        
        if ([result3.OUT_RESULT isEqualToString:@"0"]) {
            [HUDManager showSuccessWithMessage:@"上传成功" duration:1 complection:^{
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
        else
            {
            NSString *errorStr=result3.OUT_RESULT_NM;
            NSLog(@"%@",errorStr);
            [HUDManager showErrorWithMessage:[NSString stringWithFormat:@"保存失败\n%@",errorStr] duration:5 complection:^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
            }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}


@end
