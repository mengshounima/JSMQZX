//
//  LogDetailVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/28.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "LogDetailVC.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
#define fuwuFont [UIFont systemFontOfSize:14]
@interface LogDetailVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    BOOL HasPicture;
    
}
@property (nonatomic,strong) NSArray *picsArr;
@property (nonatomic,weak) UIImageView *picImageV;
@end

@implementation LogDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"走访日志信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getLogPics];
}
-(void)getLogPics{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:[_infoDic objectForKey:@"rz_id"] forKey:@"rz_id"];
    
       [[HttpClient httpClient] requestWithPath:@"/GetMQPhotosRzID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
           [self initView];
       
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
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

-(void)initView{
    MyLog(@"%@",_infoDic);
   
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
    Y = CGRectGetMaxY(gaikuangL.frame);
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

    if (HasPicture) {
        picBtn.enabled = YES;
        [picBtn setImage:[UIImage imageNamed:@"照片"]  forState:UIControlStateNormal];
        [picBtn addTarget:self action:@selector(LookPics:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [picBtn setImage:[UIImage imageNamed:@"相机灰色"]  forState:UIControlStateNormal];
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
    myScroll.contentSize = CGSizeMake(0, AllHeight);
    [self.view addSubview:myScroll];
    
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
    
    LocationVC *locationVc = [[LocationVC alloc] init];
    locationVc.infoDic = _infoDic;
    [self.navigationController pushViewController:locationVc animated:YES];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
