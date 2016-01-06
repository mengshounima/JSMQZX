//
//  LogConfirmView.h
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/6.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LogConfirmDelegate
    -(void)clickSend;
    -(void)clickCancel;
@end


@interface LogConfirmView : UIView
//+(instancetype)initConfirmView;
@property (nonatomic,weak) id <LogConfirmDelegate> delegate;
@end
