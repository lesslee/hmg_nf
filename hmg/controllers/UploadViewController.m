    //
    //  UploadViewController.m
    //  hmg
    //
    //  Created by Lee on 15/5/19.
    //  Copyright (c) 2015年 com.lz. All rights reserved.
    //
#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#import "UploadViewController.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"
#import "MBProgressHUDManager.h"
#import "HMG_UPLOAD_PHOTO.h"
#import "SoapHelper.h"
#import "AppDelegate.h"
#import "CommonResult.h"
#import "LxFTPRequest.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "AddReportViewController.h"
#import "showPhotoViewController.h"
static NSString * const FTP_ADDRESS = @"ftp://118.102.25.43:21";
static NSString * const USERNAME = @"hmg";
static NSString * const PASSWORD = @"hmg6102";
static NSString * const SUB_PATH=@"/../../.././file/temp/";
@interface UploadViewController ()<JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>{
    
        //NSURL *phot;
    
    NSString *time1;
    
    NSString *StoreOrAgent;
    
    JGProgressHUD * _progressHUD;
    UIImage *waterImage;
    
    NSString *photoName1;
    
    UIImage *image1;
    NSMutableArray *photoArry;
    NSMutableArray *tempArr;
}

@property (nonatomic, retain) UICollectionView *collectionView;

    //@property (nonatomic, strong) NSMutableArray   *assetsArray;

@end

@implementation UploadViewController

NSMutableArray   *assetsArray;
UIImageView *imageView;
    //图片路径
NSString *photofilepath;
NSString *photofilepath1;

    //前一天
NSDate *lastDay;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",time1);
    NSLog(@"%@",StoreOrAgent);
    
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    imageView.frame = CGRectMake(0, 0, 300, 400);
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.dateFormat=@"yyyyMd";
    
    lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]];
        //ftp上照片存储路径
    photofilepath=[NSString stringWithFormat:@"/../../.././file/temp/%@/",[fmt stringFromDate:[NSDate date]]];
    
    photofilepath1 = [NSString stringWithFormat:@"/../../.././file/temp/%@/",[fmt stringFromDate:lastDay]];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
    UIImage  *img = [UIImage imageNamed:@"compose_pic_add"];
    UIButton   *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-img.size.width/2, 400, img.size.width, img.size.height);
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


- (UIImage *)waterMarkImage:(UIImage *)image withText:(NSString *)text withText1:(NSString *)text1
{
    UIGraphicsBeginImageContext(CGSizeMake(image1.size.width, image1.size.height)); // 在画布中绘制内容
    [image drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    CGRect rect = CGRectMake(20, image1.size.height-180, image1.size.width - 40, 90);
    CGRect rect1 = CGRectMake(20, image1.size.height-100 , image1.size.width - 40, 50);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:36], NSForegroundColorAttributeName : [UIColor redColor]}; //这里设置了字体，和颜色
    
    [text drawInRect:rect withAttributes:dic];
    [text1 drawInRect:rect1 withAttributes:dic];
        // 从画布中得到image
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}



-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"上传照片"];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadPhoto)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
        //self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    
    [self.navigationController setNavigationBarHidden:NO];
}

    //返回主菜单
