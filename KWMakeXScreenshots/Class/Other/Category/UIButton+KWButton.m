//
//  UIButton+KWButton.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/17.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "UIButton+KWButton.h"

@implementation UIButton (KWButton)

+ (UIButton *) buttonWithImage:(UIImage *)image hightImage:(UIImage *)hightImage target:( id)target action:(SEL)action {
    //按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:hightImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    return btn;
}


@end
