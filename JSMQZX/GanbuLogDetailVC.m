//
//  GanbuLogDetailVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/30.
//  Copyright © 2015年 liyanqin. All rights reserved.
//
//转交办理情况列表，办理情况文本框，已办结按钮
#import "GanbuLogDetailVC.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
#import "GanbuLocationVC.h"
#define fuwuFont [UIFont systemFontOfSize:14]
@interface GanbuLogDetailVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    BOOL HasPicture;
    int f1;
    int f2;
    UITextField *textF;
    
}
@property (nonatomic,strong) NSArray *picsArr;
@property (nonatomic,strong) NSArray *BanLiJieGuoArr;
@property (nonatomic,weak) UIImageView *picImageV;


@end

@implementation GanbuLogDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"走访日志信息";
    self.view.backgroundColor = [UIColor whiteColor];
    f1 = 0;
    f2 = 0;
    [self getLogPicsAndBanliJilu];
}

-(void)getLogPicsAndBanliJilu{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:[_infoDic objectForKey:@"rz_id"] forKey:@"rz_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetMQPhotosRzID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f1= 1;
        
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *resultArr = (NSArray *)[jsonData objectFromJSONData];
        if (resultArr.count>0) {
            HasPicture = YES;
            
            //图片加载
            NSMutableArray *middleArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic  in resultArr) {
                NSString *urlStr = [dic objectForKey:@"photoUrl"];
                NSString *allURL = [NSString stringWithFormat:@"http://122.225.44.14:802/ClientPhoto/%@",urlStr];
                
                NSURL *URL = [NSURL URLWithString:allURL];
                MyLog(@"--------%@",allURL);
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:URL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                    
                    
                    NSLog(@"显示当前进度");
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    if (!ISNULL(image)) {
                        [middleArr addObject:image];
                        if (!ISNULL(middleArr)) {
                            _picsArr = [middleArr mutableCopy];
                            
                        }
                    }
                    
                    NSLog(@"下载完成");
                    
                }];
                
            }
            
        }
        else{
            HasPicture = NO;
        }
        if (f1 ==1&&f2 ==1) {
            [MBProgressHUD hideHUD];
            [self initView];
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [MBProgressHUD showError:@"请求失败"];
    }];
    
    //获取办理记录
    NSMutableDictionary *paramJilu = [[NSMutableDictionary alloc] init];
    [paramJilu setObject:idStr forKey:@"userId"];
    [paramJilu setObject:[_infoDic objectForKey:@"rz_id"] forKey:@"rz_id"];
    
    [[HttpClient httpClient] requestWithPath:@"/GetMQLogBLInfoByRZID" method:TBHttpRequestPost parameters:paramJilu prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f2 = 1;
        
        NSData* jsonData = [self XMLString:responseObject];
        _BanLiJieGuoArr = (NSArray *)[jsonData objectFromJSONData];
        if (f1 ==1&&f2 ==1) {
            [MBProgressHUD hideHUD];
            [self initView];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];

    
    
    
}
-(NSData *)XMLString:(NSData *)data
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data  options:0 error:nil];
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    NSArray *users = [rootElement children];
    GDataXMLNode  *contentNode = users[0];
    NSString *str =  contentNode.XMLString;
    NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    return  jsonData;
}
-(void)changeContentViewPosition:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.view.center = CGPointMake(self.view.center.x, keyBoardEndY - self.view.bounds.size.height/2.0);
    }];
}



