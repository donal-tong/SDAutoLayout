//
//  Demo9Model.h
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

#import <Foundation/Foundation.h>

@interface Demo9Model : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *picNamesArray;
@property (nonatomic, strong) NSMutableArray *replyArray;
@property (nonatomic) float replyHeight;
@property (nonatomic, strong) NSMutableArray *favorArray;
@property (nonatomic,assign) BOOL isFavour;
@end
