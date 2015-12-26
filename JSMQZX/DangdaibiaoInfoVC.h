//
//  DangdaibiaoInfoVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/26.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DangdaibiaoInfoVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) NSDictionary *infoDic;
@end
