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
#import "HMTitleButton.h"
#import "HongyunVC.h"
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

@property (weak, nonatomic) IBOutlet HMTitleButton *mingqingrizhi;
@property (weak, nonatomic) IBOutlet HMTitleButton *rizhibanli;

@property (weak, nonatomic) IBOutlet HMTitleButton *ganburizhibanli;
@property (weak, nonatomic) IBOutlet HMTitleButton *ganbuzaizhidangyuan;
@property (weak, nonatomic) IBOutlet HMTitleButton *ganbumingshengdongtai;
@property (weak, nonatomic) IBOutlet HMTitleButton *ganbufenxiyanpan;

@property (weak, nonatomic) IBOutlet HMTitleButton *guanlirizhibanli;
@property (weak, nonatomic) IBOutlet HMTitleButton *guanlizaizhidangyuan;
@property (weak, nonatomic) IBOutlet HMTitleButton *guanlimingshendongtai;

@property (weak, nonatomic) IBOutlet HMTitleButton *guanlizhiyuanfuwu;
@property (weak, nonatomic) IBOutlet HMTitleButton *guanliweixinyuan;
@property (weak, nonatomic) IBOutlet HMTitleButton *guanlidangdaibiao;
@property (weak, nonatomic) IBOutlet HMTitleButton *guanlifenxiyanpan;
@property (weak, nonatomic) IBOutlet HMTitleButton *guanlidangjianhongyun;




@end
