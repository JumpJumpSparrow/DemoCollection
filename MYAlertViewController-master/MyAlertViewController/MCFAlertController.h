//
//  MCFAlertController.h
//  MyAlertViewController
//
//  Created by MCF on 16/11/8.
//  Copyright © 2016年 MCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCFAlertAction : UIAlertAction

@property (nonatomic,strong) UIColor *textColor; /**< 按钮title字体颜色 */
@end

@interface MCFAlertController : UIAlertController

@property (nonatomic,strong) UIColor *tintColor; /**< 统一按钮样式 不写系统默认的蓝色 */
@property (nonatomic,strong) UIColor *titleColor; /**< 标题的颜色 */
@property (nonatomic,strong) UIColor *messageColor; /**< 信息的颜色 */

@end