-(void) goBack
{
    if (assetsArray.count>0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"确定放弃此次编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [assetsArray removeAllObjects];
        
    }else
        {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}


- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

    //对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark 保存图片到document
- (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
        // 图片的沙盒里的路径
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    return fullPathToFile;
}


-(void)deleteFile:(NSString *)imageName {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
        //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

-(void)deletePhoto{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileListArray = [fileManager contentsOfDirectoryAtPath:kDocument_Folder error:nil];
    for (NSString *file in fileListArray)
        {
        NSString *path = [kDocument_Folder stringByAppendingPathComponent:file];
        NSString *extension = [path pathExtension];
        if (([extension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame))
            {
            [fileManager removeItemAtPath:path error:nil];
            }
        
        }
    NSLog(@"清空了");
}

    //上传照片
-(void) uploadPhoto
{
    if(assetsArray.count>0)
        {
        
        
        @try {
            __block NSString *fileSeq,*fileNM1,*fileNM2;
            
            fileSeq=@"";
            fileNM1=@"";
            fileNM2=@"";
            
            for (int i = 0; i < assetsArray.count; i++) {
                
                __block NSString *imagePath=nil;
                __block NSString *imagePath1=nil;
                
                NSString *tmpName=[self renamePhoto];
                
                imagePath=[photofilepath stringByAppendingString:[photoArry objectAtIndex:i]];
                imagePath1=[photofilepath1 stringByAppendingString:[photoArry objectAtIndex:i]];
                
                
                typeof(self) __weak weakSelf = self;
                LxFTPRequest *request = [LxFTPRequest resourceListRequest];
                if ([time1 isEqualToString:@"1"]) {
                    request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:photofilepath];
                    NSLog(@"%@00",request.serverURL);
                } else {
                    request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:photofilepath1];
                    NSLog(@"%@00",request.serverURL);
                }
                
                request.username = USERNAME;
                request.password = PASSWORD;
                request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
                    
                    NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", (long)totalSize, (long)finishedSize, finishedPercent);  //
                    
                    totalSize = MAX(totalSize, finishedSize);
                    
                        //_progressHUD.progress = (CGFloat)finishedSize / (CGFloat)totalSize;
                };
                request.successAction = ^(Class resultClass, id result) {
                    
                    [_progressHUD dismissAnimated:YES];
                    
                        //                                NSArray * resultArray = (NSArray *)result;
                        //
                        //                                typeof(weakSelf) __strong strongSelf = weakSelf;
                        //
                        //                                [strongSelf showMessage:[NSString stringWithFormat:@"%@", resultArray]];
                    
                    LxFTPRequest * request = [LxFTPRequest uploadRequest];
                    if ([time1 isEqualToString:@"1"]) {
                        request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:imagePath];
                    } else {
                        request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:imagePath1];
                    }
                    
                    
                    NSString *localFilePath = [tempArr objectAtIndex:i];
                    
                    
                    NSLog(@"%@",localFilePath);
                    
                    request.localFileURL = [NSURL fileURLWithPath:localFilePath];
                    request.username = USERNAME;
                    request.password = PASSWORD;
                    
                    request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
                        
                        NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", (long)totalSize, (long)finishedSize, finishedPercent);  //
                        
                        totalSize = MAX(totalSize, finishedSize);
                        
                        _progressHUD.progress = (CGFloat)finishedSize / (CGFloat)totalSize;
                        
                    };
                    request.successAction = ^(Class resultClass, id result) {
                        [_progressHUD dismissAnimated:YES];
                        fileSeq=[fileSeq stringByAppendingString:[NSString stringWithFormat:@"%d##",i+1]];
                        
                        fileNM1=[fileNM1 stringByAppendingString:[NSString stringWithFormat:@"%@##",tmpName] ];
                        
                        fileNM2=[fileNM2 stringByAppendingString:[NSString stringWithFormat:@"%@##",[photoArry objectAtIndex:i]]];
                        [self communicateServiceWithFILE_SEQ:fileSeq andFILE_NM1:fileNM1 andFILE_NM2:fileNM2];
                        [self deleteFile:[photoArry objectAtIndex:i]];
                        
                    };
                    request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString * errorMessage) {
                        
                        [_progressHUD dismissAnimated:YES];
                        [HUDManager showMessage:@"上传失败" duration:1];
                        NSLog(@"domain = %ld, error = %ld, errorMessage = %@", domain, (long)error, errorMessage);    //
                    };
                    [request start];
                    _progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                    _progressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc]init];
                    _progressHUD.progress = 0;
                    
                    
                        // [_progressHUD showInView:strongSelf.view animated:YES];
                    
                    
                };
                request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString * errorMessage) {
                    
                    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                    formatter.dateFormat=@"yyyyMd";
                    NSString *TODAY_PATH=[SUB_PATH stringByAppendingString:[formatter stringFromDate:[NSDate date]]];
                    
                    NSString *TODAY_PATH1=[SUB_PATH stringByAppendingString:[formatter stringFromDate:lastDay]];
                    
                    
                    NSString *photfile = [TODAY_PATH stringByAppendingString:@"/"];
                    
                    NSString *photfile1 = [TODAY_PATH1 stringByAppendingString:@"/"];
                    
                    LxFTPRequest * request = [LxFTPRequest createResourceRequest];
                    if ([time1 isEqualToString:@"1"]) {
                        request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:photfile];
                    } else {
                        request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:photfile1];
                    }
                    
                    request.username = USERNAME;
                    request.password = PASSWORD;
                    request.successAction = ^(Class resultClass, id result) {
                        LxFTPRequest * request = [LxFTPRequest uploadRequest];
                        if ([time1 isEqualToString:@"1"]) {
                            request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:imagePath];
                        } else {
                            request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:imagePath1];
                        }
                        
                        NSString *localFilePath = [tempArr objectAtIndex:i];
                            //                                NSString *localFilePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName1];
                        NSLog(@"%@",localFilePath);
                        
                        request.localFileURL = [NSURL fileURLWithPath:localFilePath];
                        request.username = USERNAME;
                        request.password = PASSWORD;
                        
                        request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
                            
                            NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", (long)totalSize, (long)finishedSize, finishedPercent);  //
                            
                            totalSize = MAX(totalSize, finishedSize);
                            
                            _progressHUD.progress = (CGFloat)finishedSize / (CGFloat)totalSize;
                            
                        };
                        request.successAction = ^(Class resultClass, id result) {
                            [_progressHUD dismissAnimated:YES];
                            fileSeq=[fileSeq stringByAppendingString:[NSString stringWithFormat:@"%d##",i+1]];
                            
                            fileNM1=[fileNM1 stringByAppendingString:[NSString stringWithFormat:@"%@##",tmpName] ];
                            
                            fileNM2=[fileNM2 stringByAppendingString:[NSString stringWithFormat:@"%@##",[photoArry objectAtIndex:i]]];
                            [self communicateServiceWithFILE_SEQ:fileSeq andFILE_NM1:fileNM1 andFILE_NM2:fileNM2];
                            [self deleteFile:[photoArry objectAtIndex:i]];
                        };
                        request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString * errorMessage) {
                            
                            [_progressHUD dismissAnimated:YES];
                            [HUDManager showMessage:@"上传失败" duration:1];
                            NSLog(@"domain = %ld, error = %ld, errorMessage = %@", domain, (long)error, errorMessage);    //
                        };
                        [request start];
                        _progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                        _progressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc]init];
                        _progressHUD.progress = 0;
                        
                        typeof(weakSelf) __strong strongSelf = weakSelf;
                        [_progressHUD showInView:strongSelf.view animated:YES];
                            //[strongSelf showMessage:result];
                    };
                    request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString * errorMessage) {
                        
                        NSLog(@"domain = %ld, error = %ld, errorMessage = %@", domain, (long)error, errorMessage);    //
                    };
                    [request start];
                    
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
            
        }
        
        @catch (NSException *exception) {
            [HUDManager showErrorWithMessage:exception.description duration:2];
        }
        @finally {
            return;
        }
        }
    
    else
        {
        [HUDManager showMessage:@"请添加照片" duration:1];
        }
    
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



    //FTP上传成功后，数据库中关联照片信息
