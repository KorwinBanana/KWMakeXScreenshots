//
//  KWQuestionViewCell.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/27.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWQuestionViewCell.h"

@interface KWQuestionViewCell()

@end

@implementation KWQuestionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _questionLabel.font = [UIFont boldSystemFontOfSize:17];
    _answerLabel.font = [UIFont systemFontOfSize:15];
//    _questionLabel.backgroundColor = [UIColor redColor];
//    _answarLabel.backgroundColor = [UIColor blueColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
