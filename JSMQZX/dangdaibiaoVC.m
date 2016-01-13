//
//  dangdaibiaoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/26.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "dangdaibiaoVC.h"

@interface dangdaibiaoVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *LogArr;//所有数据结果
    NSMutableArray *SearchShowArr;//搜索结果
}


@end

@implementation dangdaibiaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self reloadList];
    [self initView];
}
-(void)initData{
    LogArr = [[NSMutableArray alloc] init];
}
-(void)initView{
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"被访农户姓名搜索"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    self.myTable.tableHeaderView = _mySearchBar;
}


-(void)reloadList{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:@"" forKey:@"ID"];
    //获取公告列表
    [MBProgressHUD showMessage:@"加载中"];
    [[HttpClient httpClient] requestWithPath:@"/GetOpenDayIndex" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        LogArr = (NSMutableArray *)[jsonData objectFromJSONData];
        SearchShowArr = [NSMutableArray arrayWithArray:LogArr];
        [self.myTable reloadData];
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
        //公告标题搜索
        NSString *namePinyinStr = [Single objectForKey:@"Title"];
        if (!ISNULLSTR(namePinyinStr)) {
            if ([namePinyinStr rangeOfString:searchKey].location != NSNotFound) {
                [SearchShowArr addObject:Single];
                
                continue;
            }
        }
    }
    [_myTable reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"GongGaoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = [SearchShowArr[indexPath.row] objectForKey:@"Title"];
    NSString *timeStr = [SearchShowArr[indexPath.row] objectForKey:@"AddDate"];
    /*NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateStyle = @"yyyy/MM/dd HH:mm:ss";//"2014/3/11 0:00:00"
    NSDate *date = [dateFor dateFromString:timeStr];*/
    NSArray *SS = [timeStr componentsSeparatedByString:@" "];
    NSArray *MM = [SS[0] componentsSeparatedByString:@"/"];
    NSString *month = MM[1];
    NSString *day= MM[2];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];

    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@月%@日",month ,day];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SearchShowArr.count;
    
}
//点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"DangdaibiaoToInfo" sender:SearchShowArr[indexPath.row]];//log详情
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DangdaibiaoInfoVC *infoVC = segue.destinationViewController;
    infoVC.infoDic = sender;
}


@end
