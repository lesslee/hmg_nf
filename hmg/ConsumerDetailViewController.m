//
//  ConsumerDetailViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/4/15.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ConsumerDetailViewController.h"
#import "SoapHelper.h"
#import "HMG_NOTIFY.h"
#import "Notify.h"
#import "Common.h"
#import "ASINetworkQueue.h"
#import "HMG_FILE.h"
#import "File.h"
#import "LxFTPRequest.h"
#import "JGProgressHUD/JGProgressHUD.h"
#import "JGProgressHUD/JGProgressHUDPieIndicatorView.h"


static NSString * const FTP_ADDRESS = @"ftp://118.102.25.43:21";
static NSString * const USERNAME = @"hmg";
static NSString * const PASSWORD = @"hmg6102";

@interface ConsumerDetailViewController ()
{
    
    JGProgressHUD * _progressHUD;
}
@property (nonatomic ,strong) NSMutableArray  *consumerArray;

@property(nonatomic, strong) UIDocumentInteractionController *documentController;
@property(nonatomic, strong)NSString *emp_nm;
@property(nonatomic, strong)NSString *code_nm;
@property(nonatomic, strong)NSString *msg_id;
@property(nonatomic, strong)NSString *des;
@property(nonatomic, strong)NSString *inp_dtm;
@property(nonatomic, strong)NSString *Title;

@end
ASIHTTPRequest *request1;
NSString *const KMSG_ID = @"KMSG_ID";
NSString *const KEMP_NM = @"KEMP_NM";
NSString *const KCODE_NM = @"KCODE_NM";
NSString *const KDESCRIPTION = @"KDESCRIPTION";
NSString *const KINP_DTM = @"KINP_DTM";
NSString *const KTITLE = @"KTITLE";
NSString *const KFILE = @"KFILE";


@implementation ConsumerDetailViewController

XLFormDescriptor * formDescriptor;
XLFormSectionDescriptor * section;
XLFormRowDescriptor * row;

NSArray *fileArray;

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
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    self.consumerArray = [[NSMutableArray alloc]init];
    //[HUDManager showMessage:@"加载内容"];
    [self getConsumerDetailInfo];
    [self getFileInfo];
}
-(void) getConsumerDetailInfo
{
    [self readNSUserDefaults];
    XLFormRowDescriptor *row3=[formDescriptor formRowWithTag:KEMP_NM];
    row3.value=self.emp_nm;
    NSLog(@"%@",row3.value);
    [self reloadFormRow:row3];
    
    row3=[formDescriptor formRowWithTag:KCODE_NM];
    row3.value = self.code_nm;
    [self reloadFormRow:row3];
    
    row3=[formDescriptor formRowWithTag:KINP_DTM];
    row3.value = self.inp_dtm;
    
    NSLog(@"%@================",row3.value);
    [self reloadFormRow:row3];
    
    row3=[formDescriptor formRowWithTag:KDESCRIPTION];
    row3.value=self.des;
    [self reloadFormRow:row3];
    
    row3=[formDescriptor formRowWithTag:KTITLE];
    row3.value=self.Title;
    [self reloadFormRow:row3];

    
}


-(void) getFileInfo
{
    [self readNSUserDefaults];
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        
        HMG_FILE *param=[[HMG_FILE alloc] init];
        param.IN_FILE_ID=self.msg_id;
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        
        [self.serviceHelper resetQueue];
        
        request1=[ServiceHelper commonSharedRequestMethod:@"HMG_FILE" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_FILE",@"name", nil]];
        
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }
}



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title=@"Consumer公告明细";
    
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
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Consumer公告"];
    //section=[XLFormSectionDescriptor formSection];
    
    section=[XLFormSectionDescriptor formSection];
    section.title=@"Consumer 公 告 详 细 内 容";
    [formDescriptor addFormSection:section];
    
    
    // Name
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KTITLE rowType:XLFormRowDescriptorTypeText title:@"标题:"];
    row.disabled=YES;
    [section addFormRow:row];

    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KEMP_NM rowType:XLFormRowDescriptorTypeText title:@"发布者:"];
    row.disabled=YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KCODE_NM rowType:XLFormRowDescriptorTypeText title:@"类型:"];
    row.disabled = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KINP_DTM rowType:XLFormRowDescriptorTypeText title:@"时间:"];
    row.disabled = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KDESCRIPTION rowType:XLFormRowDescriptorTypeTextView title:@"内容:"];
    row.disabled = YES;
    [section addFormRow:row];
    
    
    section=[XLFormSectionDescriptor formSection];
    section.title=@"资 料 附 件";
    [formDescriptor addFormSection:section];
    
    self.form = formDescriptor;
}