-(void) communicateServiceWithFILE_SEQ:(NSString *) FILE_SEQ andFILE_NM1:(NSString *) FILE_NM1 andFILE_NM2:(NSString *) FILE_NM2
{
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    HMG_UPLOAD_PHOTO *param=[[HMG_UPLOAD_PHOTO alloc] init];
    param.IN_FILE_SEQ=FILE_SEQ;
    param.IN_FILE_NM1=FILE_NM1;
    param.IN_FILE_NM2=FILE_NM2;
    param.IN_FILE_PATH=photofilepath;
    param.IN_INP_USER=appDelegate.userInfo.EMP_NO;
    param.IN_REPORT_ID=self.reportId;
    
    NSLog(@"%@,%@,%@,%@,%@",param.IN_INP_USER,param.IN_REPORT_ID,FILE_SEQ,param.IN_FILE_NM1,param.IN_FILE_NM2);
    
    NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
    
    [self.serviceHelper resetQueue];
    
    ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_UPLOAD_PHOTO" soapMessage:paramXml];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_UPLOAD_PHOTO",@"name", nil]];
    [self.serviceHelper addRequestQueue:request1];
    
    [self.serviceHelper startQueue];
    
    [self deletePhoto];
}

- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.selectedAssetArray = assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}


    //照片重命名(日期格式化命名)
