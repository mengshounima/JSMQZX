//
//  HMTitleButton.m
//  黑马微博
//
//  Created by apple on 14-7-4.
//  Copyright (c) 2014年 heima. All rights reserved.
//
#define imagePercent 0.7
#import "HMTitleButton.h"

@implementation HMTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内部图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        
        // 文字对齐
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
       
        self.titleLabel.adjustsFontSizeToFitWidth  = YES;
        // 文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 字体
        // 高亮的时候不需要调整内部的图片为灰色
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

/**
 *  设置内部图标的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = self.height*imagePercent;
    CGFloat imageH = self.height*imagePercent;
    CGFloat imageX = (self.width - imageW)/2;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

/**
 *  设置内部文字的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = self.height*imagePercent;
    CGFloat titleX = 0;
    CGFloat titleH = self.height*imagePercent;
    CGFloat titleW = self.width;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
