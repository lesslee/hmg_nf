//
//  AddReportViewController.m
//  hmg
//
//  Created by Lee on 15/3/26.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "AddReportViewController.h"
#import "XLForm.h"
#import "AgentTableViewController.h"
#import "StoreTableViewController.h"
#import "BrandTableViewController.h"
#import "PurposeViewController.h"
#import "SAVE_DAILY_REPORT.h"
#import "AppDelegate.h"
#import "Store.h"
#import "Purpose.h"
#import "Agent.h"
#import "Brand.h"
#import "SoapHelper.h"
#import "CommonResult.h"
#import "Common.h"
#import "UploadViewController.h"
#import "TimeTableViewController.h"
#import "Date.h"
#import "PurposeViewController1.h"
@interface AddReportViewController ()<UIAlertViewDelegate>
{
    NSString *date1;
    NSString *str3;
    NSString *storeOrAgent;
}

@end

//被拜访人
NSString *const kName = @"name";
//手机
NSString *const kName_tel = @"tel";
////固话
//NSString *const kName_gh = @"gh";
//门店或经销商
NSString *const kSelectorStore = @"selectorStore";
//品类
NSString *const kSelectorBrand = @"selectorBrand";
//目的
NSString *const kSelectorPurpose = @"selectorPurpose";
//拜访类型
NSString *const kSwitchBool = @"switchBool";
//摘要
NSString *const kNotes = @"notes";

//拜访日期
NSString *const kSegmentedControl = @"segmentedControl";
    //拜访时间
NSString *const ktime = @"ktime";
//库存
NSString *const KNumber = @"KNumber";

//下次拜访计划安排
NSString *const KVistPlan = @"KVistPlan";


@implementation AddReportViewController



//ServiceHelper *serviceHelper;

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
    
    self.formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"日报录入"];
    
    self.section=[XLFormSectionDescriptor formSection];
    
    [self.formDescriptor addFormSection:self.section];
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kSegmentedControl rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"拜访日期"];
    [self.row.cellConfig setObject:[UIColor colorWithRed:49.0/255.0 green:148.0 / 255.0 blue:208.0 / 255.0 alpha:1.0] forKey:@"segmentedControl.tintColor"];
    self.row.selectorOptions = @[@"昨天", @"今天"];
    self.row.value = @"今天";
    [self.section addFormRow:self.row];
    
    
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:ktime rowType:XLFormRowDescriptorTypeSelectorPush title:@"拜访时间"];
    self.row.selectorControllerClass = [TimeTableViewController class];
    [self.section addFormRow:self.row];
    
    
    
    self.row=[XLFormRowDescriptor formRowDescriptorWithTag:kSwitchBool rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"拜访类型"];
    
    [self.row.cellConfig setObject:[UIColor colorWithRed:49.0/255.0 green:148.0 / 255.0 blue:208.0 / 255.0 alpha:1.0] forKey:@"segmentedControl.tintColor"];
    self.row.selectorOptions = @[@"门店",@"经销商"];
    self.row.value = @"门店";
    [self.section addFormRow:self.row];
    //添加监听
    [self.row addObserver:self forKeyPath:@"value" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorStore rowType:XLFormRowDescriptorTypeSelectorPush title:@"门店"];
    self.row.selectorControllerClass = [StoreTableViewController class];
    [self.section addFormRow:self.row];
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kName rowType:XLFormRowDescriptorTypeText title:@"被拜访人"];
    self.row.required = YES;
    [self.section addFormRow:self.row];
    
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kName_tel rowType:XLFormRowDescriptorTypeNumber title:@"手机"];
    
    [self.section addFormRow:self.row];
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorPurpose rowType:XLFormRowDescriptorTypeSelectorPush title:@"拜访目的"];
    self.row.selectorControllerClass = [PurposeViewController class];
    [self.section addFormRow:self.row];

    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorBrand rowType:XLFormRowDescriptorTypeSelectorPush title:@"主要品牌"];
    self.row.selectorControllerClass = [BrandTableViewController class];
    [self.section addFormRow:self.row];
    
//    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:KNumber rowType:XLFormRowDescriptorTypePhone title:@"库存"];
//    
//    [self.section addFormRow:self.row];

    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:kNotes rowType:XLFormRowDescriptorTypeTextView title:@"小结:"];
    [self.section addFormRow:self.row];
    
    
    self.row = [XLFormRowDescriptor formRowDescriptorWithTag:KVistPlan rowType:XLFormRowDescriptorTypeTextView title:@"下次拜访计划安排:"];
    [self.section addFormRow:self.row];

    self.form = self.formDescriptor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    self.navigationItem.title=@"日报录入";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveReport)];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//返回
