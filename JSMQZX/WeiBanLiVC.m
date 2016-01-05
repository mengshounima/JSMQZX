//
//  WeiBanLiVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/14.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "WeiBanLiVC.h"
#import "MJRefresh.h"
@interface WeiBanLiVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *LogArr;//所有数据结果
    NSMutableArray *SearchShowArr;//搜索结果
    NSInteger rowscount;
    NSInteger page;
}
@end

@implementation WeiBanLiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self reloadMoreList];
    [self initView];
}
-(void)initData{
    rowscount = 20;
    page = 1;
    LogArr = [[NSMutableArray alloc] init];
}
-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    if (_flagLogZT.integerValue == 2) {
        self.title = @"未办理日志";
    }
    else if (_flagLogZT.integerValue == 3){
        self.title = @"提交上级上级日志";

    }
    else if (_flagLogZT.integerValue == 4){
        self.title = @"无诉求日志";
        
    }
    else if (_flagLogZT.integerValue == 1){
        self.title = @"已办理日志";
        
    }
    else if (_flagLogZT.integerValue == 5){
        self.title = @"未评价日志";
        
    }else{
         self.title = @"已经评价日志";
    }
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"被访农户姓名搜索"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    self.rizhiTableView.tableHeaderView = _mySearchBar;
    [self setupRefreshView];//初始化刷新
    
}
#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    self.rizhiTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self reloadMoreList];//加载下一页
    }];
    
}
-(void)reloadMoreList{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    if (_flagLogZT.integerValue == 5) {
        //未评价
        [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useType forKey:@"ssz_id"];
        [param setObject:@"" forKey:@"cun_id"];
        [param setObject:@"" forKey:@"wg_id"];
        [param setObject:@"" forKey:@"ztxx"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@"-1"forKey:@"myd"];
   
    }
    else if (_flagLogZT.integerValue == 6){
        //已评价
        [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useType forKey:@"ssz_id"];
        [param setObject:@"" forKey:@"cun_id"];
        [param setObject:@"" forKey:@"wg_id"];
        [param setObject:@"" forKey:@"ztxx"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@"1,2,3"forKey:@"myd"];
   
    }
    else {
        //1234
        [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useType forKey:@"ssz_id"];
        [param setObject:@"" forKey:@"cun_id"];
        [param setObject:@"" forKey:@"wg_id"];
        [param setObject:_flagLogZT forKey:@"ztxx"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@""forKey:@"myd"];
   
    }
    //[MBProgressHUD showMessage:@"加载中"];
    //获取日志列表
    [[HttpClient httpClient] requestWithPath:@"/GetMQLogInfoPage" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *middleArr = (NSArray *)[jsonData objectFromJSONData];
        if (middleArr.count<rowscount) {
             [_rizhiTableView.footer endRefreshingWithNoMoreData];
            }
        else{
            [_rizhiTableView.footer endRefreshing];
        }
        [LogArr addObjectsFromArray:middleArr];
        SearchShowArr = [NSMutableArray arrayWithArray:LogArr];
        [self.rizhiTableView reloadData];
         page++;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_rizhiTableView.footer endRefreshing];
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
//搜索框变化
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self queryWithCondition:searchText];
}
//右上角取消按钮点击
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self queryWithCondition:@""];
}
-(void)queryWithCondition:(NSString *)searchKey
{//搜索网格名
    [SearchShowArr removeAllObjects];
    for (int i=0;i<[LogArr count];i++) {
        NSDictionary *Single=[LogArr objectAtIndex:i];
        
        if (ISNULLSTR(searchKey)) {//没有值，显示全部
            SearchShowArr = [LogArr mutableCopy];
            break;
        }
        
        NSString *namePinyinStr = [Single objectForKey:@"rz_zfnh_name"];
        if (!ISNULLSTR(namePinyinStr)) {
            if ([namePinyinStr rangeOfString:searchKey].location != NSNotFound) {
                [SearchShowArr addObject:Single];
                
                continue;
            }
        }
    }
    [_rizhiTableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"LogCell";
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LogCell" owner:nil options:nil] lastObject];
    }
    [cell updateContent:SearchShowArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SearchShowArr.count;
    
}
//点击某一网格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flagLogZT.integerValue==2) {
        //未办理
         [self performSegueWithIdentifier:@"RiZhiLIstToModify" sender:SearchShowArr[indexPath.row]];//log详情
    }
    else {
          [self performSegueWithIdentifier:@"RiZhiLIstToDetail" sender:SearchShowArr[indexPath.row]];//log详情列表 不可修改
    }
    
   
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RiZhiLIstToModify"]) {
        ModifyLogVC *modifyLogVC = segue.destinationViewController;
        modifyLogVC.myLogInfo = sender;
    }
    else if ([segue.identifier isEqualToString:@"RiZhiLIstToDetail"]){
        LogDetailVC *detailVC = segue.destinationViewController;
        detailVC.infoDic = sender;
    }
   
}


@end
