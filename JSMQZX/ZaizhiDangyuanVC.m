//
//  ZaizhiDangyuanVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/17.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "ZaizhiDangyuanVC.h"
#import "MJRefresh.h"
@interface ZaizhiDangyuanVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    JKAlertDialog *alert;
    UITableView *_DWXiaShuTable;
    UITableView *_DWQiTaTable;
    
    NSMutableArray *LogArr;//所有数据结果
    NSMutableArray *SearchShowArr;//搜索结果
    NSInteger rowscount;
    NSInteger page;
    NSNumber *selectDWID;
    int f1 ;
    int f2;
    int f3;

}
@property (nonatomic,strong) NSArray *DWXiaShuArr;
@property (nonatomic,strong) NSArray *DWQiTaArr;
@end

@implementation ZaizhiDangyuanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getViewData];//开始请求一次，里面有3个请求
}
-(void)initData{
    LogArr = [[NSMutableArray alloc] init];
    SearchShowArr = [[NSMutableArray alloc] init];
    f1 = 0;
    f2 = 0;
    f3 = 0;
    rowscount = 20;
    page = 1;
    _mySearchBar.returnKeyType = UIReturnKeyDone;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _mySearchBar.text = @"";
    SearchShowArr = [LogArr mutableCopy];
    [_LogTableView reloadData];
    [_mySearchBar resignFirstResponder];
}
-(void)initView{
    _DWQiTaTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _DWQiTaTable.delegate = self;
    _DWQiTaTable.dataSource = self;
    
    _DWXiaShuTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _DWXiaShuTable.delegate = self;
    _DWXiaShuTable.dataSource = self;

    _mySearchBar.delegate = self;
     [self setupRefreshView];//初始化刷新
    
}
#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    self.LogTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self reloadMoreList];//加载下一页
    }];
    
}
//搜索用
-(void)reloadMoreList{
    //在职党员列表
    NSMutableDictionary *paramList = [[NSMutableDictionary alloc] init];
    if (ISNULL(selectDWID)) {
        [paramList setObject:@"" forKey:@"dw_id"];
    }
    else{
        [paramList setObject:selectDWID forKey:@"dw_id"];
    }
    
    [paramList setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
    [paramList setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [paramList setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetDYBDIndexPage" method:TBHttpRequestPost parameters:paramList prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
        [_LogTableView reloadData];
        page++;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_LogTableView.footer endRefreshing];
        [MBProgressHUD showError:@"请求失败"];
    }];

    
 }

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self queryWithCondition:searchText];
}

-(void)queryWithCondition:(NSString *)searchKey
{//在当前显示列表中搜索关键字
    [SearchShowArr removeAllObjects];
    for (int i=0;i<[LogArr count];i++) {
        NSDictionary *Single=[LogArr objectAtIndex:i];
        
        if (ISNULLSTR(searchKey)) {//没有值，显示全部
            SearchShowArr = [LogArr mutableCopy];
            break;
        }
        
        NSString *namePinyinStr = [Single objectForKey:@"bd_name"];
        if (!ISNULLSTR(namePinyinStr)) {
            if ([namePinyinStr rangeOfString:searchKey].location != NSNotFound) {
                [SearchShowArr addObject:Single];
                
                continue;
            }
        }
    }
    [_LogTableView reloadData];
}
//其他党委GetDWIndex
//下属type=1
//机关下属党委
//党员报到GetDYBDIndexPage

