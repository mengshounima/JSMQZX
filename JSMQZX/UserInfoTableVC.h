//
//  UserInfoTableVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "modifyPasswordView.h"

@interface UserInfoTableVC : UITableViewController<modifyPasswordViewDelegate>
// 蒙版
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) modifyPasswordView *modifyView;


@end
