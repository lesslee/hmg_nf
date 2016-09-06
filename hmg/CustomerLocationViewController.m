//
//  CustomerLocationViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/5/24.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "CustomerLocationViewController.h"
#import "XLForm.h"
#import "AgentTableViewController.h"
#import "StoreTableViewController.h"
#import "HMG_CUSTOMER_LOCATION.h"
#import "AppDelegate.h"
#import "Store.h"
#import "Agent.h"
#import "SoapHelper.h"
#import "Common.h"
#import "CommonResult.h"
#import "MenuViewController.h"
#import "JKImagePickerController.h"
#import "LxFTPRequest.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "CustomButton.h"
static NSString * const FTP_ADDRESS = @"ftp://118.102.25.43:21";
static NSString * const USERNAME = @"hmg";
static NSString * const PASSWORD = @"hmg6102";
static NSString *const  customerLocationPhotoPath = @"/../../.././data/htdocs/hmg/customer/";
@interface CustomerLocationViewController ()
{
    JGProgressHUD * _progressHUD;

    BOOL isFullScreen;
    UIImage *image;
   // NSString *imagePath;
}
@property (nonatomic,strong)BMKLocationService *locService;


@property (nonatomic) double  LON;//精度
@property (nonatomic) double  LAT;//纬度

@property(nonatomic, strong)NSString *LON1;
@property(nonatomic, strong)NSString *LAT1;
@end
//门店或经销商
NSString *const kSelectorStore2 = @"selectorStore";
//拜访类型
NSString *const kSwitchBool2= @"switchBool";

@implementation CustomerLocationViewController
XLFormDescriptor * formDescriptor;
XLFormSectionDescriptor * section;
XLFormRowDescriptor * row;
UIImageView *imgview;
//NSString *customerLocationPhotoPath;
NSString *photoName;
//ServiceHelper *serviceHelper;
NSString *str1;
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
    
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"考勤"];
    
    section=[XLFormSectionDescriptor formSection];
    
    [formDescriptor addFormSection:section];
    
    row=[XLFormRowDescriptor formRowDescriptorWithTag:kSwitchBool2 rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"门店 ｜ 经销商"];
    [section addFormRow:row];
    
    //添加监听
    [row addObserver:self forKeyPath:@"value" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorStore2 rowType:XLFormRowDescriptorTypeSelectorPush title:@"门店"];
    row.selectorControllerClass = [StoreTableViewController class];
    [section addFormRow:row];
    
    self.form = formDescriptor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    [self initauto];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    self.navigationItem.title=@"信息采集";
    
    //[self.navigationController.navigationBar.backItem setTitle:@""];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(locationback)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(upload)];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    if (![CLLocationManager locationServicesEnabled]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"定位服务可能尚未打开，请设置打开！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }

    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    
    [_locService startUserLocationService];
    
    _locService.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放

    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
}

-(void)initauto{
    
    
    self.tableView.scrollEnabled = NO;
    
    [self.view addSubview:self.tableView];
    
    imgview=[[UIImageView alloc] init];
    imgview.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:imgview];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [button setTitle:@"拍照" forState:UIControlStateNormal];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(composePicAdd1) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *views=NSDictionaryOfVariableBindings(imgview,button);
    
    NSArray *formatStrings=@[@"V:|-130-[imgview]-2-[button(==40)]-2-|",
                             
                            @"H:|-10-[imgview]-10-|",
                             
                            @"H:|-10-[button]-10-|"
                             
                             ];
    for (NSString *formatString in formatStrings) {
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatString options:0 metrics:nil views:views]];
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    _locService.delegate = nil;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    double lat = userLocation.location.coordinate.latitude;
    double lon = userLocation.location.coordinate.longitude;
    _LAT1 = [NSString stringWithFormat:@"%f",lat];
    _LON1 = [NSString stringWithFormat:@"%f",lon];
  
    NSLog(@"纬度:%@,经度:%@",_LAT1,_LON1);

}


/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
    NSLog(@"location error");
}




