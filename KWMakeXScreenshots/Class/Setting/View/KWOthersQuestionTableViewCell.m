//
//  KWOthersQuestionTableViewCell.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/27.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWOthersQuestionTableViewCell.h"
#import <MLEmojiLabel/MLEmojiLabel.h>

@interface KWOthersQuestionTableViewCell()<MLEmojiLabelDelegate>

@property(nonatomic,strong)MLEmojiLabel *answerLabel2;

@end

@implementation KWOthersQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titlLabel.font = [UIFont boldSystemFontOfSize:17];
    _answerLabel.font = [UIFont systemFontOfSize:15];
    _answerLabel.text = @"如果以上的问题并没有包括您遇到的情况，请您发送邮件到korwin.zhang@gmail.com来反馈问题。\n";
    _answerLabel2 = [[MLEmojiLabel alloc]initWithFrame:self.answerLabel.frame];
    [self addSubview:_answerLabel2];
    _answerLabel2.numberOfLines = 0;
    _answerLabel2.font = [UIFont systemFontOfSize:15.0f];
    _answerLabel2.delegate = self;
    _answerLabel2.textAlignment = NSTextAlignmentLeft;
    _answerLabel2.backgroundColor = [UIColor clearColor];
    _answerLabel2.isNeedAtAndPoundSign = YES;
    //        _emojiLabel1.disableThreeCommon = YES;
    //        _emojiLabel1.disableEmoji = YES;
    
    _answerLabel2.text = @"如果以上的问题并没有包括您遇到的情况，请您发送邮件到korwin.zhang@gmail.com来反馈问题。\n";
    //测试TTT原生方法
    [_answerLabel2 addLinkToURL:[NSURL URLWithString:@"http://sasasadan.com"] withRange:[_answerLabel.text rangeOfString:@"TableView"]];
    
    //这句测试剪切板
    [_answerLabel2 performSelector:@selector(copy:) withObject:nil afterDelay:0.01f];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}

@end