-(void) goBack
{
    [self.serviceHelper resetQueue];
    self.serviceHelper=nil;
    [HUDManager hide];
    //移除kvo
    [[self.form formRowWithTag:kSwitchBool] removeObserver:self forKeyPath:@"value" context:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//保存日报
-(void) saveReport
{
    //被拜访人
    NSString *strName=[self.form formRowWithTag:kName].value;
//手机
   NSNumber *tel = [self.form formRowWithTag:kName_tel].value;
    NSString *StringNumber = tel.description;
    NSLog(@"%@",StringNumber);
        //拜访时间
    Date *tmpDate = [self.form formRowWithTag:ktime].value;
        //主要品牌
    Brand *tmpBrand=[self.form formRowWithTag:kSelectorBrand].value;
        //目的
    Purpose *tmpPurpose=[self.form formRowWithTag:kSelectorPurpose].value;
        //小结
    NSString *strNotes=[self.form formRowWithTag:kNotes].value;
    //NSString *number = [self.form formRowWithTag:KNumber].value;
        //下次计划
    NSString *visitPlan = [self.form formRowWithTag:KVistPlan].value;
    
    if ([self.form formRowWithTag:KVistPlan].value == nil || [self.form formRowWithTag:kNotes].value == nil||[strName isEqualToString:@""]||[StringNumber isEqualToString:@""] || tmpDate == nil||tmpBrand==nil||tmpPurpose==nil) {
        [HUDManager showMessage:@"信息不完整!" mode:MBProgressHUDModeText duration:1];
    }else
    {
        Common *common=[[Common alloc] initWithView:self.view];
        
        if (common.isConnectionAvailable) {
            
            [HUDManager showMessage:@"正在提交"];
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            
            SAVE_DAILY_REPORT *param=[[SAVE_DAILY_REPORT alloc] init];
            param.IN_EMP_NO=appDelegate.userInfo.EMP_NO;
            param.IN_PRODUCT_ID=tmpBrand.brandID;
            param.IN_VISIT_PURPOSE=tmpPurpose.ID;
            param.IN_VISIT_PERSON=strName;
            param.IN_VISIT_TIME=tmpDate.ID;
            param.IN_VISIT_PERSON_TEL=StringNumber;
            NSLog(@"%@",param.IN_VISIT_PERSON_TEL);
            param.IN_RMK=strNotes;
            param.IN_VISIT_PLAN = visitPlan;
                //param.IN_INVENTORY = number;
            NSLog(@"%@",param.IN_INVENTORY);
            NSLog(@"%@",[self.form formRowWithTag:kSwitchBool].value);
            if ([[self.form formRowWithTag:kSwitchBool].value isEqualToString:@"门店"] ) {
                Store *tmpStore= [self.form formRowWithTag:kSelectorStore].value;
                param.IN_STORE_ID=tmpStore.STORE_ID;
                str3 = tmpStore.STORE_NM;
                param.IN_AGENT_ID=@"";
            }else
            {
                Agent *tmpAgent= [self.form formRowWithTag:kSelectorStore].value;
                param.IN_STORE_ID=@"";
                str3 = tmpAgent.AGENT_NM;
                param.IN_AGENT_ID=tmpAgent.AGENT_ID;
            }
            if ([[self.form formRowWithTag:kSegmentedControl].value isEqualToString:@"今天"]) {
                param.IN_TODAY_OR_YESTODAY=@"1";
                date1 = param.IN_TODAY_OR_YESTODAY;
                
            }
            else
            {
                param.IN_TODAY_OR_YESTODAY=@"0";
            }
            
            NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
            
            [self.serviceHelper resetQueue];
            
            ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod1:@"SAVE_DAILY_REPORT" soapMessage:paramXml];
            [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"SAVE_DAILY_REPORT",@"name", nil]];
            [self.serviceHelper addRequestQueue:request1];
            
            [self.serviceHelper startQueue];
        }
        
    }
}
//重写键值监听方法
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    XLFormRowDescriptor *switchRow=[self.form formRowWithTag:kSelectorStore];
    XLFormRowDescriptor *switchRow1=[self.form formRowWithTag:kSwitchBool];
    XLFormRowDescriptor *prouce=[self.form formRowWithTag:kSelectorPurpose];

    if ([switchRow1.value isEqualToString: @"经销商"]) {
        prouce.selectorControllerClass = [PurposeViewController1 class];
        switchRow.title=@"经销商";
        switchRow.selectorControllerClass=[AgentTableViewController class];
        
    } else if([switchRow1.value isEqualToString: @"门店"]) {
        prouce.selectorControllerClass = [PurposeViewController class];
        switchRow.title=@"门店";
        switchRow.selectorControllerClass=[StoreTableViewController class];
    }
    
       switchRow.value=nil;
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
     [self.tableView reloadData];
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
    /**保存日报接口**/
    if ([@"SAVE_DAILY_REPORT" isEqualToString:[dic objectForKey:@"name"]]) {
        CommonResult *result=[[CommonResult alloc] init];
        NSMutableArray *array =[[NSMutableArray alloc] init];
        [array addObjectsFromArray:[result searchNodeToArray:xml nodeName:@"NewDataSet"]];
        [HUDManager hide];
        if ([result.OUT_RESULT isEqualToString:@"0"]) {
            self.reportId=result.ID;
            NSLog(@"%@",self.reportId);
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"日报保存成功,是否上传照片?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alertView show];
        }
        else
        {
            NSString *errorStr=result.OUT_RESULT_NM;
            NSLog(@"%@",errorStr);
            [HUDManager showErrorWithMessage:[NSString stringWithFormat:@"保存失败\n%@",errorStr] duration:5 complection:^{
                [self goBack];
            }];
        }
    }
}

//提示框代理
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[self.form formRowWithTag:kSwitchBool] removeObserver:self forKeyPath:@"value" context:nil];
        [self performSegueWithIdentifier:@"uploadId" sender:self];
    }
    else
    {
        [self goBack];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"uploadId"]) {
        
        id uploadController=segue.destinationViewController;
        [uploadController setValue:self.reportId forKey:@"reportId"];
        [uploadController setValue:date1 forKey:@"time1"];
        [uploadController setValue:str3 forKey:@"StoreOrAgent"];

    }
}

@end
