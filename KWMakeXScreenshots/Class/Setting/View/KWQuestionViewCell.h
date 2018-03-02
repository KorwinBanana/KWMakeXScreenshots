//
//  KWQuestionViewCell.h
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/27.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYAttributedLabel/TYAttributedLabel.h>

@interface KWQuestionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end