-(NSString *) renamePhoto
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyyMdHHmmss";
    NSString *photoName=[NSString stringWithFormat:@"%@%d.jpg",[formatter stringFromDate:[NSDate date]],arc4random()%100];
    
    return photoName;
}




#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    
    tempArr=[[NSMutableArray alloc]init];
    photoArry = [[NSMutableArray alloc]init];
    assetsArray = [NSMutableArray arrayWithArray:assets];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    NSLog(@"%@============年-月-日  时：分：秒=====================",DateTime);
    for (int i = 0; i < assetsArray.count; i++){
        
        ALAssetsLibrary *lib1 = [[ALAssetsLibrary alloc] init];
        
        JKAssets *model1 = [assetsArray objectAtIndex:i];
        [lib1 assetForURL:model1.assetPropertyURL resultBlock:^(ALAsset *asset) {
            
            if (asset) {
                ALAssetRepresentation *representaion1 = [asset defaultRepresentation];
                image1 = [UIImage imageWithCGImage:[representaion1 fullScreenImage]];
                
                waterImage =  [self waterMarkImage:image1 withText:StoreOrAgent withText1:DateTime];
                UIImageWriteToSavedPhotosAlbum(waterImage, nil, nil, nil); //保存图片至相册
                NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                    // 保存图片至沙盒
                    // photoName1 = [NSString stringWithFormat:@"IMG_%d.jpg",arc4random()%10000];
                photoName1 = [NSString stringWithFormat:@"%@_%d.jpg",[formatter stringFromDate:[NSDate date]],arc4random()%1000];
                NSLog(@"%@",photoName1);
                
                [photoArry addObject:photoName1];
                NSLog(@"%@1111-----11111111",photoArry);
                NSString *fullPath =  [self saveImage:waterImage WithName:photoName1];
                [tempArr addObject:fullPath];
                NSLog(@"%@1233-------",tempArr);
            }
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        [self.collectionView reloadData];
    }];
    
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [tempArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    UIImage *savedImage1 = [[UIImage alloc] initWithContentsOfFile:[tempArr objectAtIndex:indexPath.row]];
    
    [cell setValue:savedImage1 forKeyPath:@"imageView.image"];
    
    return cell;
}





#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 120);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    showPhotoViewController *vc = [[showPhotoViewController alloc]init];
    UIImage *savedImage1 = [[UIImage alloc] initWithContentsOfFile:[tempArr objectAtIndex:indexPath.row]];
    self.trendDelegate = vc; //设置代理
    
    [self.trendDelegate passTrendValues:savedImage1];
    NSLog(@"%@",savedImage1);
    [self.navigationController pushViewController:vc animated:YES];
        //    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        //    photoBrowser.delegate = self;
        //    photoBrowser.currentImageIndex = indexPath.row;
        //    photoBrowser.imageCount = tempArr.count;
        //    photoBrowser.sourceImagesContainerView = self.collectionView;
        //    [photoBrowser show];
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 10.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 80, CGRectGetWidth(self.view.frame)-30, 280) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = YES;
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(void) finishQueueComplete
{
    
}

-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
        //NSLog(@"---------------------------------");
        //NSLog(@"%@",error.localizedFailureReason);
        //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

    //请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    if ([@"HMG_UPLOAD_PHOTO" isEqualToString:[dic objectForKey:@"name"]]) {
        CommonResult *result=[[CommonResult alloc] init];
        NSMutableArray *array =[[NSMutableArray alloc] init];
        [array addObjectsFromArray:[result searchNodeToArray:xml nodeName:@"NewDataSet"]];
        
        if ([result.OUT_RESULT isEqualToString:@"0"]) {
            [HUDManager showSuccessWithMessage:@"图片上传成功" duration:1 complection:^{
                [assetsArray removeAllObjects];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
        }
        else
            {
            [HUDManager showSuccessWithMessage:result.OUT_RESULT_NM duration:1 complection:^{
                [assetsArray removeAllObjects];
                [self deletePhoto];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
            }
    }
}
@end