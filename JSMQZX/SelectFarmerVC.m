//
//  SelectFarmerVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/10.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "SelectFarmerVC.h"
#import "MJRefresh.h"
@interface SelectFarmerVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *farmerArr;//所以数据结果
    NSMutableArray *SearchShowArr;//搜索结果
    NSInteger rowscount;
    NSInteger page;
}
@end

@implementation SelectFarmerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self reloadMoreList];
}
-(void)initData{
    rowscount = 20;
    page = 1;
    farmerArr = [[NSMutableArray alloc] init];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"被访农户姓名搜索"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    self.FarmerTable.tableHeaderView = _mySearchBar;
    [self setupRefreshView];//初始化刷新
    
}

-(void)reloadMoreList{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    //地址
    NSString *urlStr;
    if (_flagPeopleSelect.integerValue == 1) {
        //联结
        [param setObject:_flagPeopleSelect forKey:@"LogType"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
         [param setObject:@""forKey:@"KeyWord"];
        urlStr = @"/GetPeopleIndexPage";
       
    }
    else if (_flagPeopleSelect.integerValue == 2){
        //已走访
        [param setObject:_flagPeopleSelect forKey:@"LogType"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@""forKey:@"KeyWord"];
         urlStr = @"/GetPeopleIndexPage";
    
    }
    else if (_flagPeopleSelect.integerValue == 3){
        //未走访
        [param setObject:_flagPeopleSelect forKey:@"LogType"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@""forKey:@"KeyWord"];
        urlStr = @"/GetPeopleIndexPage";
   
    }
    else {
        //随机走访_flagPeopleSelect == 4
        [param setObject:[_gridInfo objectForKey:@"cun_id"] forKey:@"cun_id"];
        [param setObject:[_gridInfo objectForKey:@"wg_id"] forKey:@"wg_id"];
        urlStr = @"/GetGridPeopleIndex";
    }
    [[HttpClient httpClient] requestWithPath:urlStr method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *middleArr = (NSArray *)[jsonData objectFromJSONData];
        if (middleArr.count<rowscount) {
            [_FarmerTable.footer endRefreshingWithNoMoreData];
        }
        else{
            [_FarmerTable.footer endRefreshing];
        }
        [farmerArr addObjectsFromArray:middleArr];
        SearchShowArr = [NSMutableArray arrayWithArray:farmerArr];
        [self.FarmerTable reloadData];
         page++;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [_FarmerTable.footer endRefreshing];
        [MBProgressHUD showError:@"请求失败"];
    }];

}
#pragma mark - 集成刷新控件
- (void)setupRefreshView
{
    self.FarmerTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self reloadMoreList];//加载下一页
    }];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self queryWithCondition:searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self queryWithCondition:@""];
}

-(void)queryWithCondition:(NSString *)searchKey
{//搜索
    [SearchShowArr removeAllObjects];
    for (int i=0;i<[farmerArr count];i++) {
        NSDictionary *Single=[farmerArr objectAtIndex:i];
        
        if (ISNULLSTR(searchKey)) {//没有值，显示全部
            SearchShowArr = [farmerArr mutableCopy];
            break;
        }
        
        NSString *namePinyinStr = [Single objectForKey:@"user_name"];
        if (!ISNULLSTR(namePinyinStr)) {
            if ([namePinyinStr rangeOfString:searchKey].location != NSNotFound) {
                [SearchShowArr addObject:Single];
                
                continue;
            }
        }
    }
    [_FarmerTable reloadData];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"farmerCell";
    SelectFarmerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectFarmerCell" owner:nil options:nil] lastObject];
        //[[SelectFarmerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //cell.textLabel.text = [SearchShowArr[indexPath.row] objectForKey:@"user_name"];
    [cell updateCell:SearchShowArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SearchShowArr.count;
    
}
//点击某一网格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"SelectFarmerToFarmerInfo" sender:SearchShowArr[indexPath.row]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FarmerInfoTableVC *farmerInfo = segue.destinationViewController;
    farmerInfo.farmerInfo = sender;
}


@end
