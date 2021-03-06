//
//  DemoVC9Cell.h
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

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ReplyTableViewCell.h"
#define kAvatarSize 42
#define kContentMargin 10
@class Demo9Model;
@class DemoVC9Cell;
@protocol DemoVC9CellDelegate <NSObject>
-(void)showMoreView:(NSInteger)row fromCell:(DemoVC9Cell *)cell;
-(void)favorTimeline:(Demo9Model *)model;
-(void)replyTimeline:(Demo9Model *)model;
-(void)replyTimeline:(Demo9Model *)model atIndex:(NSInteger)index atCommentIndex:(NSInteger)row;

@end

@interface DemoVC9Cell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Demo9Model *model;
@property (nonatomic, assign) id<DemoVC9CellDelegate> delegate;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) UIView *moreView;
@end
