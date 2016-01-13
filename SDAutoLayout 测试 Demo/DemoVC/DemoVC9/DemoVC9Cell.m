//
//  DemoVC9Cell.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "DemoVC9Cell.h"

#import "Demo9Model.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SDWeiXinPhotoContainerView.h"

#define kReplyTableViewCellId @"replytableviewcell"

@implementation DemoVC9Cell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UIView *_videoView;
    UIImageView *_videoCoverImageView;
    UIImageView *_videoPlayImageView;
    UIView *_urlView;
    UIImageView *_urlCoverImageView;
    UILabel *_urlTitleLable;
    UILabel *_timeLabel;
    UILabel *_favorLabel;
    UITableView *_replayTableView;
    UIButton *_moreButton;
    
    UIButton *_moreFavorButton;
    UIButton *_moreReplyButton;
    UIView *_moreSeperatorView;
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
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _videoView =  [UIView new];
    _videoView.backgroundColor = [UIColor blueColor];
    _videoCoverImageView = [UIImageView new];
    _videoPlayImageView = [UIImageView new];
    _videoPlayImageView.image = [UIImage imageNamed:@"icon_vidoe_play"];
    _urlView = [UIView new];
    _urlView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
    _urlCoverImageView = [UIImageView new];
    _urlTitleLable = [UILabel new];
    _urlTitleLable.font = [UIFont systemFontOfSize:15];
    _urlTitleLable.numberOfLines = 2;
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    _moreButton = [UIButton new];
    [_moreButton setImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(didClickMore:) forControlEvents:UIControlEventTouchUpInside];
    
    _moreView = [UIView new];
    _moreView.backgroundColor = [UIColor colorWithRed:76/255.0 green:81/255.0 blue:84/255.0 alpha:1.0];
    _moreView.hidden = YES;
    _moreView.layer.cornerRadius = 5;
    _moreView.layer.masksToBounds = YES;
    
    _moreFavorButton = [UIButton new];
    [_moreFavorButton setImage:[UIImage imageNamed:@"more_favor"] forState:UIControlStateNormal];
    [_moreFavorButton setTitle:@"赞" forState:UIControlStateNormal];
    [_moreFavorButton setTitle:@"取消赞" forState:UIControlStateSelected];
    _moreFavorButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_moreFavorButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -2.5, 0.0, 0.0)];
    [_moreFavorButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 2.5, 0.0, 0.0)];
    [_moreFavorButton addTarget:self action:@selector(didClickMoreFavor:) forControlEvents:UIControlEventTouchUpInside];
    
    _moreReplyButton = [UIButton new];
    [_moreReplyButton setImage:[UIImage imageNamed:@"more_reply"] forState:UIControlStateNormal];
    [_moreReplyButton setTitle:@"评论" forState:UIControlStateNormal];
    _moreReplyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_moreReplyButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -2.5, 0.0, 0.0)];
    [_moreReplyButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 2.5, 0.0, 0.0)];
    [_moreReplyButton addTarget:self action:@selector(didClickMoreReply:) forControlEvents:UIControlEventTouchUpInside];
    
    _moreSeperatorView = [UIView new];
    _moreSeperatorView.backgroundColor = [UIColor colorWithRed:55/255.0 green:61/255.0 blue:64/255.0 alpha:1.0];
    
    _favorLabel = [UILabel new];
    [_favorLabel setLayoutMargins:UIEdgeInsetsMake(5, 0, 5, 0)];
    _favorLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _favorLabel.textColor = [UIColor colorWithRed:87/255.0 green:107/255.0 blue:149/255.0 alpha:1.0];
    _favorLabel.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
    _replayTableView = [UITableView new];
    _replayTableView.tableHeaderView = nil;
    _replayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _replayTableView.scrollEnabled = NO;
    _replayTableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
    _replayTableView.delegate = self;
    _replayTableView.dataSource = self;
   
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _picContainerView, _videoView, _urlView, _timeLabel, _moreButton, _favorLabel, _replayTableView, _moreView];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *contentView = self.contentView;
    CGFloat margin = kContentMargin;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(kAvatarSize)
    .heightIs(kAvatarSize);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);
    
    _videoView.sd_layout
    .leftEqualToView(_contentLabel)
    .widthIs([UIScreen mainScreen].bounds.size.width > 320 ? 195 : 195)
    .heightIs([UIScreen mainScreen].bounds.size.width > 320 ? 195 : 195);
    
    NSArray *videoViews = @[_videoCoverImageView, _videoPlayImageView];
    [videoViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_videoView addSubview:obj];
    }];
    _videoCoverImageView.sd_layout
    .widthIs([UIScreen mainScreen].bounds.size.width > 320 ? 195 : 195)
    .heightIs([UIScreen mainScreen].bounds.size.width > 320 ? 195 : 195);
    
    _videoPlayImageView.sd_layout
    .widthIs(50)
    .heightIs(50)
    .centerYEqualToView(_videoView)
    .centerXEqualToView(_videoView);
    
    _urlView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView, margin)
    .heightIs(50);
    
    NSArray *urlViews = @[_urlCoverImageView, _urlTitleLable];
    [urlViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_urlView addSubview:obj];
    }];
    _urlCoverImageView.sd_layout
    .leftSpaceToView(_urlView, 5)
    .centerYEqualToView(_urlView)
    .widthIs(40)
    .heightIs(40);
    
    _urlTitleLable.sd_layout
    .leftSpaceToView(_urlCoverImageView, 5)
    .rightSpaceToView(_urlView, 5)
    .centerYEqualToView(_urlView)
    .heightIs(40)
    ;
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(20)
    ;
    
    _moreButton.sd_layout
    .rightSpaceToView(contentView, 0)
    .heightIs(30)
    .widthIs(50);
    
    _moreView.sd_layout
    .widthIs(180)
    .heightIs(39)
    .rightSpaceToView(_moreButton, -10)
    ;
    NSArray *moreViews = @[_moreReplyButton, _moreFavorButton, _moreSeperatorView];
    [moreViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_moreView addSubview:obj];
    }];
    _moreSeperatorView.sd_layout
    .centerXEqualToView(_moreView)
    .centerYEqualToView(_moreView)
    .heightIs(24)
    .widthIs(1);
    
    _moreFavorButton.sd_layout
    .centerYEqualToView(_moreView)
    .heightIs(34)
    .widthIs(70)
    .leftSpaceToView(_moreView, margin)
    .rightSpaceToView(_moreSeperatorView, margin);
    
    _moreReplyButton.sd_layout
    .centerYEqualToView(_moreView)
    .heightIs(34)
    .widthIs(70)
    .leftSpaceToView(_moreSeperatorView, margin)
    .rightSpaceToView(_moreView, margin);
    
    _favorLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_timeLabel, margin + 5)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _replayTableView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(_favorLabel, -1)
    .heightIs(300);
    [_replayTableView registerClass:[ReplyTableViewCell class] forCellReuseIdentifier:@"reply"];
    [self setupAutoHeightWithBottomView:_replayTableView bottomMargin:margin];
}