- (void)composePicAdd1
{
    if ([self.form formRowWithTag:kSelectorStore2].value == nil) {
        [HUDManager showMessage:@"请先选择门店或经销商" duration:1];
    } else {
        //先设定sourceType为相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        //[self presentModalViewController:picker animated:YES];
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }
        [self presentViewController:picker animated:YES completion:^{}];

    }
    
   }


#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
   
    // 保存图片至本地，方法见下文
    photoName = [NSString stringWithFormat:@"IMG_%d.png",arc4random()%10000];
    
    [self saveImage:image WithName:photoName];
   
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:photoName];
   
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    NSLog(@"%@============年-月-日  时：分：秒=====================",DateTime);
    if ([[self.form formRowWithTag:kSwitchBool2].value intValue] == 0){
        Store *str = [self.form formRowWithTag:kSelectorStore2].value;
        NSString *str3 = str.STORE_NM;
        UIImage *waterImage = [self waterMarkImage:savedImage withText:DateTime withText1:str3];
        UIImageWriteToSavedPhotosAlbum(waterImage, nil, nil, nil); //保存图片至相册
        
        imgview.image = waterImage;
        [self.view addSubview:imgview];
    
    }else{
        Agent *str = [self.form formRowWithTag:kSelectorStore2].value;
        NSString *str3 = str.AGENT_NM;
        UIImage *waterImage = [self waterMarkImage:savedImage withText:DateTime withText1:str3];
        UIImageWriteToSavedPhotosAlbum(waterImage, nil, nil, nil); //保存图片至相册
        
        imgview.image = waterImage;
        [self.view addSubview:imgview];
    
    }
    
    
}

    //[imgview setImage:savedImage];
   
    



- (UIImage *)waterMarkImage:(UIImage *)image withText:(NSString *)text withText1:(NSString *)text1
{
    UIGraphicsBeginImageContext(CGSizeMake(1600, 1200)); // 在画布中绘制内容
    [image drawInRect:CGRectMake(0, 0, 1600, 1200)];
    
    CGRect rect = CGRectMake(20, 660, 1600, 100);
    CGRect rect1 = CGRectMake(10, 860, 1600, 100);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:80], NSForegroundColorAttributeName : [UIColor redColor]}; //这里设置了字体，和颜色
    
    [text drawInRect:rect withAttributes:dic];
    [text1 drawInRect:rect1 withAttributes:dic];
    // 从画布中得到image
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
 
    [self dismissViewControllerAnimated:YES completion:^{}];
   
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // 图片的沙盒里的路径
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//重写键值监听方法，切换门店与经销商
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL value=[[change objectForKey:@"new"] boolValue];
    XLFormRowDescriptor *switchRow=[self.form formRowWithTag:kSelectorStore2];
    if (!value) {
        
        switchRow.title=@"门店";
        switchRow.selectorControllerClass=[StoreTableViewController class];
    }
    else
    {
        switchRow.title=@"经销商";
        switchRow.selectorControllerClass=[AgentTableViewController class];
    }
    
    switchRow.value=nil;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void) locationback {
    [self.serviceHelper resetQueue];
    //移除kvo
    
    [HUDManager hide];
    [[self.form formRowWithTag:kSwitchBool2] removeObserver:self forKeyPath:@"value" context:nil];

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

}

