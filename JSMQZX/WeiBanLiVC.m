//
//  WeiBanLiVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/14.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "WeiBanLiVC.h"

@interface WeiBanLiVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *LogArr;//所有数据结果
    NSMutableArray *SearchShowArr;//搜索结果
}
@end

@implementation WeiBanLiVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self getLogData];
}
//未办理日志
-(void)getLogData{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr =[[UserInfo sharedInstance] ReadData].useID;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:[[UserInfo sharedInstance]ReadData].useType forKey:@"ssz_id"];
    [param setObject:@"" forKey:@"cun_id"];
    [param setObject:@"" forKey:@"wg_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)_flagLogZT] forKey:@"ztxx"];//办理状态
    [param setObject:@"" forKey:@"myd"];
    [[HttpClient httpClient] requestWithPath:@"/GetMQLogInfo" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        LogArr = (NSArray *)[jsonData objectFromJSONData];
        SearchShowArr = [NSMutableArray arrayWithArray:LogArr];
        [self.rizhiTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error];
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
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"走访农户姓名搜索"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    self.rizhiTableView.tableHeaderView = _mySearchBar;
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
    [cell updateContent:LogArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SearchShowArr.count;
    
}
//点击某一网格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"GridToSelectFarmer" sender:SearchShowArr[indexPath.row]];
    
    
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
