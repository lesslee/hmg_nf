//
//  DetailMonthReport.m
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "DetailMonthReport.h"
#import "XLForm.h"
#import "SoapHelper.h"
#import "CommonResult.h"
#import "Common.h"
#import "AppDelegate.h"
#import "NF_UPLOAD_MONTHLY_REPORT.h"
#import "storeMonthViewController.h"
@interface DetailMonthReport ()<UIAlertViewDelegate>
{
    NSString *storename;
    NSString *brandname;
    NSString *invorty;
    NSString *sealqty;
    NSString *storeID1;
    NSString *BrandID1;
}

@end


NSString *const kStoreName1 = @"kStoreName1";
NSString *const kBrandName1 = @"kBrandName1";
NSString *const kInvertoy = @"kInvertoy";
NSString *const kSealQty = @"kSealQty";

@implementation DetailMonthReport
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
    
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"月报修改"];
    
    section=[XLFormSectionDescriptor formSection];
    section.title=@"所 选 月 报 详 细 内 容";
    [formDescriptor addFormSection:section];
    
    
        // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kStoreName1 rowType:XLFormRowDescriptorTypeInfo title:@"门店:"];
    [self.row.cellConfig setObject:[UIColor grayColor] forKey:@"textLabel.textColor"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBrandName1 rowType:XLFormRowDescriptorTypeInfo title:@"品牌:"];
    [self.row.cellConfig setObject:[UIColor grayColor] forKey:@"textLabel.textColor"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kInvertoy rowType:XLFormRowDescriptorTypeNumber title:@"月末库存:"];
    
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSealQty rowType:XLFormRowDescriptorTypeNumber title:@"月累积销量:"];
    
    [section addFormRow:row];

    self.form = formDescriptor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    self.navigationItem.title=@"月报修改";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
        // self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(gomonth)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveReport1)];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
}
    //返回
-(void) gomonth
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.form formRowWithTag:kStoreName1].value = storename;
    [self.form formRowWithTag:kBrandName1].value = brandname;

    [self.form formRowWithTag:kInvertoy].value = invorty;

    [self.form formRowWithTag:kSealQty].value = sealqty;

   
    [self.tableView reloadData];
}
-(void)passTrendValues:(NSString *)storeName AndBrandName:(NSString *)brandName AndInvertoy:(NSString *)invertory AndSealQty:(NSString *)sealQty AndStoreID:(NSString *)StoreID AndBrandID:(NSString *)BrandID
{
    storename = storeName;
    brandname = brandName;
    invorty = invertory;
    sealqty = sealQty;
    storeID1 = StoreID;
    BrandID1 = BrandID;
    NSLog(@"%@,%@,%@,%@,%@,%@",storename,brandname,invorty,sealqty,storeID1,BrandID1);
}


-(void)saveReport1{
    
    NSNumber *VentoryString = [self.form formRowWithTag:kInvertoy].value;
    NSString *Ventory = VentoryString.description;
    NSLog(@"%@",Ventory);
    NSNumber *sealQtyString = [self.form formRowWithTag:kSealQty].value;
    NSString *sealQty = sealQtyString.description;
    NSLog(@"%@",sealQty);
//    NSString *tmpStore = [self.form formRowWithTag:kStoreName].value;
//    
//    Brand *tmpBrand = [self.form formRowWithTag:kBrandName].value;
    
    
        Common *common=[[Common alloc] initWithView:self.view];
        
        if (common.isConnectionAvailable) {
            
            [HUDManager showMessage:@"正在提交"];
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            
            NF_UPLOAD_MONTHLY_REPORT *param=[[NF_UPLOAD_MONTHLY_REPORT alloc] init];
            param.IN_EMP_NO=appDelegate.userInfo.EMP_NO;
            param.IN_PRODUCT_ID=BrandID1;
            param.IN_STORE_ID=storeID1;
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
//storeMonthViewController *svc = [[storeMonthViewController alloc]init];
[self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
        else
            {
            NSString *errorStr=result3.OUT_RESULT_NM;
            NSLog(@"%@",errorStr);
            [HUDManager showErrorWithMessage:[NSString stringWithFormat:@"保存失败\n%@",errorStr] duration:1 complection:^{
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
