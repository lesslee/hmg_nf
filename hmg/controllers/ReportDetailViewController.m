//
//  ReportDetailViewController.m
//  hmg
//
//  Created by Lee on 15/4/14.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "ReportDetailViewController.h"
#import "ReportDetailDelegate.h"
#import "SoapHelper.h"
#import "HMG_DAILY_REPORT_DETAIL.h"
#import "ReportDetailModel.h"
#import "HMG_DAILY_REPORT_PHOTO.h"
#import "ReportPhoto.h"
#import "Common.h"
#import "ReportPhotoViewController.h"
#import "LxFTPRequest.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
static NSString * const FTP_ADDRESS = @"ftp://118.102.25.43:21";
static NSString * const USERNAME = @"hmg";
static NSString * const PASSWORD = @"hmg6102";

@interface ReportDetailViewController (){
 
    NSString *file2;
    NSString *file3;
    NSString *date1;
    
    NSString *string;
    
    NSString *time;
    
JGProgressHUD * _progressHUD;
}
@property(nonatomic, strong) UIDocumentInteractionController *documentController;
@end

ASIHTTPRequest *request1;
NSString *const kAGENT_NM = @"kAGENT_NM";
NSString *const kSTORE_NM = @"kSTORE_NM";
NSString *const kPRODUCT_NM = @"kPRODUCT_NM";
NSString *const kVISIT_PURPOSE = @"kVISIT_PURPOSE";
NSString *const kVISIT_PERSON = @"kVISIT_PERSON";
NSString *const kVISIT_PERSON_TEL = @"kVISIT_PERSON_TEL";
NSString *const kVISIT_PERSON_GH = @"kVISIT_PERSON_GH";
NSString *const kRMK = @"kRMK";
NSString *const kINVENTORY = @"kINVENTORY";
NSString *const KVISIT_PLAN = @"KVISIT_PLAN";
@implementation ReportDetailViewController

XLFormDescriptor * formDescriptor;
XLFormSectionDescriptor * section;
XLFormRowDescriptor * row;

ReportDetailModel *model;

NSArray *photoArray;

NSArray *photoArray1;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    [HUDManager showMessage:@"加载内容"];
    
    [self getReportDetailInfo];
    
    }

-(void) getReportDetailInfo
{
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
    
    HMG_DAILY_REPORT_DETAIL *param=[[HMG_DAILY_REPORT_DETAIL alloc] init];
    param.IN_REPORT_ID=self.reportId;
        
    NSLog(@"%@----------ID",param.IN_REPORT_ID);
    
    NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
    
    [self.serviceHelper resetQueue];
    
   request1=[ServiceHelper commonSharedRequestMethod:@"HMG_DAILY_REPORT_DETAIL" soapMessage:paramXml];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_DAILY_REPORT_DETAIL",@"name", nil]];
    
    [self.serviceHelper addRequestQueue:request1];
    
    [self.serviceHelper startQueue];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title=@"日报明细";
    
self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
}

-(void) goBack
{
    [request1 clearDelegatesAndCancel];
    [self.serviceHelper resetQueue];
    self.serviceHelper=nil;
    [HUDManager hide];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initializeForm
{
    
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"日报录入"];
    
    section=[XLFormSectionDescriptor formSection];
    section.title=@"所 选 日 报 详 细 内 容";
    [formDescriptor addFormSection:section];
    
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAGENT_NM rowType:XLFormRowDescriptorTypeText title:@"经销商:"];
    row.disabled=YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSTORE_NM rowType:XLFormRowDescriptorTypePhone title:@"门店:"];
    row.disabled = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPRODUCT_NM rowType:XLFormRowDescriptorTypePhone title:@"品牌:"];
    row.disabled = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kVISIT_PURPOSE rowType:XLFormRowDescriptorTypePhone title:@"目的:"];
    row.disabled = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kVISIT_PERSON rowType:XLFormRowDescriptorTypePhone title:@"被拜访人:"];
    row.disabled = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kVISIT_PERSON_TEL rowType:XLFormRowDescriptorTypePhone title:@"手机:"];
    row.disabled = YES;
    [section addFormRow:row];
    
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kVISIT_PERSON_GH rowType:XLFormRowDescriptorTypePhone title:@"固话:"];
//    row.disabled = YES;
//    [section addFormRow:row];
//    
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kINVENTORY rowType:XLFormRowDescriptorTypePhone title:@"库存:"];
//    row.disabled=YES;
//    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kRMK rowType:XLFormRowDescriptorTypeTextView title:@"小结:"];
    row.disabled=YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KVISIT_PLAN rowType:XLFormRowDescriptorTypeTextView title:@"下次拜访计划安排:"];
    row.disabled=YES;
    [section addFormRow:row];
    
    section=[XLFormSectionDescriptor formSection];
    section.title=@"照 片 列 表";
    [formDescriptor addFormSection:section];
    
    self.form = formDescriptor;
}

#pragma 服务代理
-(void) finishQueueComplete
{
    
}

