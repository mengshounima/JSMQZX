//
//  RootVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/6.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MinQinRiZhiTableVC.h"
@interface RootVC : UIViewController
- (IBAction)clickminqingrizhi:(id)sender;
- (IBAction)clickrizhibanli:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *ganbuView;
@property (weak, nonatomic) IBOutlet UIView *yonghuView;

@end
