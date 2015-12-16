//
//  RootVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/6.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MinQinRiZhiTableVC.h"
#import "LogBanliGanbuTable.h"
@interface RootVC : UIViewController
- (IBAction)clickminqingrizhi:(id)sender;
- (IBAction)clickrizhibanli:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *ganbuView;
@property (weak, nonatomic) IBOutlet UIView *yonghuView;
@property (weak, nonatomic) IBOutlet UIView *guanliyuanView;


- (IBAction)clickGanbuZaizhidangyuan:(id)sender;
- (IBAction)clickGanbuRizhibanli:(id)sender;
- (IBAction)clickGanbuMinshendongtai:(id)sender;
- (IBAction)clickGanbuFenxiyanpan:(id)sender;

- (IBAction)clickGanliyuanRizhibanli:(id)sender;
- (IBAction)clickGuanliyuanZaizhidangyuan:(id)sender;
- (IBAction)clickGaunliyuanMinshendongtai:(id)sender;
- (IBAction)clickGuanliyuanFuwu:(id)sender;
- (IBAction)clickGaunliyuanWeixinyuan:(id)sender;

- (IBAction)clickGaunliyuanDangdaibiao:(id)sender;
- (IBAction)clickGaunliyuanFenxi:(id)sender;
- (IBAction)clickGaunliyuanHongyun:(id)sender;



@end
