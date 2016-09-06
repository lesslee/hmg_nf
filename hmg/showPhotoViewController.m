//
//  showPhotoViewController.m
//  hmg
//
//  Created by hongxianyu on 2016/8/16.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "showPhotoViewController.h"

@interface showPhotoViewController ()
@property(nonatomic,strong)UIImage *savedImage1;
@end

@implementation showPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height-150)];
    
    [imageView setImage:_savedImage1];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
}
-(void)passTrendValues:(UIImage *)values{
    _savedImage1 = values;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
