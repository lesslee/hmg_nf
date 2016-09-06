#import "CustomButton.h"

@implementation CustomButton


//更具button的rect设定并返回文本label的rect

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = contentRect.size.height;
    //NSLog(@"%f,%f",contentRect.size.width,contentRect.size.height);
    
    CGFloat titleX = 0;
    
    CGFloat titleY = 30;
    
    contentRect = (CGRect){{titleX,titleY},{titleW,titleH}};
    
    return contentRect;
    
}

//更具button的rect设定并返回UIImageView的rect

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageW = 40;
    
    CGFloat imageH = 40;
    
    CGFloat imageX = contentRect.size.width/2-20;

    CGFloat imageY = contentRect.size.height/2-30;
    
    contentRect = (CGRect){{imageX,imageY},{imageW,imageH}};
    
    return contentRect;
    
}




@end