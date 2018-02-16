//
//  UIImage+ColorAtPixel.h
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/16.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorAtPixel)

/**
 *  获取当前点的颜色
 *
 *  @param point 当前点
 *
 *  @return 颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

@end
