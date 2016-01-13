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
    UITableView *_ZJDTable;
    UITableView *_CUNTable;

    JKAlertDialog *alert;
    NSInteger rowscount;
    NSInteger page;

}
@property (nonatomic,strong) NSArray *ZJDArr;
@property (nonatomic,strong) NSArray *CUNArr;
@property (nonatomic,strong) NSString *ZJDFlag;
@property (nonatomic,strong) NSString *CUNFlag;
@property (nonatomic,strong) NSMutableArray *resultArr;


@end

@implementation GanBuFuWuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getUserDataByZJD];
}
-(void)initData{
    NSString *powerStr = [NSString stringWithFormat:@"%@",[[DataCenter sharedInstance] ReadData].UserInfo.power];
    
    if([powerStr isEqualToString:@"3"]){
        MyLog(@"镇干部");
        _ZJDBtn.enabled = NO;
        [_ZJDBtn setTitle:[[DataCenter sharedInstance] ReadData].UserInfo.administerName forState:UIControlStateNormal];
        _ZJDFlag = [NSString stringWithFormat:@"%@",[[DataCenter sharedInstance] ReadData].UserInfo.useType];
        [self getCunData:_ZJDFlag];
    }
    else
    {
        _CUNBtn.enabled = NO;
        _ZJDArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
        
    }

    

    _resultArr = [[NSMutableArray alloc] init];
    rowscount = 20;
    page = 1;
}
-(void)initView{
    _CUNBtn.enabled = NO;
    _ZJDBtn.layer.cornerRadius = 4;
    _CUNBtn.layer.cornerRadius = 4;
    _ZJDTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _ZJDTable.delegate = self;
    _ZJDTable.dataSource = self;
    
    _CUNTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _CUNTable.delegate = self;
    _CUNTable.dataSource = self;
    
    
    _SearchBtn.layer.cornerRadius = 4;     [self setupRefreshView];//初始化刷新
    [self setupRefreshView];
    
}
#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    self.evaluateTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getUserDataByZJD];//加载下一页
    }];
    
}

-(void)getUserDataByZJD{
    
    //获取统计信息
    NSMutableDictionary *paramTongji = [[NSMutableDictionary alloc] init];
    [paramTongji setObject:@"7" forKey:@"AnalysisType"];//统计表类型
    [paramTongji setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    if (ISNULLSTR(_ZJDFlag)) {
        [paramTongji setObject:@"" forKey:@"ssz_id"];//统计表类型
    }
    else{
        [paramTongji setObject:_ZJDFlag forKey:@"ssz_id"];//统计表类型
    }
    if (ISNULLSTR(_CUNFlag)) {
        [paramTongji setObject:@"" forKey:@"cun_id"];//统计表类型
        
    }
    else{
        [paramTongji setObject:_CUNFlag forKey:@"cun_id"];//统计表类型
        
    }

    [paramTongji setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];//统计表类型
    [paramTongji setObject:[NSNumber numberWithInteger:page] forKey:@"page"];//统计表类型
    [[HttpClient httpClient] requestWithPath:@"/GetAnalysisInfo" method:TBHttpRequestPost parameters:paramTongji prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *middleArr  = [jsonData objectFromJSONData];
    
        if (middleArr.count<rowscount) {
            [self.evaluateTableView.footer endRefreshingWithNoMoreData];
        }
        else{
            [self.evaluateTableView.footer endRefreshing];
        }
        [_resultArr addObjectsFromArray:middleArr];
        [_evaluateTableView reloadData];
        page++;
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.evaluateTableView.footer endRefreshing];
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
    if (tableView == _ZJDTable) {
        [alert dismiss];
        if (indexPath.row == 0) {
            //传管理员自己的ssz
            _ZJDFlag = [[DataCenter sharedInstance] ReadData].UserInfo.useType;
            [_ZJDBtn setTitle:@"选择镇(街道)/村(社区)" forState: UIControlStateNormal ];
        }
        else{
            _ZJDFlag = [NSString stringWithFormat:@"%@",[_ZJDArr[indexPath.row-1] objectForKey:@"zjd_id"]];//用于提交接口参数
            [_ZJDBtn setTitle:[_ZJDArr[indexPath.row-1] objectForKey:@"zjd_name"] forState: UIControlStateNormal ];
            //作请求，得到该镇内的村
            [self getCunData:_ZJDFlag];        }

    }
    else if (tableView == _CUNTable){
        [alert dismiss];
        if (indexPath.row == 0) {
            _CUNFlag = @"";
            [_CUNBtn setTitle:@"选择村(社区)" forState: UIControlStateNormal ];
        }
        else{
            _CUNFlag = [NSString stringWithFormat:@"%@",[_CUNArr[indexPath.row-1] objectForKey:@"cun_id"]];//用于提交接口参数
            [_CUNBtn setTitle:[_CUNArr[indexPath.row-1] objectForKey:@"cun_name"] forState: UIControlStateNormal ];
        }
        

    }
}
-(void)getCunData:(NSString *)ZJD_ID{
    //[MBProgressHUD showMessage:@"获取该镇的村列表"];
    //获取下属单位
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:ZJD_ID forKey:@"zjd_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetCUNIndexByID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //[MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _CUNArr = (NSArray *)[jsonData objectFromJSONData];
        
        [_CUNTable reloadData];
        _CUNBtn.enabled = YES;//可选
        MyLog(@"村%@",_CUNArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //[MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _ZJDTable) {
        return _ZJDArr.count+1;
    }
    else if (tableView == _CUNTable){
        return _CUNArr.count +1;
    }
    else{
        return _resultArr.count;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ZJDTable) {
        static NSString *ID = @"nhBzjdCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"选择镇(街道)";
        }
        else{
            cell.textLabel.text = [_ZJDArr[indexPath.row-1] objectForKey:@"zjd_name"];
        }
        return  cell;
        
    }
    else  if (tableView == _CUNTable)
    {
        static NSString *ID = @"nhBcunCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"选择村(社区)";
        }
        else{
            cell.textLabel.text = [_CUNArr[indexPath.row-1] objectForKey:@"cun_name"];
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
        /*NSNumber *numberIndex = [NSNumber numberWithInteger:Index];
        NSMutableDictionary *middle = [NSMutableDictionary dictionaryWithDictionary:_resultArr[indexPath.row]];
        [ middle setObject:numberIndex forKey:@"index"];*/
        
        [cell updateCellWithInfoDic:_resultArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return  cell;
    }
    
    
}
//点击镇街道
- (IBAction)clickZJDBtn:(id)sender{
    //弹框
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择镇/街道" message:@""];
    alert.contentView =  _ZJDTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
    
}
- (IBAction)clickCUNBtn:(id)sender{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择村/社区" message:@""];
    alert.contentView =  _CUNTable;
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
}

- (IBAction)clickSearchBtn:(id)sender {
     page = 1;
    [_resultArr removeAllObjects];
    [self getUserDataByZJD];
    
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