-(void)getViewData{
    [MBProgressHUD showMessage:@"构建页面"];
    //获取下属单位
    NSMutableDictionary *paramXS = [[NSMutableDictionary alloc] init];
    [paramXS setObject:@"1" forKey:@"Type"];
    [paramXS setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetDWIndex" method:TBHttpRequestPost parameters:paramXS prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f1 = 1;
        if (f1 == 1&& f2 ==1 && f3 == 1) {
            [MBProgressHUD hideHUD];
        }
        NSData* jsonData = [self XMLString:responseObject];
        _DWXiaShuArr = [jsonData objectFromJSONData];
        MyLog(@"---**--%@",_DWXiaShuArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
    //获取其他党委
    NSMutableDictionary *paramQT = [[NSMutableDictionary alloc] init];
    [paramQT setObject:@"2" forKey:@"Type"];
    [paramQT setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetDWIndex" method:TBHttpRequestPost parameters:paramQT prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f2 = 1;
        if (f1 == 1&& f2 ==1 &&f3 == 1) {
            [MBProgressHUD hideHUD];
        }

        NSData* jsonData = [self XMLString:responseObject];
        _DWQiTaArr = [jsonData objectFromJSONData];
        MyLog(@"---**--%@",_DWQiTaArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
    //在职党员列表
    NSMutableDictionary *paramList = [[NSMutableDictionary alloc] init];
    [paramList setObject:@"" forKey:@"dw_id"];
    
    [paramList setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
    [paramList setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [paramList setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID  forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetDYBDIndexPage" method:TBHttpRequestPost parameters:paramList prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        f3 = 1;
        if (f1 == 1&& f2 ==1 &&f3 == 1) {
            [MBProgressHUD hideHUD];
        }
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *middleArr = (NSArray *)[jsonData objectFromJSONData];
        [LogArr addObjectsFromArray:middleArr];
         SearchShowArr = [NSMutableArray arrayWithArray:LogArr];
        //MyLog(@"---**--%@",LogArr);
        [_LogTableView reloadData];
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
        return  jsonData;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _DWXiaShuTable) {
        return _DWXiaShuArr.count+1;
    }
    else if (tableView == _DWQiTaTable){
        return _DWQiTaArr.count+1;
    }
    else{
        return SearchShowArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _DWXiaShuTable) {//是否共性
        static NSString *CellIdentifier = @"DWXiaShuCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"机关党委下属单位";
        }
        else{
            cell.textLabel.text = [_DWXiaShuArr[indexPath.row-1] objectForKey:@"dw_name"];
        }
        return cell;
        
    }
    else if(tableView == _DWQiTaTable){
        static NSString *CellIdentifier = @"DWQiTaCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"其他党委";
        }
        else
        {
            cell.textLabel.text = [_DWQiTaArr[indexPath.row-1] objectForKey:@"dw_name"];
        }
        return cell;
    }
    else{
        //党员列表
        static NSString *CellIdentifier = @"DangyuanCell";
        DangyuanCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DangyuanCell" owner:nil options:nil] lastObject];
        }
        [cell updateCell:SearchShowArr[indexPath.row]];
        return cell;

    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_DWXiaShuTable) {
         [alert dismiss];
        if (indexPath.row == 0) {
            [_DWXiaShuBtn setTitle:@"机关党委下属单位" forState:UIControlStateNormal];
            [_DWQitaBtn setTitle:@"其他党委" forState:UIControlStateNormal];
            
            selectDWID =nil;//查询所有党员报到
        }
        else{
            [_DWXiaShuBtn setTitle:[_DWXiaShuArr[indexPath.row-1] objectForKey:@"dw_name"] forState:UIControlStateNormal];
            selectDWID =[_DWXiaShuArr[indexPath.row-1] objectForKey:@"dw_id"];
        }
    }
    else if (tableView==_DWQiTaTable){
         [alert dismiss];
        if (indexPath.row == 0) {
            [_DWQitaBtn setTitle:@"其他党委" forState:UIControlStateNormal];
            [_DWXiaShuBtn setTitle:@"机关党委下属单位" forState:UIControlStateNormal];
            selectDWID =nil;//查询所以党员报到
            
            
        }
        else{
            [_DWQitaBtn setTitle:[_DWQiTaArr[indexPath.row-1] objectForKey:@"dw_name"] forState:UIControlStateNormal];
            selectDWID =[_DWQiTaArr[indexPath.row-1] objectForKey:@"dw_id"];
        }

    }
    else{
        //报到详情
        [self performSegueWithIdentifier:@"DangyuanVCToDangyuanInfo" sender:SearchShowArr[indexPath.row]];
    }
    
  
}
- (IBAction)clickDWQiTaBtn:(id)sender{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择所属党委" message:@""];
    alert.contentView = _DWQiTaTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
}
- (IBAction)clickDWXiaShuBtn:(id)sender{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择村/社区" message:@""];
    alert.contentView = _DWXiaShuTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
}
- (IBAction)clickSearchBtn:(id)sender{
    [self initData];//重新开始搜索
    [self reloadMoreList];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DangyuanVCToDangyuanInfo"]) {
        BaodaoInfoVC *baodaoInfoVC = segue.destinationViewController;
        baodaoInfoVC.infoDic = sender;
    }
}


@end