-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    @try {
        
        if ([@"HMG_DAILY_REPORT_DETAIL" isEqualToString:[dic objectForKey:@"name"]]) {
            model=[[ReportDetailModel alloc] init];
            NSMutableArray *array =[[NSMutableArray alloc] init];
            [array addObjectsFromArray:[model searchNodeToArray:xml nodeName:@"NewDataSet"]];
            XLFormRowDescriptor *row1=[self.form formRowWithTag:kAGENT_NM];
            row1.value=model.AGENT_NM;
            [self reloadFormRow:row1];
            
            row1=[formDescriptor formRowWithTag:kSTORE_NM];
            row1.value=model.STORE_NM;
            [self reloadFormRow:row1];
            row1=[formDescriptor formRowWithTag:kPRODUCT_NM];
            row1.value=model.PRODUCT_NM;
            [self reloadFormRow:row1];
            row1=[formDescriptor formRowWithTag:kVISIT_PURPOSE];
            row1.value=model.VISIT_PURPOSE;
            [self reloadFormRow:row1];
            row1=[formDescriptor formRowWithTag:kVISIT_PERSON];
            row1.value=model.VISIT_PERSON;
            [self reloadFormRow:row1];
            row1=[formDescriptor formRowWithTag:kVISIT_PERSON_TEL];
            row1.value=model.VISIT_PERSON_TEL;
            [self reloadFormRow:row1];
            row1=[formDescriptor formRowWithTag:kVISIT_PERSON_GH];
            row1.value=model.VISIT_PERSON_GH;
            [self reloadFormRow:row1];
            row1=[formDescriptor formRowWithTag:kINVENTORY];
            row1.value=model.INVENTORY;
            [self reloadFormRow:row1];
            
            row1=[formDescriptor formRowWithTag:kRMK];
            row1.value=model.RMK;
            [self reloadFormRow:row1];
            
            row1=[formDescriptor formRowWithTag:KVISIT_PLAN];
            row1.value=model.VISIT_PLAN;
            [self reloadFormRow:row1];
            
            [HUDManager showMessage:@"加载照片"];
            HMG_DAILY_REPORT_PHOTO *param=[[HMG_DAILY_REPORT_PHOTO alloc] init];
            param.IN_PHOTO_ID=model.UPLOAD_PHOTO_ID;
            
            NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
            
            request1=[ServiceHelper commonSharedRequestMethod:@"HMG_DAILY_REPORT_PHOTO" soapMessage:paramXml];
            [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_DAILY_REPORT_PHOTO",@"name", nil]];
            
            [self.serviceHelper addRequestQueue:request1];
            
            [self.serviceHelper startQueue];
        }
        
        if ([@"HMG_DAILY_REPORT_PHOTO" isEqualToString:[dic objectForKey:@"name"]]) {
            
            ReportPhoto *tempPhoto=[[ReportPhoto alloc] init];
            photoArray =[tempPhoto searchNodeToArray:xml nodeName:@"NewDataSet"];
            
            for (ReportPhoto *photo in photoArray) {
                NSLog(@"%@",photo.FILE_NM1);
                if(photo.FILE_PATH!=nil)
                {
                    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"photo" rowType:XLFormRowDescriptorTypeButton title:photo.FILE_NM2];
                    [buttonRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
                    //buttonRow.value = photo.FILE_NM2;
//                    file2 = buttonRow.value;
                    //file2 = photo.FILE_NM2;
                    buttonRow.action.formSelector = @selector(didTouchButton:);
                    [section addFormRow:buttonRow];
                }else{
                    
                    
                    XLFormRowDescriptor * buttonRow1 = [XLFormRowDescriptor formRowDescriptorWithTag:@"photo" rowType:XLFormRowDescriptorTypeButton title:@"没有照片信息"];
                    
                    [section addFormRow:buttonRow1];
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"没有上传照片!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                    [alertView show];
                }
                
            }
            
            [self.tableView reloadData];
            
            [HUDManager hide];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@%@",[exception name],[exception reason]);
    }
    @finally {
        [HUDManager hide];
    }
}


-(void)didTouchButton:(XLFormRowDescriptor *)sender
{
    
    
    date1 = self.inpdtm;
    NSLog(@"%@",self.inpdtm);
    NSString *year = [date1 substringWithRange:NSMakeRange(0, 4)];
    NSLog(@"%@",year);
    NSString *month2 = [date1 substringWithRange:NSMakeRange(5, 2)];
    NSLog(@"%@",month2);
    NSString *month = [date1 substringWithRange:NSMakeRange(5, 1)];
    NSLog(@"%@",month);
    NSString *month1 = [date1 substringWithRange:NSMakeRange(6, 1)];
    NSLog(@"%@",month1);
    NSString *day2 = [date1 substringWithRange:NSMakeRange(8, 2)];
    NSLog(@"%@",day2);
    NSString *day = [date1 substringWithRange:NSMakeRange(8, 1)];
    NSLog(@"%@",day);
    NSString *day1 = [date1 substringWithRange:NSMakeRange(9, 1)];
    NSLog(@"%@",day1);
    
    
    if ([month isEqualToString:@"0"]) {
        
        if ([day isEqualToString:@"0"]) {
            
            string = [[year stringByAppendingString:month1]stringByAppendingString:day1];
            NSLog(@"%@",string);
        } else {
            string = [[year stringByAppendingString:month1]stringByAppendingString:day2];
            NSLog(@"%@",string);
            
        }
    } else {
        if ([day isEqualToString:@"0"]) {
            
            string = [[year stringByAppendingString:month2]stringByAppendingString:day1];
            NSLog(@"%@",string);
            
        } else {
            string = [[year stringByAppendingString:month2]stringByAppendingString:day2];
            NSLog(@"%@",string);
            
        }
    }
    
    file3 =sender.title;
    NSLog(@"%@",file3);
    time  = string;
    [self performSegueWithIdentifier:@"photoId" sender:self];


    }



-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"photoId"]) {
        id detailViewController=segue.destinationViewController;
        
        [detailViewController setValue:file3 forKey:@"fileName"];
        [detailViewController setValue:time forKey:@"date"];
        
    }

}

@end
