//
//  PicViewController.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/16.
//  Copyright © 2015年 liyanqin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PhotoStackView.h"


@interface PicViewController : UIViewController<PhotoStackViewDataSource, PhotoStackViewDelegate>
@property (weak, nonatomic) IBOutlet PhotoStackView *photoStack;//图片浏览器
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *AddPicBtn;
- (IBAction)clickAddPic:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBtn;
- (IBAction)clickDelete:(id)sender;

@property (nonatomic,strong) NSArray *RZ_imageArr;
@end
