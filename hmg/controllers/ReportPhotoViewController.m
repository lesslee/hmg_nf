//
//  ReportPhotoViewController.m
//  hmg
//
//  Created by Lee on 15/7/30.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "ReportPhotoViewController.h"
#import "ReportPhoto.h"
#import "UploadViewController.h"
#import "LxFTPRequest.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
static NSString * const FTP_ADDRESS = @"ftp://118.102.25.43:21";
static NSString * const USERNAME = @"hmg";
static NSString * const PASSWORD = @"hmg6102";
@interface ReportPhotoViewController (){
    NSString *fileName;
    NSString *date;
    JGProgressHUD * _progressHUD;
    
}
@end

@implementation ReportPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@,%@",date,fileName);
    //ftp上照片路径
    NSString *TODAY_PATH=[NSString stringWithFormat:@"/../../.././file/temp/%@/",date];
    NSLog(@"%@",TODAY_PATH);
    
    NSLog(@"%@",TODAY_PATH);
    NSString *FILENAME1 = [TODAY_PATH stringByAppendingString:fileName];
    
    typeof(self) __weak weakSelf = self;
    LxFTPRequest *request = [LxFTPRequest downloadRequest];
    request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:FILENAME1];
    NSLog(@"%@1-1",request.serverURL);
    request.localFileURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()]URLByAppendingPathComponent:fileName];
    NSLog(@"%@1-2",request.localFileURL);
    request.username = USERNAME;
    request.password = PASSWORD;
    request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
        
        NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", (long)totalSize, (long)finishedSize, finishedPercent);  //
        
        totalSize = MAX(totalSize, finishedSize);
        
        _progressHUD.progress = (CGFloat)finishedSize / (CGFloat)totalSize;
    };
    request.successAction = ^(Class resultClass, id result) {
        
        [_progressHUD dismissAnimated:YES];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@",NSTemporaryDirectory(),fileName];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height-200)];
        
        [imageView setImage:savedImage];
        self.view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:imageView];

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
