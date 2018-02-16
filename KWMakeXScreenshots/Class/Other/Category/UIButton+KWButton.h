//
//  UIButton+KWButton.h
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/17.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (KWButton)

+ (UIButton *) buttonWithImage:(UIImage *)image hightImage:(UIImage *)hightImage target:( id)target action:(SEL)action;

@end