-(void)upload{
    [_locService stopUserLocationService];

    if (_LAT1 == 0 || _LON1 == 0) {
        [HUDManager showMessage:@"定位失败!" duration:1];
    }else{

    if (![self.form formRowWithTag:kSelectorStore2].value) {
        [HUDManager showMessage:@"请选择门店或经销商" duration:1];
    }else{
    
    __block NSString *fileNM1,*fileNM2;
    
    fileNM1=@"";
    fileNM2=@"";
    
   __block NSString *imagePath=nil;
   __block NSString *imageName=nil;
    
    NSString *tmpName=[self renamePhoto];
   
    imageName = photoName;
        if (imageName == nil) {
            [HUDManager showMessage:@"请先拍照之后上传!" duration:1];
        } else {
            imagePath=[customerLocationPhotoPath stringByAppendingString:photoName];
            NSLog(@"%@",imagePath);
            typeof(self) __weak weakSelf = self;
            LxFTPRequest * request = [LxFTPRequest uploadRequest];
            request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:imagePath];
            NSString *localFilePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),imageName];
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
                
                fileNM1=[fileNM1 stringByAppendingString:[NSString stringWithFormat:@"%@",imageName]];
                
                fileNM2=[fileNM2 stringByAppendingString:[NSString stringWithFormat:@"%@",tmpName]];
                [self communicateServiceWithFILE_NM1:fileNM1 andFILE_NM2:fileNM2];
                [self deleteFile:photoName];
            };
            request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString * errorMessage) {
                
                [_progressHUD dismissAnimated:YES];
                [HUDManager showMessage:@"上传ftp失败" duration:1];
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
    }
}
//FTP上传成功后，数据库中关联照片信息
-(void) communicateServiceWithFILE_NM1:(NSString *) FILE_NM1 andFILE_NM2:(NSString *) FILE_NM2{
    
        Common *common=[[Common alloc] initWithView:self.view];
        
        if (common.isConnectionAvailable) {
            
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            
            HMG_CUSTOMER_LOCATION *param=[[HMG_CUSTOMER_LOCATION alloc] init];
            param.IN_FILE_NM1 = FILE_NM1;
            NSLog(@"%@",param.IN_FILE_NM1);
            
            param.IN_FILE_NM2 = FILE_NM2;
            NSLog(@"%@",param.IN_FILE_NM2);
            param.IN_SABEON=appDelegate.userInfo.EMP_NO;
            NSLog(@"%@",param.IN_SABEON);
           
            param.IN_GPS_LAT=self.LAT1;
            NSLog(@"%@",param.IN_GPS_LAT);
            param.IN_GPS_LON=self.LON1;
            NSLog(@"%@",param.IN_GPS_LON);
            if ([[self.form formRowWithTag:kSwitchBool2].value intValue] == 0) {
                Store *tmpStore= [self.form formRowWithTag:kSelectorStore2].value;
                param.IN_CUSTOMER_ID=tmpStore.STORE_ID;
                param.IN_CUSTOMER_TYPE = @"S";
                NSLog(@"%@,%@",param.IN_CUSTOMER_ID,param.IN_CUSTOMER_TYPE);
            }else
            {
                Agent *tmpAgent= [self.form formRowWithTag:kSelectorStore2].value;
                param.IN_CUSTOMER_ID=tmpAgent.AGENT_ID;
                param.IN_CUSTOMER_TYPE = @"A";
                NSLog(@"%@,%@",param.IN_CUSTOMER_ID,param.IN_CUSTOMER_TYPE);
            }
           
            NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
            
            [self.serviceHelper resetQueue];
            
            ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_CUSTOMER_LOCATION" soapMessage:paramXml];
            [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_CUSTOMER_LOCATION",@"name", nil]];
            [self.serviceHelper addRequestQueue:request1];
            
            [self.serviceHelper startQueue];
        }
   
    
}

//照片重命名(日期格式化命名)
-(NSString *) renamePhoto
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyyMdd";
    NSString *photoName=[NSString stringWithFormat:@"%@%d.jpg",[formatter stringFromDate:[NSDate date]],arc4random()%10000];
    
    return photoName;
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
    if ([@"HMG_CUSTOMER_LOCATION" isEqualToString:[dic objectForKey:@"name"]]) {
        CommonResult *result=[[CommonResult alloc] init];
        NSMutableArray *array =[[NSMutableArray alloc] init];
        [array addObjectsFromArray:[result searchNodeToArray:xml nodeName:@"NewDataSet"]];
        
        if ([result.OUT_RESULT isEqualToString:@"0"]) {
            [HUDManager showSuccessWithMessage:@"上传成功" duration:1 complection:^{
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
        }
        else
        {
            [HUDManager showSuccessWithMessage:result.OUT_RESULT_NM duration:1 complection:^{
                NSLog(@"%@",result.OUT_RESULT_NM);
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
        }
    }
}


@end
