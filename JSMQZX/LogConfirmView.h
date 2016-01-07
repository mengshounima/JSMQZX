//
//  LogConfirmView.h
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/6.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LogConfirmDelegate <NSObject>
    -(void)clickSend;
    -(void)clickCanceled;
@end


@interface LogConfirmView : UIView
//+(instancetype)initConfirmView;
-(void)updateView:(NSDictionary *)infoDic;
@property (nonatomic,weak) id <LogConfirmDelegate> delegate;
@end
