//
//  UIImage+KWGetNewImage.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/16.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "UIImage+KWGetNewImage.h"

@implementation UIImage (KWGetNewImage)

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

@end
