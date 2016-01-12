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

@interface DemoVC9 () <DemoVC9CellDelegate, XHMessageInputViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentRow;
}
@property (nonatomic, strong) NSMutableArray *modelsArray;
@end

@implementation DemoVC9
{
    SDRefreshFooterView *_refreshFooter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置键盘通知或者手势控制键盘消失
    self.allowsPanToDismissKeyboard = NO;
    [self.tableView setupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    
    [self.messageInputView.inputTextView setEditable:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    if (self.textViewInputViewType != XHInputViewTypeNormal) {
//        [self layoutOtherMenuViewHiden:YES];
//    }
    
    // remove键盘通知或者手势
    [self.tableView disSetupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // remove KVO
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [self.messageInputView.inputTextView setEditable:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    ;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    [self initialization];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initialization
{
    WEAKSELF
    if (self.allowsPanToDismissKeyboard) {
        // 控制输入工具条的位置块
        void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
            inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
        
        self.tableView.keyboardDidScrollToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.tableView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.tableView.keyboardWillBeDismissed = ^() {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
    }
    
    // block回调键盘通知
    self.tableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyboard) {
        if (weakSelf.textViewInputViewType == XHInputViewTypeText) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 NSLog(@"%i", showKeyboard);
                                 CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                                 
                                 CGRect inputViewFrame = weakSelf.messageInputView.frame;
                                 CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                                 
                                 // for ipad modal form presentations
                                 CGFloat messageViewFrameBottom = weakSelf.view.frame.size.height - inputViewFrame.size.height;
                                 if (inputViewFrameY > messageViewFrameBottom)
                                     inputViewFrameY = messageViewFrameBottom;
                                 
                                 weakSelf.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                              inputViewFrameY,
                                                                              inputViewFrame.size.width,
                                                                              inputViewFrame.size.height);
                                 
                                 //                                 [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                 //                                  - weakSelf.messageInputView.frame.origin.y];
                                 //                                 if (showKeyboard)
                                 //                                     [weakSelf scrollToBottomAnimated:NO];
                             }
                             completion:nil];
        }
    };
    self.tableView.keyboardDidChange = ^(BOOL didShowed) {
        if ([weakSelf.messageInputView.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (weakSelf.textViewInputViewType == XHInputViewTypeText) {
                    //                    weakSelf.shareMenuView.alpha = 0.0;
                    //                    weakSelf.emotionManagerView.alpha = 0.0;
                }
            }
        }
    };
    
    self.tableView.keyboardDidHide = ^() {
        [weakSelf.messageInputView.inputTextView resignFirstResponder];
    };
    
    // 设置Message TableView 的bottom edg
    CGFloat inputViewHeight =  45.0f;
    // 输入工具条的frame
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);
    // 初始化输入工具条
    XHMessageInputView *inputView = [[XHMessageInputView alloc] initWithFrame:inputFrame];
    inputView.allowsSendFace = YES;
    inputView.allowsSendVoice = NO;
    inputView.allowsSendMultiMedia = NO;
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [self.view bringSubviewToFront:inputView];
    
    _messageInputView = inputView;
    _messageInputView.hidden = YES;
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
    [self.tableView startAutoCellHeightWithCellClass:[DemoVC9Cell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
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
//    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
//    return h;
    return [self.tableView cellHeightForIndexPath:indexPath model:self.modelsArray[indexPath.row] keyPath:@"model"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.messageInputView.hidden = YES;
    [self.messageInputView.inputTextView resignFirstResponder];
}

#pragma mark - scrollview delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    DemoVC9Cell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]];
    cell.moreView.hidden = YES;
    self.messageInputView.hidden = YES;
    [self.messageInputView.inputTextView resignFirstResponder];
}

#pragma mark - cell delegate
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
    self.messageInputView.hidden = NO;
    [self.messageInputView.inputTextView becomeFirstResponder];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+([UIScreen mainScreen].bounds.size.height - self.messageInputView.top)) animated:NO];
}

-(void)showMoreView:(NSInteger)row
{
    if (!self.messageInputView.hidden) {
        self.messageInputView.hidden = YES;
        [self.messageInputView.inputTextView resignFirstResponder];
        return;
    }
    if (currentRow > -1 && currentRow != row) {
        DemoVC9Cell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]];
        cell.moreView.hidden = YES;
    }
    currentRow = row;
    
//    DemoVC9Cell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]];
    
}

#pragma mark - UITextView Helper Method

- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout Message Input View Helper Method

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [XHMessageInputView maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.tableView.contentInset.bottom + changeInHeight];
                             
//                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark message input delegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView {
    self.textViewInputViewType = XHInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView {
    if (!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

//- (void)didChangeSendVoiceAction:(BOOL)changed {
//    if (changed) {
//        if (self.textViewInputViewType == XHInputViewTypeText)
//            return;
//        // 在这之前，textViewInputViewType已经不是XHTextViewTextInputType
//        [self layoutOtherMenuViewHiden:YES];
//    }
//}
//
//- (void)didSendTextAction:(NSString *)text {
//    DLog(@"text : %@", text);
//    if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
//        [self.delegate didSendText:text fromSender:self.messageSender onDate:[NSDate date]];
//    }
//}
//
//- (void)didSelectedMultipleMediaAction {
//    DLog(@"didSelectedMultipleMediaAction");
//    self.textViewInputViewType = XHInputViewTypeShareMenu;
//    [self layoutOtherMenuViewHiden:NO];
//}
//
//- (void)didSendFaceAction:(BOOL)sendFace {
//    if (sendFace) {
//        self.textViewInputViewType = XHInputViewTypeEmotion;
//        [self layoutOtherMenuViewHiden:NO];
//    } else {
//        [self.messageInputView.inputTextView becomeFirstResponder];
//    }
//}
//
//- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion {
//    DLog(@"prepareRecordingWithCompletion");
//    [self prepareRecordWithCompletion:completion];
//}
//
//- (void)didStartRecordingVoiceAction {
//    DLog(@"didStartRecordingVoice");
//    [self startRecord];
//}
//
//- (void)didCancelRecordingVoiceAction {
//    DLog(@"didCancelRecordingVoice");
//    [self cancelRecord];
//}
//
//- (void)didFinishRecoingVoiceAction {
//    DLog(@"didFinishRecoingVoice");
//    if (self.isMaxTimeStop == NO) {
//        [self finishRecorded];
//    } else {
//        self.isMaxTimeStop = NO;
//    }
//}
//
//- (void)didDragOutsideAction {
//    DLog(@"didDragOutsideAction");
//    [self resumeRecord];
//}
//
//- (void)didDragInsideAction {
//    DLog(@"didDragInsideAction");
//    [self pauseRecord];
//}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark - Key-value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.messageInputView.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}


@end