- (void)setModel:(Demo9Model *)model
{
    _model = model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.iconName]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    _nameLable.text = model.name;
    _contentLabel.text = model.content;
    _picContainerView.picPathStringsArray = model.picNamesArray;
    if ([model.type isEqualToString:@"txt"]) {
        _picContainerView.sd_layout.topSpaceToView(_contentLabel, kContentMargin);
        _timeLabel.sd_layout
        .topSpaceToView(_picContainerView, kContentMargin);
        _moreButton.sd_layout
        .topSpaceToView(_picContainerView, kContentMargin/2);
        _moreView.sd_layout
        .topSpaceToView(_picContainerView, 3);
        _urlView.hidden = YES;
        _videoView.hidden = YES;
    }
    else if ([model.type isEqualToString:@"video"]){
        _videoView.sd_layout.topSpaceToView(_contentLabel, kContentMargin);
        _timeLabel.sd_layout
        .topSpaceToView(_videoView, kContentMargin);
        _moreButton.sd_layout
        .topSpaceToView(_videoView, kContentMargin/2);
        _moreView.sd_layout
        .topSpaceToView(_videoView, 3);
        _urlView.hidden = YES;
        _videoView.hidden = NO;
        [_videoCoverImageView sd_setImageWithURL:[NSURL URLWithString:model.picNamesArray[0]]
                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    else {
        _urlView.sd_layout.topSpaceToView(_contentLabel, kContentMargin);
        _timeLabel.sd_layout
        .topSpaceToView(_urlView, kContentMargin);
        _moreButton.sd_layout
        .topSpaceToView(_urlView, kContentMargin/2);
        _moreView.sd_layout
        .topSpaceToView(_urlView, 3);
        _videoView.hidden = YES;
        _urlView.hidden = NO;
        [_urlCoverImageView sd_setImageWithURL:[NSURL URLWithString:model.picNamesArray[0]]
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        _urlTitleLable.text = model.content;
    }
    _moreView.hidden = YES;
    _timeLabel.text = @"1分钟前";
    if (model.favorArray.count > 0) {
        NSString *favorString = [model.favorArray componentsJoinedByString:@","];
        _favorLabel.text = favorString;
    }
    else {
        _favorLabel.text = @"";
    }
    _moreFavorButton.selected = _model.isFavour;
     _replayTableView.sd_layout.heightIs(model.replyHeight);
    [_replayTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [_replayTableView startAutoCellHeightWithCellClass:[ReplyTableViewCell class] contentViewWidth:tableView.width];
    
    return _model.replyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"reply";
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = _model.replyArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath model:_model.replyArray[indexPath.row] keyPath:@"model"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate replyTimeline:_model atIndex:_row atCommentIndex:indexPath.row];
}

-(void)didClickMore:(id)sender
{
    [self.delegate showMoreView:_row fromCell:self];
}

-(void)didClickMoreFavor:(id)sender
{
    _moreView.hidden = !_moreView.hidden;
    [self.delegate favorTimeline:_model];
}

-(void)didClickMoreReply:(id)sender
{
    _moreView.hidden = !_moreView.hidden;
    [self.delegate replyTimeline:_model];
}
@end