-(void)initView{
    MyLog(@"%@",_infoDic);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    UIScrollView *myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    UIView *backView = [[UIView alloc] init];
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 5;
    [myScroll addSubview:backView];
    
    //ID
    UILabel *IDL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 40)];
    IDL.text = [NSString stringWithFormat:@"详细信息[编号：%@]",[_infoDic objectForKey:@"rz_id"]];
    IDL.textColor = choiceColor(16, 86, 148);
    IDL.font = [UIFont systemFontOfSize:16];
    IDL.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:IDL];
    
    float Y = CGRectGetMaxY(IDL.frame);
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line];
    
    //走访日期
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    dateL.text = [NSString stringWithFormat:@"走访日期：%@",[_infoDic objectForKey:@"rz_zfrq"]];
    dateL.font = fuwuFont;
    [backView addSubview:dateL];
    
    Y = CGRectGetMaxY(dateL.frame);
    //line
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line1];
    //走访干部
    UILabel *fuwushequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    fuwushequL.text = [NSString stringWithFormat:@"走访干部：%@",[_infoDic objectForKey:@"rz_zfrxm"]];
    fuwushequL.font = fuwuFont;
    [backView addSubview:fuwushequL];
    
    Y = CGRectGetMaxY(fuwushequL.frame);
    //line
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line2];
    
    //走访镇/街道
    UILabel *baodaoshequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    baodaoshequL.text = [NSString stringWithFormat:@"走访镇/街道：%@",[_infoDic objectForKey:@"zjd_name"]];
    baodaoshequL.font = fuwuFont;
    [backView addSubview:baodaoshequL];
    
    Y = CGRectGetMaxY(baodaoshequL.frame);
    //line
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line3];
    //走访村/社区
    UILabel *CunL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    CunL.text = [NSString stringWithFormat:@"走访村/社区：%@",[_infoDic objectForKey:@"cun_name"]];
    CunL.font = fuwuFont;
    [backView addSubview:CunL];
    
    Y = CGRectGetMaxY(CunL.frame);
    //line
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line4];
    
    //所属网格
    UILabel *wanggeL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    wanggeL.text = [NSString stringWithFormat:@"所属网格：%@",[_infoDic objectForKey:@"wg_name"]];
    wanggeL.font = fuwuFont;
    [backView addSubview:wanggeL];
    
    Y = CGRectGetMaxY(wanggeL.frame);
    //line
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line5];
    
    //走访农户
    UILabel *nonghuL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    nonghuL.text = [NSString stringWithFormat:@"走访农户：%@",[_infoDic objectForKey:@"rz_zfnh_name"]];
    nonghuL.font = fuwuFont;
    [backView addSubview:nonghuL];
    
    Y = CGRectGetMaxY(nonghuL.frame);
    //line
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line6];
    
    //民情概况
    UILabel *gaikuangL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, 80, 20)];
    
    gaikuangL.text = @"民情概况：";
    //[NSString stringWithFormat:@"民情概况：%@",[_infoDic objectForKey:@"rz_mqgk"]];
    gaikuangL.font = fuwuFont;
    [backView addSubview:gaikuangL];
    
    //太阳图案
    NSString *mqgk = [_infoDic objectForKey:@"rz_mqgk"];
    UIImageView *gkImageV = [[UIImageView alloc] initWithFrame:CGRectMake(88, Y+1, 20, 20)];
    if ([mqgk isEqualToString:@"1"]) {
        gkImageV.image = [UIImage imageNamed:@"晴天"];
    }
    else if ([mqgk isEqualToString:@"2"]) {
        gkImageV.image = [UIImage imageNamed:@"多云"];
    }
    else if ([mqgk isEqualToString:@"3"]) {
        gkImageV.image = [UIImage imageNamed:@"阴天"];
    }
    else{
        gkImageV.image = [UIImage imageNamed:@"下雨"];
    }
    [backView addSubview:gkImageV];

    
    Y = CGRectGetMaxY(gkImageV.frame);
    //line
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line7.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line7];
    
    //民生类别
    UILabel *leibieL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    NSString *leibeiStr = [_infoDic objectForKey:@"rz_mqlb_name"];
    if (ISNULLSTR(leibeiStr)) {
        leibieL.text = @"民生类别：";
    }
    else{
        leibieL.text = [NSString stringWithFormat:@"民生类别：%@",leibeiStr];
    }
    
    leibieL.font = fuwuFont;
    [backView addSubview:leibieL];
    
    Y = CGRectGetMaxY(leibieL.frame);
    //line
    UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line8.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line8];
    
    
    //民生需求
    NSString *needStr = [_infoDic objectForKey:@"rz_msxq"];
    if (ISNULLSTR(needStr)) {
        needStr = @"民生需求：";
    }
    else{
        needStr = [NSString stringWithFormat:@"民生需求：%@",needStr];
    }
    
    CGSize contentRect = [self sizeWithText:needStr font:fuwuFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    UILabel *needL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y, SCREEN_WIDTH-36, contentRect.height)];
    needL.text = needStr;
    needL.font = fuwuFont;
    needL.numberOfLines = 0;
    
    [backView addSubview:needL];
    
    Y = CGRectGetMaxY(needL.frame);
    //line
    UIView *line9 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line9.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line9];
    
    //填写日期
    UILabel *tianxieL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    tianxieL.text = [NSString stringWithFormat:@"填写日期：%@",[_infoDic objectForKey:@"rz_txrq"]];
    tianxieL.font = fuwuFont;
    [backView addSubview:tianxieL];
    
    Y = CGRectGetMaxY(tianxieL.frame);
    //line
    UIView *line10 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line10.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line10];
    
    //办理结果
    UILabel *jieguoL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    NSString *jieguoFlag = [_infoDic objectForKey:@"rz_zjbljg"];//1.已办理 2.未办理 3.无诉求
    if ([jieguoFlag isEqualToString:@"1"]) {
        jieguoL.text = @"办理结果：已办理";
    }
    else if ([jieguoFlag isEqualToString:@"2"]) {
        jieguoL.text = @"办理结果：提交镇一级处理";
    }
    else{
        jieguoL.text = @"办理结果：无诉求";
    }
    jieguoL.font = fuwuFont;
    [backView addSubview:jieguoL];
    
    Y = CGRectGetMaxY(jieguoL.frame);
    //line
    UIView *line11 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line11.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line11];
    
    //转交日期
    UILabel *zhuanjiaoL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    zhuanjiaoL.text = [NSString stringWithFormat:@"转交日期：%@",[_infoDic objectForKey:@"rz_zjblsj"]];
    
    zhuanjiaoL.font = fuwuFont;
    [backView addSubview:zhuanjiaoL];
    
    Y = CGRectGetMaxY(zhuanjiaoL.frame);
    //line
    UIView *line12 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line12.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line12];
    
    //照片
    UIView *PicV = [[UIView alloc] initWithFrame:CGRectMake(0, Y+1, SCREEN_WIDTH-20, 40)];
    [backView addSubview:PicV];
    UILabel *picL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 70, 40)];
    picL.text = @"附加照片";
    picL.font = fuwuFont;
    [PicV addSubview:picL];
    
    UIButton *picBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 2, 36, 36)];
    [picBtn setImage:[UIImage imageNamed:@"照片"]  forState:UIControlStateNormal];
    
    if (HasPicture) {
        picBtn.enabled = YES;
        [picBtn addTarget:self action:@selector(LookPics:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        picBtn.enabled = NO;
    }
    
    [PicV addSubview:picBtn];//透明，盖在上面
    
    Y = CGRectGetMaxY(PicV.frame);
    
    //line
    UIView *line13 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line13.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line13];
    
    //位置
    UIView *LocationV = [[UIView alloc] initWithFrame:CGRectMake(0, Y+1, SCREEN_WIDTH-20, 40)];
    [backView addSubview:LocationV];
    UILabel *LocationL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 70, 40)];
    LocationL.text = @"日志位置";
    LocationL.font = fuwuFont;
    [LocationV addSubview:LocationL];
    UIButton *LocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 2, 36, 36)];
    [LocationBtn setImage:[UIImage imageNamed:@"地点"] forState:UIControlStateNormal];
    [LocationV addSubview:LocationBtn];
    [LocationBtn addTarget:self action:@selector(clickLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float AllHeight =CGRectGetMaxY(LocationV.frame);
    
    backView.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, AllHeight);
    //////******************************///******************************///******************************
    //循环添加办理记录
    //转交办理情况
    UIView *BanliQingKV = [[UIView alloc] init];
    //BanliQingKV.backgroundColor = [UIColor greenColor];
    BanliQingKV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    BanliQingKV.layer.borderWidth = 1;
    BanliQingKV.layer.cornerRadius = 5;
    [myScroll addSubview:BanliQingKV];
    
    UILabel *zhuanjiaoTitleL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 40)];
    zhuanjiaoTitleL.textColor = choiceColor(16, 86, 148);
    zhuanjiaoTitleL.font = [UIFont systemFontOfSize:16];
    zhuanjiaoTitleL.textAlignment = NSTextAlignmentCenter;
    zhuanjiaoTitleL.text = @"转交办理情况";
    [BanliQingKV addSubview:zhuanjiaoTitleL];
    
    Y = CGRectGetMaxY(zhuanjiaoTitleL.frame)+2;
    //报到
    for (int i =0; i<_BanLiJieGuoArr.count; i++) {
        NSDictionary *baodaoDic = _BanLiJieGuoArr[i];
        //
        UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
        line5.backgroundColor = [UIColor lightGrayColor];
        [BanliQingKV addSubview:line5];
        
        //办理情况详情
        //层次
        UILabel *cengciL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
        NSString *cengciStr = [baodaoDic objectForKey:@"bl_blr_lxname"];
        NSString *banlirenStr = [baodaoDic objectForKey:@"bl_blrname"];
        if (ISNULLSTR(cengciStr)&&ISNULLSTR(banlirenStr)) {
            cengciL.text = @"办理层次：   办理人：";
        }
        else{
            cengciL.text = [NSString stringWithFormat:@"办理层次：%@   办理人：%@",cengciStr,banlirenStr];
        }
        
        cengciL.font = fuwuFont;
        [BanliQingKV addSubview:cengciL];
        
        //办理日期
        UILabel *date1L = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+20+1, SCREEN_WIDTH-36, 20)];
        NSString *date1Str = [baodaoDic objectForKey:@"bl_blrq"];
        if (ISNULLSTR(date1Str)) {
            date1L.text = @"办理日期：";
        }
        else{
            date1L.text = [NSString stringWithFormat:@"办理日期：%@",date1Str];
        }
        
        date1L.font = fuwuFont;
        [BanliQingKV addSubview:date1L];
        
        //转交日期
        UILabel *date2L = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+40+1, SCREEN_WIDTH-36, 20)];
        NSString *date2Str = [baodaoDic objectForKey:@"bl_blrq"];
        if (ISNULLSTR(date2Str)) {
            date2L.text = @"转交日期：";
        }
        else{
            date2L.text = [NSString stringWithFormat:@"转交日期：%@",date2Str];
        }
        
        date2L.font = fuwuFont;
        [BanliQingKV addSubview:date2L];
        
        //责任单位
        UILabel *jieguoLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+60+1, SCREEN_WIDTH-36, 20)];
        NSString *danweiStr = [baodaoDic objectForKey:@"bl_zrdw"];
        NSString *jieguoStr = [baodaoDic objectForKey:@"bl_bljg"];
        NSString *ResultSTR;
        if ([jieguoStr isEqualToString:@"1"]) {
            ResultSTR = @"已办理";
        }
        else if ([jieguoStr isEqualToString:@"2"]) {
            ResultSTR = @"转交县一级";
        }
        else{
            ResultSTR = @"办理中";
        }
        
        
        if (ISNULLSTR(danweiStr)&&ISNULLSTR(ResultSTR)) {
            jieguoLabel.text = @"责任单位：    办理结果：";
        }
        else if ((!ISNULLSTR(danweiStr))&&ISNULLSTR(ResultSTR)){
            jieguoLabel.text = [NSString stringWithFormat:@"责任单位：%@   办理结果：",danweiStr];
        }
        else if (ISNULLSTR(danweiStr)&&(!ISNULLSTR(ResultSTR))){
            jieguoLabel.text = [NSString stringWithFormat:@"责任单位：   办理结果：%@",ResultSTR];
        }
        else{
            jieguoLabel.text = [NSString stringWithFormat:@"责任单位：%@   办理结果：%@",danweiStr,ResultSTR];
        }
        
        jieguoLabel.font = fuwuFont;
        [BanliQingKV addSubview:jieguoLabel];    //责任结果
        
        //办理情况
        UILabel *blQKL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+80+1, SCREEN_WIDTH-36, 20)];
        NSString *blQKLStr = [baodaoDic objectForKey:@"bl_blbz"];
        if (ISNULLSTR(blQKLStr)) {
            blQKL.text = @"办理情况：";
        }
        else{
            blQKL.text = [NSString stringWithFormat:@"办理情况：%@",blQKLStr];
        }
        
        blQKL.font = fuwuFont;
        [BanliQingKV addSubview:blQKL];
        
        Y = Y+100;
    }

    
    
    float resultH = Y;
    
    
    BanliQingKV.frame = CGRectMake(10, 20+AllHeight+20, SCREEN_WIDTH-20, resultH);
    [myScroll addSubview:BanliQingKV];
    Y = CGRectGetMaxY(BanliQingKV.frame);
    //++++++++++++++++++++++++++++++++++++++++++++++++++
    //办理情况textF
    UIView *BanliJiluV = [[UIView alloc] init];
    //BanliJiluV.backgroundColor = [UIColor redColor];
    BanliJiluV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    BanliJiluV.layer.borderWidth = 1;
    BanliJiluV.layer.cornerRadius = 5;
    [myScroll addSubview:BanliJiluV];
    
    UILabel *qkL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 20)];
    qkL.text = @"办理情况:";
    [BanliJiluV addSubview:qkL];
    
    Y = CGRectGetMaxY(qkL.frame)+2;
    textF = [[UITextField alloc] initWithFrame:CGRectMake(8, Y, SCREEN_WIDTH-36, 30)];
    textF.layer.borderWidth = 1;
    textF.delegate = self;
    textF.returnKeyType = UIReturnKeyDone;
    [BanliJiluV addSubview:textF];
    float resultH2 = CGRectGetMaxY(textF.frame);
    
    BanliJiluV.frame = CGRectMake(10, 20+AllHeight+20+resultH+20, SCREEN_WIDTH-20, resultH2+10);
    [myScroll addSubview:BanliJiluV];
    
    //
    Y = CGRectGetMaxY(BanliJiluV.frame);
    
    
    //添加已办结按钮
    UIButton *SendBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, Y +10, SCREEN_WIDTH-200, 30)];
    [SendBtn addTarget:self action:@selector(ClickBanjie:) forControlEvents:UIControlEventTouchUpInside];
    SendBtn.layer.borderWidth = 1;
    SendBtn.layer.cornerRadius = 6;
    [SendBtn setTitle:@"已办结" forState:UIControlStateNormal];
    SendBtn.backgroundColor = [UIColor orangeColor];
    [SendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [myScroll addSubview:SendBtn];

    ///////*****************************
    Y = CGRectGetMaxY(SendBtn.frame);
    myScroll.contentSize = CGSizeMake(0, Y+30);
    [self.view addSubview:myScroll];
    
}
//办结
-(void)ClickBanjie:(UIButton *)button{
    NSString *ss = textF.text;
    MyLog(@"%@",ss);
    if (ISNULLSTR(textF.text)) {
        [MBProgressHUD showError:@"办理情况不能为空"];
        return;
    }
    //弹框，确认提交日志
    
    [MBProgressHUD showMessage:@"提交中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *now = [formatter stringFromDate:[NSDate date]];
    [param setObject:idStr forKey:@"userId"];
    [param setObject:[_infoDic objectForKey:@"rz_id"] forKey:@"bl_rz_id"];
           //提交
    [param setObject: [NSNumber numberWithInt:1]  forKey:@"bl_bljg"];//日志结果：1已办理；2转交县一级；3办理中
    
    [param setObject:now forKey:@"bl_zjrq"];//转交办理日期
    [param setObject:@"" forKey:@"bl_zrdw"];//责任单位
    [param setObject:textF.text forKey:@"bl_blbz"];
    
    [[HttpClient httpClient] requestWithPath:@"/CreateMQLogBLRecord" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        [jsonData objectFromJSONData];
        [MBProgressHUD showSuccess:@"已办结"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    
    

}
-(void)LookPics:(UIButton *)button
{
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    if (_picsArr.count>0) {
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_picsArr.count];
        
        for (int i= 0;i<_picsArr.count;i++) {
            UIImage *imageS =  _picsArr[i];
            MJPhoto *photo= [[MJPhoto alloc] init];
            photo.image = imageS;
            photo.index =i;
            [photos addObject:photo];
        }
        
        
        browser.photos = photos;
        browser.currentPhotoIndex =0;
        [browser show];
    }
    
}

-(void)clickLocationBtn:(UIButton *)button{
    
    GanbuLocationVC *location = [[GanbuLocationVC alloc] init];
    location.infoDic = _infoDic;
    [self.navigationController pushViewController:location animated:YES];
}
//计算文本尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    MyLog(@"%@",[text class]);
    if (ISNULL(text))
    {
        return CGSizeMake(0, 25);
    }
    else
    {
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string{
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textF resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    }

@end
