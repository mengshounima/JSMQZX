//
//  BaodaoInfoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/27.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "BaodaoInfoVC.h"
#define fuwuFont [UIFont systemFontOfSize:14]
@interface BaodaoInfoVC ()
{
    int f1;
    int f2;
    int f3;
    int page ;
    int rowscount;
    NSString *ZhiWuStr;
}
@property (nonatomic,strong) NSArray *baodaoArr;
@property (nonatomic,strong) NSArray *fuwuArr;
@property (nonatomic,strong) NSArray *xinyuanArr;
@end

@implementation BaodaoInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self getInfoData];//获取报到信息
    
}
-(void)initData{
    f1 = 0;
    f2 = 0;
    f3 = 0;
    page = 1;
    rowscount = 30;
}
//获取党员报到信息
-(void)getInfoData{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *paramList = [[NSMutableDictionary alloc] init];
    [paramList setObject:[_infoDic objectForKey:@"bd_id"] forKey:@"BD_ID"];
    [paramList setObject:@"" forKey:@"ID"];
    [paramList setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetDYBDInfo" method:TBHttpRequestPost parameters:paramList prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f1 = 1;
        NSData* jsonData = [self XMLString:responseObject];
        _baodaoArr = (NSArray *)[jsonData objectFromJSONData];
        if (_baodaoArr.count>0) {
            ZhiWuStr = [_baodaoArr[0] objectForKey:@"bd_zw"];
        }
        if (f1==1&&f2 ==1&&f3 ==1) {
            [MBProgressHUD hideHUD];
            [self initView];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    
    
    //获取服务列表
    NSMutableDictionary *paramFuwu = [[NSMutableDictionary alloc] init];
    [paramFuwu setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID forKey:@"userId"];
    [paramFuwu setObject:@"" forKey:@"ssz_id"];
    [paramFuwu setObject:@"" forKey:@"cun_id"];

    [paramFuwu setObject:@"" forKey:@"ID"];
    [paramFuwu setObject:[_infoDic objectForKey:@"bd_id"] forKey:@"BD_ID"];
    [paramFuwu setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
    [paramFuwu setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [[HttpClient httpClient] requestWithPath:@"/GetDYFWInfo" method:TBHttpRequestPost parameters:paramFuwu prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f2 = 1;
        NSData* jsonData = [self XMLString:responseObject];
        _fuwuArr = (NSArray *)[jsonData objectFromJSONData];
        if (f1==1&&f2 ==1&&f3==1) {
            [MBProgressHUD hideHUD];
            [self initView];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
    
    //获取微心愿列表
    NSMutableDictionary *paramXinyuan = [[NSMutableDictionary alloc] init];
    [paramXinyuan setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID forKey:@"userId"];
    [paramXinyuan setObject:@"" forKey:@"ssz_id"];
    [paramXinyuan setObject:@"" forKey:@"cun_id"];
    
    [paramXinyuan setObject:@"" forKey:@"ID"];
    [paramXinyuan setObject:[_infoDic objectForKey:@"bd_id"] forKey:@"BD_ID"];
    [paramXinyuan setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
    [paramXinyuan setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [[HttpClient httpClient] requestWithPath:@"/GetWXYInfo" method:TBHttpRequestPost parameters:paramXinyuan prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f3 = 1;
        NSData* jsonData = [self XMLString:responseObject];
        _xinyuanArr = (NSArray *)[jsonData objectFromJSONData];
        if (f1==1&&f2 ==1&&f3==1) {
            [MBProgressHUD hideHUD];
            [self initView];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
}

-(void)initView{
    MyLog(@"传信息%@",_infoDic);
    UIScrollView *myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:myScroll];
    //党员基本信息
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 150)];
    view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view1.layer.borderWidth = 1;
    view1.layer.cornerRadius = 5;
    [myScroll addSubview:view1];
    //tite
    UILabel *IDL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 40)];
    IDL.text = [NSString stringWithFormat:@"党员基本信息"];
    IDL.textColor = choiceColor(16, 86, 148);
    IDL.font = [UIFont systemFontOfSize:16];
    IDL.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:IDL];
    
    float Y = CGRectGetMaxY(IDL.frame);
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:line];
    
    //所属村/社区
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    dateL.text = [NSString stringWithFormat:@"党员姓名：%@",[_infoDic objectForKey:@"bd_name"]];
    dateL.font = fuwuFont;
    [view1 addSubview:dateL];
    
    Y = CGRectGetMaxY(dateL.frame);
    //line
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:line1];
    //
    UILabel *fuwushequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    fuwushequL.text = [NSString stringWithFormat:@"所属党委：%@",[_infoDic objectForKey:@"dw_name"]];
    fuwushequL.font = fuwuFont;
    [view1 addSubview:fuwushequL];
    
    Y = CGRectGetMaxY(fuwushequL.frame);
    //line
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:line2];
    
    //
    UILabel *baodaoshequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    baodaoshequL.text = [NSString stringWithFormat:@"工作单位：%@",[_infoDic objectForKey:@"bd_gzdw"]];
    baodaoshequL.font = fuwuFont;
    [view1 addSubview:baodaoshequL];
    
    Y = CGRectGetMaxY(baodaoshequL.frame);
    //line
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:line3];
    
    //
    UILabel *PhoneL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    PhoneL.text = [NSString stringWithFormat:@"联系电话：%@",[_infoDic objectForKey:@"bd_lxdh"]];
    PhoneL.font = fuwuFont;
    [view1 addSubview:PhoneL];
    
    Y = CGRectGetMaxY(PhoneL.frame);
    //line
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:line4];
    
    //
    UILabel *zhiwuL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    
    zhiwuL.text = [NSString stringWithFormat:@"职务：%@",ZhiWuStr];
    zhiwuL.font = fuwuFont;
    [view1 addSubview:zhiwuL];
    
    Y =  CGRectGetMaxY(view1.frame);

    //报到信息
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, Y+20, SCREEN_WIDTH-20, 50+80*_baodaoArr.count)];
    view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view2.layer.borderWidth = 1;
    view2.layer.cornerRadius = 5;
    [myScroll addSubview:view2];
    
    //tite
    UILabel *baodaoTitleL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 40)];
    baodaoTitleL.text = [NSString stringWithFormat:@"社区报到信息"];
    baodaoTitleL.textColor = choiceColor(16, 86, 148);
    baodaoTitleL.font = [UIFont systemFontOfSize:16];
    baodaoTitleL.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:baodaoTitleL];
    
    Y= CGRectGetMaxY(baodaoTitleL.frame);
    
    
    //报到
    for (int i =0; i<_baodaoArr.count; i++) {
        NSDictionary *baodaoDic = _baodaoArr[i];
        //
        UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
        line5.backgroundColor = [UIColor lightGrayColor];
        [view2 addSubview:line5];
        
        UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
        NSString *date1 = [baodaoDic objectForKey:@"bd_bdrq"];
        NSArray *dateArr1 = [date1 componentsSeparatedByString:@" "];
        dateL.text = [NSString stringWithFormat:@"报到日期：%@  报到社区：%@",dateArr1[0],[baodaoDic objectForKey:@"cun_name"]];
        dateL.font = fuwuFont;
        [view2 addSubview:dateL];
        UILabel *jiayuanL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1+20, SCREEN_WIDTH-36, 20)];
        jiayuanL.text = [NSString stringWithFormat:@"家园奉献岗位：%@",[baodaoDic objectForKey:@"fxgw_name"]];
        jiayuanL.font = fuwuFont;
        [view2 addSubview:jiayuanL];
        
        //物业
        UILabel *wuyeL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1+40, SCREEN_WIDTH-36, 20)];
        wuyeL.text = [NSString stringWithFormat:@"物业(卫生)费缴纳情况-本年度：%@  上年度：%@",[baodaoDic objectForKey:@"bd_wy_bnd"],[baodaoDic objectForKey:@"bd_wy_snd"]];
        wuyeL.font = fuwuFont;
        [view2 addSubview:wuyeL];
        //星际
        
        UILabel *StarL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1+60, SCREEN_WIDTH-36, 20)];
        NSNumber *stars = [baodaoDic objectForKey:@"bd_pddj"];//⭐️
        if (stars.intValue<40) {
            StarL.text = [NSString stringWithFormat:@"星级：  人户分离：%@    备注：%@",[baodaoDic objectForKey:@"bd_rhfl"],[baodaoDic objectForKey:@"bd_bz"]];
        }
        else{
            int starnumber = (stars.intValue-40)/30;
            if (starnumber==0) {
                StarL.text = [NSString stringWithFormat:@"星级：⭐️  人户分离：%@    备注：%@",[baodaoDic objectForKey:@"bd_rhfl"],[baodaoDic objectForKey:@"bd_bz"]];

            }
            else if (starnumber==1) {
                StarL.text = [NSString stringWithFormat:@"星级：⭐️⭐️ 人户分离：%@    备注：%@",[baodaoDic objectForKey:@"bd_rhfl"],[baodaoDic objectForKey:@"bd_bz"]];
                
            }
            else if (starnumber==2) {
                StarL.text = [NSString stringWithFormat:@"星级：⭐️⭐️⭐️  人户分离：%@    备注：%@",[baodaoDic objectForKey:@"bd_rhfl"],[baodaoDic objectForKey:@"bd_bz"]];
                
            }
            else if (starnumber==3) {
                StarL.text = [NSString stringWithFormat:@"星级：⭐️⭐️⭐️⭐️  人户分离：%@    备注：%@",[baodaoDic objectForKey:@"bd_rhfl"],[baodaoDic objectForKey:@"bd_bz"]];
                
            }
            else if (starnumber>3) {
                StarL.text = [NSString stringWithFormat:@"星级：⭐️⭐️⭐️⭐️⭐️  人户分离：%@    备注：%@",[baodaoDic objectForKey:@"bd_rhfl"],[baodaoDic objectForKey:@"bd_bz"]];
                
            }




            
        }
                StarL.font = fuwuFont;
        [view2 addSubview:StarL];
        
        Y = Y+80;
    }

    //服务记录
    float fuwuAllHeight = 60;
    UIView *view3 = [[UIView alloc] init];
                     //WithFrame:CGRectMake(10, Y+20, SCREEN_WIDTH-20, 50+80*_baodaoArr.count)];
    view3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view3.layer.borderWidth = 1;
    view3.layer.cornerRadius = 5;
    [myScroll addSubview:view3];
    
    //tite
    UILabel *fuwuTitleL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 40)];
    fuwuTitleL.text = [NSString stringWithFormat:@"参加社区服务记录"];
    fuwuTitleL.textColor = choiceColor(16, 86, 148);
    fuwuTitleL.font = [UIFont systemFontOfSize:16];
    fuwuTitleL.textAlignment = NSTextAlignmentCenter;
    [view3 addSubview:fuwuTitleL];
    
    Y =  CGRectGetMaxY(fuwuTitleL.frame);
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [view3 addSubview:line6];

    
    for (int i =0; i<_fuwuArr.count; i++) {
        NSDictionary *fuwuDic = _fuwuArr[i];
        UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
        line8.backgroundColor = [UIColor lightGrayColor];
        [view3 addSubview:line8];
        //服务日期
        UILabel *datefwL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
        NSString *date2 = [fuwuDic objectForKey:@"fw_date"];
        NSArray *dateArr2 = [date2 componentsSeparatedByString:@" "];
        datefwL.text = [NSString stringWithFormat:@"服务日期：%@  类别：",dateArr2[0]];
        datefwL.font = fuwuFont;
        [view3 addSubview:datefwL];
        
        //报到社区
        UILabel *shequL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1+20, SCREEN_WIDTH-36, 20)];
        shequL.text = [NSString stringWithFormat:@"报到社区：%@",[fuwuDic objectForKey:@"cun_name"]];
        shequL.font = fuwuFont;
        [view3 addSubview:shequL];
        //活动内容
        
        NSString *contentStr = [fuwuDic objectForKey:@"fw_nr"];
        if (ISNULLSTR(contentStr)) {
            contentStr = @"活动内容：";
        }
        else{
            contentStr = [NSString stringWithFormat:@"活动内容：%@",contentStr];
        }
        
        CGSize contentRect = [self sizeWithText:contentStr font:fuwuFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
        UILabel *huodongContentL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1+40, SCREEN_WIDTH-36, contentRect.height)];
        huodongContentL.text = contentStr;
        huodongContentL.font = fuwuFont;
        huodongContentL.numberOfLines = 0;
        
        [view3 addSubview:huodongContentL];
        
        float Ymiddle =  CGRectGetMaxY(huodongContentL.frame);
        
        Y = Ymiddle;
        fuwuAllHeight = Y;
    }
    view3.frame = CGRectMake(10,CGRectGetMaxY(view2.frame)+20, SCREEN_WIDTH-20, fuwuAllHeight);
    
    Y = CGRectGetMaxY(view3.frame);
    //微心愿参与活动情况
    float xinyuanAllHeight =60;
    UIView *view4 = [[UIView alloc] init];
    //WithFrame:CGRectMake(10, Y+20, SCREEN_WIDTH-20, <#CGFloat height#>)
    view4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view4.layer.borderWidth = 1;
    view4.layer.cornerRadius = 5;
    [myScroll addSubview:view4];
    
    //tite
    UILabel *xinyuanrenL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 40)];
    xinyuanrenL.text = [NSString stringWithFormat:@"社区微心愿参与活动情况"];
    xinyuanrenL.textColor = choiceColor(16, 86, 148);
    xinyuanrenL.font = [UIFont systemFontOfSize:16];
    xinyuanrenL.textAlignment = NSTextAlignmentCenter;
    [view4 addSubview:xinyuanrenL];
    
    Y =  CGRectGetMaxY(xinyuanrenL.frame);
    UIView *line9 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line9.backgroundColor = [UIColor lightGrayColor];
    [view4 addSubview:line9];
    
    for (int i =0; i<_xinyuanArr.count; i++) {
        NSDictionary *xinyuanDic = _xinyuanArr[i];
        UIView *line10 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
        line10.backgroundColor = [UIColor lightGrayColor];
        [view4 addSubview:line10];
        //心愿人
        UILabel *xinyuanrenL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
        xinyuanrenL.text = [NSString stringWithFormat:@"心愿人：%@  组织单位：%@",[xinyuanDic objectForKey:@"wxy_xm"],[xinyuanDic objectForKey:@"cun_name"]];
        xinyuanrenL.font = fuwuFont;
        [view4 addSubview:xinyuanrenL];
        
        //是否完成
        UILabel *XinyuanDatwL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1+20, SCREEN_WIDTH-36, 20)];
        NSString *date3 = [xinyuanDic objectForKey:@"wxy_date"];
        NSArray *dateArr3 = [date3 componentsSeparatedByString:@" "];
        XinyuanDatwL.text = [NSString stringWithFormat:@"是否完成：%@  认领时间：%@",[xinyuanDic objectForKey:@"wxy_sfwc"],dateArr3[0]];
        XinyuanDatwL.font = fuwuFont;
        [view4 addSubview:XinyuanDatwL];
        //心愿内容
        
        NSString *contentStr = [xinyuanDic objectForKey:@"wxy_nr"];
        if (ISNULLSTR(contentStr)) {
            contentStr = @"心愿内容：";
        }
        else{
            contentStr = [NSString stringWithFormat:@"心愿内容：%@",contentStr];
        }
        
        CGSize contentRect = [self sizeWithText:contentStr font:fuwuFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
        UILabel *xinyuanContentL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1+40, SCREEN_WIDTH-36, contentRect.height)];
        xinyuanContentL.text = contentStr;
        xinyuanContentL.font = fuwuFont;
        xinyuanContentL.numberOfLines = 0;
        
        [view4 addSubview:xinyuanContentL];
        
        float Ymiddle =  CGRectGetMaxY(xinyuanContentL.frame);
        
        Y = Ymiddle;
        xinyuanAllHeight = Y;
    }
    
    view4.frame = CGRectMake(10,CGRectGetMaxY(view3.frame)+20, SCREEN_WIDTH-20, xinyuanAllHeight);

    myScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(view4.frame)+20);
    
    
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

-(NSData *)XMLString:(NSData *)data
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data  options:0 error:nil];
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    NSArray *users = [rootElement children];
    GDataXMLNode  *contentNode = users[0];
    NSString *str =  contentNode.XMLString;
    NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    MyLog(@"***%@",str);
    return  jsonData;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
