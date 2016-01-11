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
    
    [self.contentView addSubview:_contentLabel];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 6;
    
    _contentLabel.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, 0)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:0];
    
}

- (void)setModel:(NSString *)model
{
    _model = model;
    
    _contentLabel.text = model;
    
}

@end
