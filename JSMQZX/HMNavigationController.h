//
//  HMNavigationController.h
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "modifyPasswordView.h"
@interface HMNavigationController : UINavigationController<modifyPasswordViewDelegate>
// 蒙版
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) modifyPasswordView *modifyView;
@end
