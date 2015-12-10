//
//  FarmersVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/9.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "FarmersVC.h"

@interface FarmersVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *gridArr;//所以数据结果
    NSMutableArray *SearchShowArr;//搜索结果
}
@end

@implementation FarmersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getGridData];
    [self initView];
}

//获取网格数据
-(void)getGridData{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    UserInfo *user = [[UserInfo shareUserInfo] ReadData];
    NSString *idStr = [NSString stringWithFormat:@"%@",user.useID];
    [param setObject:idStr forKey:@"userId"];
    [param setObject:@"" forKey:@"cun_id"];
    
    [[HttpClient httpClient] requestWithPath:@"/GetGridIndex" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        gridArr = (NSArray *)[jsonData objectFromJSONData];
        SearchShowArr = [NSMutableArray arrayWithArray:gridArr];
        [self.GridTable reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error];
    }];

    
}
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"网格搜索"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    self.GridTable.tableHeaderView = _mySearchBar;
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
    for (int i=0;i<[gridArr count];i++) {
        NSDictionary *Single=[gridArr objectAtIndex:i];
        
        if (ISNULLSTR(searchKey)) {//没有值，显示全部
            SearchShowArr = [gridArr mutableCopy];
            break;
        }
        
        NSString *namePinyinStr = [Single objectForKey:@"wg_name"];
        if (!ISNULLSTR(namePinyinStr)) {
            if ([namePinyinStr rangeOfString:searchKey].location != NSNotFound) {
                [SearchShowArr addObject:Single];
                
                continue;
            }
        }
    }
    [_GridTable reloadData];
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
    static NSString *ID = @"gridCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [SearchShowArr[indexPath.row] objectForKey:@"wg_name"];
    cell.textLabel.textColor = [UIColor blackColor];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SelectFarmerVC *selectFarmer = segue.destinationViewController;
    selectFarmer.gridInfo = sender;
}


@end
