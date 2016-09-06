//
//  ReportDetailViewController.m
//  hmg
//
//  Created by Lee on 15/4/14.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "notifyViewDetailController.h"
#import "SoapHelper.h"
#import "HMG_BOARD_DETAIL.h"
#import "notifyDetailModel.h"
#import "Common.h"
#import "ASINetworkQueue.h"
#import "HMG_BOARD_ATTACHMENT.h"
#import "NotifyViewController.h"
#import "NotifyModel.h"
#import "Board_attchment.h"
#import "ASIHTTPRequest.h"
#import "AFNetworking.h"
@interface notifyViewDetailController ()<ASIProgressDelegate,UIWebViewDelegate>
@property(nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic,strong) UIProgressView *progress;
@property (nonatomic,strong)NSMutableData *connectionData;

@property (nonatomic,strong)NSURLConnection *connection;

@property (nonatomic,strong)NSString *contentValue;
@property (nonatomic, strong)UIWebView *webview;

@property (nonatomic,strong) NSURLSession *session;
@end

ASIHTTPRequest *request;
NSString *const KBOARD_ID = @"KBOARD_ID";
NSString *const KSEQ = @"KSEQ";
NSString *const KSUBJECT = @"KSUBJECT";
NSString *const KWRITE_DATE = @"KWRITE_DATE";
NSString *const KWRITER_ID = @"KWRITER_ID";
NSString *const KWRITER_NAME = @"KWRITER_NAME";
NSString *const KCONTENT = @"KCONTENT";
NSString *const kOUT_RESULT_NM = @"KOUT_RESULT_NM";
NSString *const KATTCHMENT = @"KATTCHMENT";
NSString *const kFILE = @"KFILE";

@implementation notifyViewDetailController

XLFormDescriptor *formDescriptor;
XLFormSectionDescriptor *section;
XLFormRowDescriptor *row;
NSArray *attchmentArray;
NSString *url;
NSString *file;
NSString *contentValue;
NSString *subject;
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
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.scrollEnabled = NO;
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    [HUDManager showMessage:@"加载内容"];
    
    [self BoardDetailInfo];
    [self.view addSubview:[self webView]];
}

- (UIWebView *)webView
{
    if (!_webview) {
        _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 218, self.view.frame.size.width, self.view.frame.size.height - 280)];
        _webview.dataDetectorTypes = UIDataDetectorTypeAll;
        _webview.backgroundColor = [UIColor whiteColor];
        //self.webview.scalesPageToFit = YES;
    }
    return _webview;
}

//- (UIWebView *)webView1
//{
//    if (!_webview) {
//        _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 265)];
//        _webview.dataDetectorTypes = UIDataDetectorTypeAll;
//        _webview.backgroundColor = [UIColor whiteColor];
//        //self.webview.scalesPageToFit = YES;
//    }
//    return _webview;
//}



-(void) BoardDetailInfo
{
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        HMG_BOARD_DETAIL *param=[[HMG_BOARD_DETAIL alloc] init];
        
        param.IN_BOARD_ID = self.boardId;
        param.IN_SEQ = self.seq;
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        [self.serviceHelper resetQueue];
        request=[ServiceHelper commonSharedRequestMethod:@"HMG_BOARD_DETAIL" soapMessage:paramXml];
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_BOARD_DETAIL",@"name", nil]];
        [self.serviceHelper addRequestQueue:request];
        [self.serviceHelper startQueue];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title=@"公告明细";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
}

-(void) goBack
{
    [request clearDelegatesAndCancel];
    [self.serviceHelper resetQueue];
    self.serviceHelper=nil;
    [HUDManager hide];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initializeForm
{
    
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"公告"];
    
    section=[XLFormSectionDescriptor formSection];
    
    
    [formDescriptor addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KSUBJECT rowType:XLFormRowDescriptorTypeText title:@""];
    row.disabled=YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KWRITE_DATE rowType:XLFormRowDescriptorTypeText title:@"发布时间:"];
    row.disabled=YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KWRITER_NAME rowType:XLFormRowDescriptorTypeName title:@"发布者:"];
    row.disabled = YES;
    [section addFormRow:row];
    
    
    self.form = formDescriptor;
    
}

#pragma 服务代理
-(void) finishQueueComplete
{
    
}

