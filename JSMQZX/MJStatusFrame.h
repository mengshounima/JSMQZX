//
//  MJStatusFrame.h
//  04-微博
//
//  Created by apple on 14-4-1.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  这个模型对象专门用来存放cell内部所有的子控件的frame数据  + cell的高度
// 一个cell拥有一个MJStatusFrame模型

#import <Foundation/Foundation.h>

//@class MJStatus;

@interface MJStatusFrame : NSObject


@property (nonatomic, assign, readonly) CGRect HuoDongF;

@property (nonatomic, assign, readonly) CGRect DangYuanF;


@property (nonatomic, copy) NSString *huodongStr;
@property (nonatomic, copy) NSString *dangyuanStr;

/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

- (void)HeightSetMethod;
//@property (nonatomic, strong) MJStatus *status;
@end
