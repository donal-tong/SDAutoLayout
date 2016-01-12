//
//  DemoVC9.h
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
#import "XHMessageInputView.h"
@interface DemoVC9 : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, readwrite) XHInputViewType textViewInputViewType;
/**
 *  用于显示发送消息类型控制的工具条，在底部
 */
@property (nonatomic, weak, readonly) XHMessageInputView *messageInputView;

/**
 *  记录旧的textView contentSize Heigth
 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;

/**
 *  记录键盘的高度，为了适配iPad和iPhone
 */
@property (nonatomic, assign) CGFloat keyboardViewHeight;

/**
 *  是否允许手势关闭键盘，默认是允许
 */
@property (nonatomic, assign) BOOL allowsPanToDismissKeyboard; // default is YES
@end
