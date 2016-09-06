//
//  Brand1TableViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Brand1TableViewController.h"
#import "Brand1.h"
#import "Brand1+Additions.h"
#import <Foundation/Foundation.h>
#import "ProuctTableViewController.h"
@interface CPCell : UITableViewCell

@property (nonatomic) UILabel * ID;
@property (nonatomic) UILabel * NAME;

@end

@implementation CPCell

@synthesize ID = _ID;
@synthesize NAME  = _NAME;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.contentView addSubview:self.ID];
        [self.contentView addSubview:self.NAME];
        
        [self.contentView addConstraints:[self layoutConstraints]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}


#pragma mark - Views

-(UILabel *)ID
{
    if (_ID) return _ID;
    _ID = [UILabel new];
    [_ID setTranslatesAutoresizingMaskIntoConstraints:NO];
    _ID.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
    
    return _ID;
}

-(UILabel *)NAME
{
    if (_NAME) return _NAME;
    _NAME = [UILabel new];
    [_NAME setTranslatesAutoresizingMaskIntoConstraints:NO];
    _NAME.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
    
    return _NAME;
}

#pragma mark - Layout Constraints

-(NSArray *)layoutConstraints{
    
    NSMutableArray * result = [NSMutableArray array];
    
    NSDictionary * views = @{ @"id": self.ID,
                              @"name": self.NAME};
    
    
    NSDictionary *metrics = @{@"imgSize":@50.0,
                              @"margin" :@12.0};
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[id(imgSize)]-[name]"
                                                                        options:NSLayoutFormatAlignAllTop
                                                                        metrics:metrics
                                                                          views:views]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[id(imgSize)]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
    return result;
}


@end
@interface Brand1TableViewController ()


@property(nonatomic, strong)NSString *productId;

@property(nonatomic, strong)NSString *prouctName;

@end
@implementation Brand1TableViewController

@synthesize rowDescriptor = __rowDescriptor;
@synthesize popoverController = __popoverController;


static NSString *const kCellIdentifier = @"CellIdentifier";

NSArray *array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    // Enable the pagination
    self.loadingPagingEnabled = NO;
    
    // Support Search Controller
    self.supportSearchController = NO;
    
    [self customizeAppearance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    array =[NSArray arrayWithObjects:
            [[Brand1 alloc] initWithID:@"100023" andNAME:@"U-ZA系列"],
            [[Brand1 alloc] initWithID:@"100024" andNAME:@"Denti系列"],
            [[Brand1 alloc] initWithID:@"100031" andNAME:@"Phyll"],
            [[Brand1 alloc] initWithID:@"100028" andNAME:@"TGM"],
            [[Brand1 alloc] initWithID:@"100045" andNAME:@"Godis"],
            [[Brand1 alloc] initWithID:@"100046" andNAME:@"EDISON"],
            [[Brand1 alloc] initWithID:@"100013" andNAME:@"BBD"],
            
            nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CPCell class] forCellReuseIdentifier:kCellIdentifier];
    [self customizeAppearance];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellId";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    Brand1 *model=(Brand1 *)[array objectAtIndex:indexPath.row];
    cell.textLabel.text=model.NAME;
    
    cell.accessoryType = [[self.rowDescriptor.value formValue] isEqual:model.ID] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    }
    else
    {
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    cell.layer.masksToBounds=YES;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Brand1 *model=(Brand1 *)[array objectAtIndex:indexPath.row];
    
    self.rowDescriptor.value=model;
    
    _productId = model.ID;
    NSLog(@"%@--",_productId);
    
    _prouctName = model.NAME;
    
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
        [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
    }
    else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self saveNSUserDefaults];
}

//保存数据到nsuserdefaults
-(void) saveNSUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_productId forKey:@"_productId"];
    NSLog(@"%@===",_productId);
    [userDefaults synchronize];
}

//保存数据到nsuserdefaults
-(void) saveNSUserDefaults1{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_prouctName forKey:@"_prouctName"];
    NSLog(@"%@===",_prouctName);
    [userDefaults synchronize];
}

-(BOOL)loadingPagingEnabled
{
    return NO;
}

//禁用刷新控件
-(UIRefreshControl *)refreshControl
{
    return nil;
}

#pragma mark - Helpers

-(void)customizeAppearance
{
    [[self navigationItem] setTitle:@"品牌"];
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}
@end