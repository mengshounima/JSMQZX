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
@property (nonatomic,strong) NSArray *baodaoArr;
@end

@implementation BaodaoInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MyLog(@"详情%@",_infoDic);
    [self getInfoData];//获取报到信息
    
}
//获取党员报到信息
-(void)getInfoData{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *paramList = [[NSMutableDictionary alloc] init];
    [paramList setObject:[_infoDic objectForKey:@"bd_id"] forKey:@"BD_ID"];
    [paramList setObject:@"" forKey:@"ID"];
    [paramList setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetDYBDInfo" method:TBHttpRequestPost parameters:paramList prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _baodaoArr = (NSArray *)[jsonData objectFromJSONData];
        [self initView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];
    /*[MBProgressHUD showMessage:@"加载中"];
    //获取服务列表
    
    /*NSMutableDictionary *paramFuwu = [[NSMutableDictionary alloc] init];
    [paramFuwu setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID forKey:@"userId"];
    if (ISNULLSTR(_ZJDFlag)) {
        [paramFuwu setObject:@"" forKey:@"ssz_id"];
        
    }
    else{
        [paramFuwu setObject:_ZJDFlag forKey:@"ssz_id"];
    }
    if (ISNULLSTR(_CUNFlag)) {
        [paramFuwu setObject:@"" forKey:@"cun_id"];
    }
    else{
        [paramFuwu setObject:_CUNFlag forKey:@"cun_id"];
    }
    [paramFuwu setObject:@"" forKey:@"ID"];
    [paramFuwu setObject:@"" forKey:@"BD_ID"];
    [paramFuwu setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
    [paramFuwu setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [[HttpClient httpClient] requestWithPath:@"/GetDYFWInfo" method:TBHttpRequestPost parameters:paramFuwu prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        LogArr = (NSMutableArray *)[jsonData objectFromJSONData];
        SearchShowArr = [NSMutableArray arrayWithArray:LogArr];
        //极端cell高度
        _statusFrameArray = [NSMutableArray array];
        for (NSDictionary *dict in SearchShowArr) {
            
            MJStatusFrame *statusFrame = [[MJStatusFrame alloc] init];
            statusFrame.huodongStr = [NSString stringWithFormat:@"活动内容:%@",[dict objectForKey:@"fw_nr"]] ;//服务内容str
            statusFrame.dangyuanStr = [NSString stringWithFormat:@"参加党员:%@",[dict objectForKey:@"fw_dy_name"]] ;//参加党员
            
            [statusFrame HeightSetMethod];
            // 3.2.添加模型对象到数组中
            [_statusFrameArray addObject:statusFrame];
        }
        
        
        [self.LogTableView reloadData];
        page++;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
*/
    
    
    
}

-(void)initView{
    
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
    zhiwuL.text = [NSString stringWithFormat:@"职务："];
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
    
     Y =  CGRectGetMaxY(baodaoTitleL.frame);
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [view2 addSubview:line5];

    for (int i =0; i<_baodaoArr.count; i++) {
        NSDictionary *baodaoDic = _baodaoArr[i];
        //
        UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
        dateL.text = [NSString stringWithFormat:@"报到日期：%@  报到社区：%@",[baodaoDic objectForKey:@"bd_bdrq"],[baodaoDic objectForKey:@"cun_name"]];
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
        StarL.text = [NSString stringWithFormat:@"星级：%@  人户分离：%@    备注：%@",[baodaoDic objectForKey:@"bd_pddj"],[baodaoDic objectForKey:@"bd_rhfl"],[baodaoDic objectForKey:@"bd_bz"]];
        StarL.font = fuwuFont;
        [view2 addSubview:StarL];
        
        Y = Y+80;
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
