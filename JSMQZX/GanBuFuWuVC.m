//
//  GanBuFuWuVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/24.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "GanBuFuWuVC.h"
#import "MJRefresh.h"
@interface GanBuFuWuVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_TypeTable;
    NSString *flagZJD;
    JKAlertDialog *alert;
    NSInteger rowscount;
    NSInteger page;

}
@property (nonatomic,weak) NSArray *typeArr;
@property (nonatomic,weak) NSArray *resultArr;
@end

@implementation GanBuFuWuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getUserDataByZJD];
}
-(void)initData{
    rowscount = 20;
    page = 1;
    _typeArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
    flagZJD = [[DataCenter sharedInstance] ReadData].UserInfo.useType;
}
-(void)initView{
    _TypeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
    _TypeTable.delegate = self;
    _TypeTable.dataSource = self;
    
    _searchBtn.layer.cornerRadius = 4;
    UIButton *FieldBtn = [[UIButton alloc] initWithFrame:_searchField.frame];
    [FieldBtn addTarget:self action:@selector(clickField:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:FieldBtn];
     [self setupRefreshView];//初始化刷新
    
}
#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    self.evaluateTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getUserDataByZJD];//加载下一页
    }];
    
}

-(void)getUserDataByZJD{
    [MBProgressHUD showMessage:@"加载中"];
    
    //获取统计信息
    NSMutableDictionary *paramTongji = [[NSMutableDictionary alloc] init];
    [paramTongji setObject:@"7" forKey:@"AnalysisType"];//统计表类型
    [paramTongji setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    [paramTongji setObject:flagZJD forKey:@"ssz_id"];//统计表类型
    [paramTongji setObject:@"" forKey:@"cun_id"];//统计表类型
    [paramTongji setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];//统计表类型
    [paramTongji setObject:[NSNumber numberWithInteger:page] forKey:@"page"];//统计表类型
    [[HttpClient httpClient] requestWithPath:@"/GetAnalysisInfo" method:TBHttpRequestPost parameters:paramTongji prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *resultArr = [jsonData objectFromJSONData];
        MyLog(@"---**--%@",resultArr);
        page++;
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
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
    MyLog(@"***%@",str);
    return  jsonData;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _TypeTable) {
        [alert dismiss];
        if (indexPath.row == 0) {
            //传管理员自己的ssz
            flagZJD = [[DataCenter sharedInstance] ReadData].UserInfo.useType;
            _searchField.text = @"选择镇(街道)/村(社区)";
        }
        else{
            flagZJD = [NSString stringWithFormat:@"%@",[_typeArr[indexPath.row-1] objectForKey:@"zjd_id"]];//用于提交接口参数
            _searchField.text = [_typeArr[indexPath.row-1] objectForKey:@"zjd_name"];
            
        }

    }
    else{
        //点击列表，无操作
    }
   }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _TypeTable) {
         return _typeArr.count+1;
    }
    else{
        return _resultArr.count;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _TypeTable) {
        static NSString *ID = @"ZJDCellQY";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"选择镇(街道)/村(社区)";
        }
        else{
            cell.textLabel.text = [_typeArr[indexPath.row-1] objectForKey:@"zjd_name"];
        }
        return  cell;

    }
    else{
        //列表
        static NSString *ID = @"PinJiaCell";
        EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluateCell" owner:nil options:nil] lastObject];
        }
        [cell updateCellWithInfoDic:_resultArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
    
    
}
-(void)clickField:(UIButton *)button{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择镇/社区" message:@""];
    alert.contentView =  _TypeTable;
    
    [alert addButtonWithTitle:@"取消"];
    [alert show];
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
