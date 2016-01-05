//
//  LogListGanbuVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/16.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "LogListGanbuVC.h"
#import "MJRefresh.h"
#import "LogDetailVC.h"
@interface LogListGanbuVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    JKAlertDialog *alert;
    UITableView *_ZJDTable;
    UITableView *_CUNTable;
    
    NSMutableArray *LogArr;//所有数据结果
    NSMutableArray *SearchShowArr;//搜索结果
    NSInteger rowscount;
    NSInteger page;
}
@property (nonatomic,strong) NSArray *ZJDArr;
@property (nonatomic,strong) NSArray *CUNArr;
@property (nonatomic,strong) NSString *ZJDFlag;
@property (nonatomic,strong) NSString *CUNFlag;
@end

@implementation LogListGanbuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getViewData];
}
-(void)initData{
    _ZJDArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
    LogArr = [[NSMutableArray alloc] init];
    rowscount = 20;
    page = 1;
}
-(void)initView{
    if (_flagLogZT.integerValue == 0) {
        self.title = @"提交镇一级未办理日志";
    }
    else if (_flagLogZT.integerValue == 1)
    {
        self.title = @"提交镇一级已办理日志";
    }
    else{
        self.title = @"辖区内所有日志";
    }
    _CUNBtn.enabled = NO;
    _ZJDBtn.layer.cornerRadius = 4;
    _CUNBtn.layer.cornerRadius = 4;
    _ZJDTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _ZJDTable.delegate = self;
    _ZJDTable.dataSource = self;
    
    _CUNTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _CUNTable.delegate = self;
    _CUNTable.dataSource = self;
    _mySearchBar.delegate = self;
    //搜索键盘点击done缩回键盘
    _mySearchBar.returnKeyType = UIReturnKeyDone;
    [self setupRefreshView];

}
- (void)setupRefreshView
{
    self.LogTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getViewData];//加载下一页
    }];
    
}

-(void)getViewData{
       //获取日志
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    if (_flagLogZT.integerValue == 0) {
        //提交镇一级未处理
        if (ISNULLSTR(_ZJDFlag)) {
            [param setObject:@"" forKey:@"ssz_id"];//统计表类型
        }
        else{
            [param setObject:_ZJDFlag forKey:@"ssz_id"];//统计表类型
        }
        if (ISNULLSTR(_CUNFlag)) {
            [param setObject:@"" forKey:@"cun_id"];//统计表类型
            
        }
        else{
            [param setObject:_CUNFlag forKey:@"cun_id"];//统计表类型
            
        }

        [param setObject:@"" forKey:@"wg_id"];
        [param setObject:@"30" forKey:@"ztxx"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@""forKey:@"myd"];
        page++;
    }
    else if (_flagLogZT.integerValue == 1){
        //提交镇一级已处理
        if (ISNULLSTR(_ZJDFlag)) {
            [param setObject:@"" forKey:@"ssz_id"];//统计表类型
        }
        else{
            [param setObject:_ZJDFlag forKey:@"ssz_id"];//统计表类型
        }
        if (ISNULLSTR(_CUNFlag)) {
            [param setObject:@"" forKey:@"cun_id"];//统计表类型
            
        }
        else{
            [param setObject:_CUNFlag forKey:@"cun_id"];//统计表类型
            
        }

        [param setObject:@"" forKey:@"wg_id"];
        [param setObject:@"31" forKey:@"ztxx"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@""forKey:@"myd"];
        page++;
    }
    else {
        //辖区内所有,不填
        if (ISNULLSTR(_ZJDFlag)) {
            [param setObject:@"" forKey:@"ssz_id"];//统计表类型
        }
        else{
            [param setObject:_ZJDFlag forKey:@"ssz_id"];//统计表类型
        }
        if (ISNULLSTR(_CUNFlag)) {
            [param setObject:@"" forKey:@"cun_id"];//统计表类型
            
        }
        else{
            [param setObject:_CUNFlag forKey:@"cun_id"];//统计表类型
            
        }
        [param setObject:@"" forKey:@"wg_id"];
        [param setObject:@"" forKey:@"ztxx"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@""forKey:@"myd"];
        page++;
    }
    //获取日志列表
    [[HttpClient httpClient] requestWithPath:@"/GetMQLogInfoPage" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *middleArr = (NSArray *)[jsonData objectFromJSONData];
        if (middleArr.count<rowscount) {
            [_LogTableView.footer endRefreshingWithNoMoreData];
        }
        else{
            [_LogTableView.footer endRefreshing];
        }
        [LogArr addObjectsFromArray:middleArr];
        SearchShowArr = [NSMutableArray arrayWithArray:LogArr];
        [self.LogTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_LogTableView.footer endRefreshing];
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

- (IBAction)clickZJDBtn:(id)sender {
    _CUNBtn.enabled = YES;//可选
    alert = [[JKAlertDialog alloc]initWithTitle:@"镇街道" message:@""];
    alert.contentView =  _ZJDTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];

}
- (IBAction)clickCUNBtn:(id)sender {
    alert = [[JKAlertDialog alloc]initWithTitle:@"村社区" message:@""];
    alert.contentView =  _CUNTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];

}
#pragma --mark table
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _ZJDTable) {
        return _ZJDArr.count+1;
    }
    else if (tableView == _CUNTable){
        return _CUNArr.count +1;
    }
    else{
        return SearchShowArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _ZJDTable) {
        static NSString *ID = @"ZJDCellFuwu";
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
    else if (tableView == _CUNTable)
    {
        static NSString *ID = @"CUNCellFuwu";
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
        //服务列表
        static NSString *ID = @"LogGanbuCell";
        ganbuLogCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ganbuLogCell" owner:nil options:nil] lastObject];
        }
        [cell  updateCell:SearchShowArr[indexPath.row]];
        
        return  cell;
    }
   }
//点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ZJDTable) {
        [alert dismiss];
        if (indexPath.row == 0) {
            _ZJDFlag = @"";
            [_ZJDBtn setTitle:@"选择镇(街道)" forState: UIControlStateNormal ];
        }
        else{
            _ZJDFlag = [NSString stringWithFormat:@"%@",[_ZJDArr[indexPath.row-1] objectForKey:@"zjd_id"]];//用于提交接口参数
            [_ZJDBtn setTitle:[_ZJDArr[indexPath.row-1] objectForKey:@"zjd_name"] forState: UIControlStateNormal ];
            //作请求，得到该镇内的村
            [self getCunData:_ZJDFlag];
        }
        
    }
    else if (tableView == _CUNTable) {
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
    else{
       /* NSString *ztxxStr = [SearchShowArr[indexPath.row] objectForKey:@"rz_ztxx"];
        NSString *bl_bljg = [SearchShowArr[indexPath.row] objectForKey:@"bl_bljg"];*/
        
        GanbuLogDetailWeiVC *weibanliVC = [[GanbuLogDetailWeiVC alloc] init];
        weibanliVC.infoDic = SearchShowArr[indexPath.row];
        [self.navigationController pushViewController:weibanliVC animated:YES];
    }
}



-(void)getCunData:(NSString *)ZJD_ID{
    [MBProgressHUD showMessage:@"获取该镇的村列表"];
    //获取下属单位
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:ZJD_ID forKey:@"zjd_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetCUNIndexByID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _CUNArr = (NSArray *)[jsonData objectFromJSONData];
        
        [_CUNTable reloadData];
        _CUNBtn.enabled = YES;//可选
        MyLog(@"村%@",_CUNArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
}

- (IBAction)clickSearchBtn:(id)sender{
    page = 1;
    [self getViewData];
    
    
}
@end