#pragma 服务代理
-(void) finishQueueComplete
{
    
}


-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"_emp_nm"];
    self.emp_nm = myString;
    NSLog(@"%@",self.emp_nm);
    
    NSString *myString1 = [userDefaultes stringForKey:@"_code_nm"];
    self.code_nm = myString1;
    
    NSString *myString2 = [userDefaultes stringForKey:@"_msg_id"];
    self.msg_id = myString2;
    
    NSString *myString3 = [userDefaultes stringForKey:@"_des"];
    self.des = myString3;
    
    NSString *myString4 = [userDefaultes stringForKey:@"_inp_dtm"];
    self.inp_dtm = myString4;
    NSLog(@"%@aaaaaa",self.inp_dtm);
    
    
    NSString *myString5 = [userDefaultes stringForKey:@"_Title"];
    self.Title = myString5;
    
}

//解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    @try {
       
        if ([@"HMG_FILE" isEqualToString:[dic objectForKey:@"name"]]) {
            
            [HUDManager showMessage:@"加载附件"];
            File *tempFile=[[File alloc] init];
            fileArray =[tempFile searchNodeToArray:xml nodeName:@"NewDataSet"];
            
            
            for (File *file in fileArray) {
                NSLog(@"%@",file.FILE_NM1);
                if(file.FILE_PATH!=nil)
                {
                    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"KFILE" rowType:XLFormRowDescriptorTypeButton title:file.FILE_NM1];
                    
                    //                     XLFormRowDescriptor * buttonRow1 = [XLFormRowDescriptor formRowDescriptorWithTag:@"KFILE" rowType:XLFormRowDescriptorTypeButton title:file.FILE_NM2];
                    //                    NSLog(@"%@666666",file.FILE_NM2);
                    [buttonRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
                    buttonRow.value=file.FILE_NM2;
                    //                    _file1 = file.FILE_NM1;
                    buttonRow.action.formSelector = @selector(didTouchButton:);
                    //buttonRow.action.formSelector = @selector(openDocumentIn);
                    
                    //                    [buttonRow1.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
                    //                    buttonRow1.value=file.FILE_NM2;
                    //                    buttonRow1.action.formSelector = @selector(didTouchButton1:);
                    
                    [section addFormRow:buttonRow];
                    // [section addFormRow:buttonRow1];
                }else{
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"没有上传附件!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
        typeof(self) __weak weakSelf = self;
        LxFTPRequest *request = [LxFTPRequest downloadRequest];
        request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:@"udfile/d6820939.pdf"];
    NSLog(@"%@",request.serverURL);
        request.localFileURL = [[NSURL fileURLWithPath:NSHomeDirectory()]URLByAppendingPathComponent:@"Documents/downloadedFTPFile.pdf"];
        request.username = USERNAME;
        request.password = PASSWORD;
        request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
            
            NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", (long)totalSize, (long)finishedSize, finishedPercent);  //
            
            totalSize = MAX(totalSize, finishedSize);
            
            _progressHUD.progress = (CGFloat)finishedSize / (CGFloat)totalSize;
        };
        request.successAction = ^(Class resultClass, id result) {
            
            [_progressHUD dismissAnimated:YES];
//
//            typeof(weakSelf) __strong strongSelf = weakSelf;
//            [strongSelf showMessage:result];
            
            NSString *cachePath =[NSString stringWithFormat:@"%@/Documents/downloadedFTPFile.pdf",NSHomeDirectory()];
            _documentController =
            [UIDocumentInteractionController
             
             interactionControllerWithURL:[NSURL fileURLWithPath:cachePath]];
            
            _documentController.delegate = self;
            
            [_documentController presentOpenInMenuFromRect:CGRectZero
             
                                                    inView:self.view
             
                                                  animated:YES];
        };
        request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString * errorMessage) {
            
            [_progressHUD dismissAnimated:YES];
            NSLog(@"domain = %ld, error = %ld, errorMessage = %@", domain, (long)error, errorMessage);    //
        };
        [request start];
        
        _progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        _progressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc]init];
        _progressHUD.progress = 0;
        
        typeof(weakSelf) __strong strongSelf = weakSelf;
        [_progressHUD showInView:strongSelf.view animated:YES];

}


- (void)showMessage:(NSString *)message
{
    NSLog(@"message = %@", message);//
    
    JGProgressHUD * hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.indicatorView = nil;
    hud.textLabel.text = [message stringByAppendingString:@"文件已存在"];
    [hud showInView:self.view];
    [hud dismissAfterDelay:1];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