//- (NSString *)dooo
//{
//
//    NSLog(@"------");
//    NSString * str= contentValue;
//
//  return  [self flattenHTML:str];
//
//}
//
//
//- (NSString *)flattenHTML:(NSString *)html {
//
//    NSScanner *theScanner;
//    NSString *text = nil;
//    NSString * regEx = @"&nbsp";
//    NSString * re = @";";
//
//    theScanner = [NSScanner scannerWithString:html];
//
//    while ([theScanner isAtEnd] == NO) {
//        // find start of tag
//        [theScanner scanUpToString:@"<" intoString:NULL] ;
//
//        // find end of tag
//        [theScanner scanUpToString:@">" intoString:&text] ;
//                // replace the found tag with a space
//        //(you can filter multi-spaces out later if you wish)
//        html = [html stringByReplacingOccurrencesOfString:
//                [NSString stringWithFormat:@"%@>", text]
//                                               withString:@""];
//    } // while //
//
//    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
//    NSLog(@"-----===%@",html);
//    html = [html stringByReplacingOccurrencesOfString:re withString:@""];
//    NSLog(@"-----===%@",html);
//
//    return html;
//}



//解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    @try {
        if ([@"HMG_BOARD_DETAIL" isEqualToString:[dic objectForKey:@"name"]]) {
            notifyDetailModel *model1=[[notifyDetailModel alloc] init];
            NSMutableArray *array =[[NSMutableArray alloc] init];
            [array addObjectsFromArray:[model1 searchNodeToArray:xml nodeName:@"NewDataSet"]];
            
            
            XLFormRowDescriptor *row2=[self.form formRowWithTag:KWRITE_DATE];
            row2.value=model1.WRITE_DATE;
            
            NSLog(@"%@00000----",model1.WRITE_DATE);
            [self reloadFormRow:row2];
            
            row2 = [formDescriptor formRowWithTag:KSUBJECT];
            row2.value = model1.SUBJECT;
            [self reloadFormRow:row2];
            
            row2=[formDescriptor formRowWithTag:KWRITER_NAME];
            row2.value=model1.WRITER_NAME;
            [self reloadFormRow:row2];
            
            contentValue = model1.CONTENT;
            [self.webview loadHTMLString:contentValue baseURL:nil];
            
            
            
            HMG_BOARD_ATTACHMENT *param=[[HMG_BOARD_ATTACHMENT alloc] init];
            param.IN_BOARD_ID=model1.BOARD_ID;
            param.IN_SEQ = model1.SEQ;
            
            NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
            
            request=[ServiceHelper commonSharedRequestMethod:@"HMG_BOARD_ATTACHMENT" soapMessage:paramXml];
            [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_BOARD_ATTACHMENT",@"name", nil]];
            
            
            [self.serviceHelper addRequestQueue:request];
            
            [self.serviceHelper startQueue];
        }
        if ([@"HMG_BOARD_ATTACHMENT" isEqualToString:[dic objectForKey:@"name"]]) {
            
            Board_attchment *tempAttchement=[[Board_attchment alloc] init];
            attchmentArray =[tempAttchement searchNodeToArray:xml nodeName:@"NewDataSet"];
            
            for (Board_attchment *attchment in attchmentArray) {
                NSLog(@"%@",attchment.FILENAME);
                NSLog(@"%@",attchment.DOWNLOAD_URL);
                file = attchment.FILENAME;
                url =  attchment.DOWNLOAD_URL;
                if(attchment.FILENAME!=nil)
                {
                    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"kFILE" rowType:XLFormRowDescriptorTypeButton title:attchment.FILENAME];
                    [buttonRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
                    //buttonRow.value = attchment.FILENAME;
                    buttonRow.action.formSelector = @selector(didTouchButton:);
                    
                    [section addFormRow:buttonRow];
                }else{
                    XLFormRowDescriptor * buttonRow1 = [XLFormRowDescriptor formRowDescriptorWithTag:@"kFILE" rowType:XLFormRowDescriptorTypeButton title:@"没有附件信息"];
                    
                    NSLog(@"%@",buttonRow1);
                    [section addFormRow:buttonRow1];
                    
                    //                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"没有附件!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    //                    [alertView show];
                }
                
            }
            [self.tableView reloadData];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@%@",[exception name],[exception reason]);
    } @finally {
        [HUDManager hide];
    }
}


-(void)didTouchButton:(XLFormRowDescriptor *)sender{
    
    [HUDManager showMessage:@"正在下载" duration:1];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:1 timeoutInterval:6];
    [[manger downloadTaskWithRequest:request progress:NULL destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:sender.title];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSLog(@"%@1-1",url);
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [HUDManager hide];
        
        NSString *cachePath =[NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),sender.title];
        NSLog(@"%@1-2",cachePath);
        _documentController =
        [UIDocumentInteractionController
         
         interactionControllerWithURL:[NSURL fileURLWithPath:cachePath]];
        _documentController.delegate = self;
        
        [_documentController presentOpenInMenuFromRect:CGRectZero
         
                                                inView:self.view
         
                                              animated:YES];
        
        NSLog(@"%@",error.localizedDescription);
    }]resume];
    
}



-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
