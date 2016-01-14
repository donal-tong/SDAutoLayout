//
//  ReplyTableViewCell.m
//  SDAutoLayout 测试 Demo
//
//  Created by Donal Tong on 16/1/10.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "UIView+SDAutoLayout.h"



@implementation ReplyTableViewCell
{
    UILabel *_contentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
    _contentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_contentLabel];
    
    UIView *contentView = self.contentView;
    CGFloat margin = kReplyLabelMargin;
    
    _contentLabel.sd_layout
    .leftSpaceToView(contentView, margin/2)
    .topSpaceToView(contentView, margin/2)
    .rightSpaceToView(contentView, margin/2)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:margin/2];
    
}

- (void)setModel:(NSString *)model
{
    _model = model;
    
    _contentLabel.text = model;
    
}

@end
