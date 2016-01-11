//
//  DemoVC9.m
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

#import "DemoVC9.h"
#import "UIView+SDAutoLayout.h"
#import "Demo9Model.h"
#import "DemoVC9Cell.h"

#import "DemoVC9HeaderView.h"


#import "SDRefresh.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#define kDemoVC9CellId @"demovc9cell"

@interface DemoVC9 () <DemoVC9CellDelegate>
{
    NSInteger currentRow;
}
@property (nonatomic, strong) NSMutableArray *modelsArray;

@end

@implementation DemoVC9
{
    SDRefreshFooterView *_refreshFooter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.tableView.estimatedRowHeight = 100;
    
    [self creatModelsWithCount:10];
    
    __weak typeof(self) weakSelf = self;
    
    // 上拉加载
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    _refreshFooter.beginRefreshingOperation = ^() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf creatModelsWithCount:10];
            [weakSelf.tableView reloadData];
            [weakRefreshFooter endRefreshing];
        });
    };
    
    DemoVC9HeaderView *headerView = [DemoVC9HeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 260);
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[DemoVC9Cell class] forCellReuseIdentifier:kDemoVC9CellId];
}

- (void)creatModelsWithCount:(NSInteger)count
{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray new];
    }
    
    NSArray *iconImageNamesArray = @[@"http://ww3.sinaimg.cn/bmiddle/707da080gw1ezu8afswndj20ku0kutcq.jpg",
                                     @"http://ww3.sinaimg.cn/bmiddle/707da080gw1ezu8agg5dqj20ku0kutcf.jpg",
                                     @"http://ww4.sinaimg.cn/bmiddle/5669bca6gw1ezu74jq8m0j20bq0bqtb1.jpg",
                                     @"http://ww1.sinaimg.cn/bmiddle/5669bca6gw1ezu74pwrmuj20c80c8jtt.jpg",
                                     @"http://ww4.sinaimg.cn/square/5669bca6gw1ezu74ueqahj20c80c8got.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *picImageNamesArray = @[ @"http://ww4.sinaimg.cn/square/5669bca6gw1ezu74ueqahj20c80c8got.jpg",
                                     @"http://ww1.sinaimg.cn/bmiddle/5669bca6gw1ezu74pwrmuj20c80c8jtt.jpg",
                                     @"http://ww4.sinaimg.cn/bmiddle/5669bca6gw1ezu74jq8m0j20bq0bqtb1.jpg",
                                     @"http://ww4.sinaimg.cn/bmiddle/5669bca6gw1ezu74s3zh6j20c80c841v.jpg",
                                     @"http://ww4.sinaimg.cn/bmiddle/5669bca6gw1ezu74ueqahj20c80c8got.jpg",
                                     @"http://ww1.sinaimg.cn/bmiddle/63918611gw1ezr77ahlb8j20h90cxgoc.jpg",
                                     @"http://ww1.sinaimg.cn/bmiddle/005uZMZqgw1ezrv4vfmmoj30jk09aaaq.jpg",
                                     @"http://ww1.sinaimg.cn/bmiddle/68147f68gw1eztm2fqd11j209404aaaa.jpg",
                                     @"http://ww1.sinaimg.cn/bmiddle/b254dc71gw1ezsc317z72j20h80a8q4q.jpg"
                                     ];
    
    NSArray *replyArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        Demo9Model *model = [Demo9Model new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.content = textArray[contentRandomIndex];
        
        
        // 模拟“随机图片”
        int random = arc4random_uniform(10);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.picNamesArray = [temp copy];
            model.type = @"txt";
        }
        else {
            model.type = @"video";
            model.picNamesArray = @[@"http://ww3.sinaimg.cn/bmiddle/707da080gw1ezu8agg5dqj20ku0kutcf.jpg"];
        }
        
        // 模拟“评论”
        int random1 = arc4random_uniform(5);
        
        NSMutableArray *temp1 = [NSMutableArray new];
        for (int i = 0; i < random1; i++) {
            int randomIndex = arc4random_uniform(4);
            [temp1 addObject:replyArray[randomIndex]];
        }
        if (temp1.count) {
            model.replyArray = [temp1 copy];
        }
        CGFloat h = 0;
        for (NSString *txt in model.replyArray) {
            h += ([self getViewHeightWithUIFont:[UIFont systemFontOfSize:15] andText:txt andFixedWidth:([UIScreen mainScreen].bounds.size.width-30-42)] + 6);
        }
        model.replyHeight = h;
        
        // 模拟“点赞”
        model.favorArray = [NSMutableArray new];
        int random2 = arc4random_uniform(5);
        
        NSMutableArray *temp2 = [NSMutableArray new];
        for (int i = 0; i < random2; i++) {
            int randomIndex = arc4random_uniform(4);
            [temp2 addObject:namesArray[randomIndex]];
        }
        if (temp2.count) {
            [model.favorArray addObjectsFromArray:temp2];
        }
        
        [self.modelsArray addObject:model];
    }
}

-(CGFloat)getViewHeightWithUIFont:(UIFont *)font andText:(NSString *)txt andFixedWidth:(int)width
{
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGRect rect       = [txt boundingRectWithSize:constraint
                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName: font}
                                          context:nil];
    return rect.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoVC9Cell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoVC9CellId];
    cell.model = self.modelsArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.row = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    DemoVC9Cell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]];
    cell.moreView.hidden = YES;
//    self.tableView ce
}

#pragma mark cell delegate
-(void)favorTimeline:(Demo9Model *)model
{
    if (model.isFavour) {
        [model.favorArray removeObject:@"小明"];
    }
    else {
        [model.favorArray addObject:@"小明"];
    }
    model.isFavour = !model.isFavour;
    [self.tableView reloadData];
//    self.view.sd_layout.updateLayout;
}

-(void)replyTimeline:(Demo9Model *)model
{
    
}

-(void)showMoreView:(NSInteger)row
{
    currentRow = row;
}

@end
