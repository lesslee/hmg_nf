//
//  ProuctTableViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ProuctTableViewController.h"
#import "HMG_TYPE_PRODUCT.h"
#import "SoapHelper.h"
#import "UIView+XLFormAdditions.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Prouct.h"
#import "Common.h"
#import "AppDelegate.h"
#import "ProductViewCell.h"
#import "Brand1.h"
#import "Prouct+Additions.h"
#import "ProuctViewController.h"
#import "prouctSection.h"
#import "LYChooseTool.h"
ASIHTTPRequest *request;
@interface ProuctTableViewController ()
@property (nonatomic) UIView * mapView;
//@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;
//产品集合
@property (nonatomic ,strong) NSMutableArray  *productArray1;
@property(nonatomic, strong)NSString *prouctId;
@end

@implementation ProuctTableViewController
@synthesize rowDescriptor = _rowDescriptor;

BOOL setting;
//bool canBack=YES;
UITableView *tableView;
NSArray *indexPaths;
NSArray *indexPaths1;
NSArray *indexPaths2;
NSString *prouctname1;
NSString *prouctId;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.productArray1 = [[NSMutableArray alloc]init];
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 65)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.dataSource=self;
    tableView.delegate=self;
    
    [self.serviceHelper startQueue];
    
    [self Product];
    
    tableView.allowsMultipleSelectionDuringEditing=YES;
    [tableView setEditing:YES]; //设置uitableview为编辑状态
   }

-(void) Product
{
    [self readNSUserDefaults];
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        HMG_TYPE_PRODUCT *param=[[HMG_TYPE_PRODUCT alloc] init];
        param.IN_TYPE_ID = self.prouctId;
        NSLog(@"%@,%@",param.IN_TYPE_ID , self.prouctId);
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        [self.serviceHelper resetQueue];
        request=[ServiceHelper commonSharedRequestMethod:@"HMG_TYPE_PRODUCT" soapMessage:paramXml];
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_TYPE_PRODUCT",@"name", nil]];
        [self.serviceHelper addRequestQueue:request];
        [self.serviceHelper startQueue];
    }
}

-(void)readNSUserDefaults{
    //NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //NSString *myString = [userDefaultes stringForKey:@"_productId"];
    self.prouctId = self.productModel1.ID;
    NSLog(@"%@",self.prouctId);
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.serviceHelper) {
        self.serviceHelper = [[ServiceHelper alloc]initWithDelegate:self];
    }
    
    [self.navigationItem setTitle:@"产品"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];

    [self.navigationController setNavigationBarHidden:NO];
    
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductViewCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    }
    
    cell.layer.masksToBounds=YES;
    
    
   
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray1.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductViewCell *tempCell = (ProductViewCell *)cell;
    Prouct *prouctModel =(Prouct *) [self.productArray1 objectAtIndex:indexPath.row];
    tempCell.ProductName.text = prouctModel.PROD_NM;
    
   // NSString *prouctID = prouctModel.PROD_ID;
    
   }

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Prouct *prouctName= (Prouct *)[_productArray1 objectAtIndex:indexPath.row];
    
    prouctname1 = prouctName.PROD_NM;
    prouctId = prouctName.PROD_ID;
    
    NSLog(@"%@",prouctname1);
    NSLog(@"%@",prouctId);
    
    [_productModel1.prouctArray addObject:prouctName];
    
    //同时还有一个属性保存了你当前选择的indexPath集合
    indexPaths =[tableView indexPathsForSelectedRows];
    
    NSLog(@"%lu",(unsigned long)indexPaths.count);
  
}

-(void)submit{
    
    [self.navigationController popViewControllerAnimated:YES];
  
}
#pragma mark 服务器请求结果

-(void) finishQueueComplete
{
    
}

-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
    //NSLog(@"---------------------------------");
    //NSLog(@"%@",error.localizedFailureReason);
//    [HUDManager hide];
//        [self.navigationController popViewControllerAnimated:YES];
    

}

//请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    /**查询产品**/
    if ([@"HMG_TYPE_PRODUCT" isEqualToString:[dic objectForKey:@"name"]]) {
        
        Prouct *tempStore=[[Prouct alloc] init];
        
       [self.productArray1 addObjectsFromArray:[tempStore searchNodeToArray:xml nodeName:@"NewDataSet"]];
        [tableView reloadData];
        [HUDManager hide];
    }
}

@end

