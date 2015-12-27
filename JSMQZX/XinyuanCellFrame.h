//
//  XinyuanCellFrame.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/27.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XinyuanCellFrame : NSObject

@property (nonatomic, assign, readonly) CGRect contentF;

@property (nonatomic, assign, readonly) CGRect finisheF;
@property (nonatomic, assign, readonly) CGRect dateF;

@property (nonatomic, copy) NSString *contentStr;


/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

- (void)HeightSetMethod;

@end
