//
//  SelectFarmerVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/10.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "SelectFarmerVC.h"

@interface SelectFarmerVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>{
    NSArray *farmerArr;//所以数据结果
    NSMutableArray *SearchShowArr;//搜索结果
}
@end

@implementation SelectFarmerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFarmerOfGrid];
}
-(void)initData{
    
}
-(void)getFarmerOfGrid{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[UserInfo sharedInstance] ReadData].useID;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:[_gridInfo objectForKey:@"cun_id"] forKey:@"cun_id"];
    [param setObject:[_gridInfo objectForKey:@"wg_id"] forKey:@"wg_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetGridPeopleIndex" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        farmerArr = (NSArray *)[jsonData objectFromJSONData];
        SearchShowArr = [NSMutableArray arrayWithArray:farmerArr];
        [self.FarmerTable reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error];
    }];

}
-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    /*_SearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _SearchBar.delegate = self;
    [_SearchBar setPlaceholder:@"农户搜索"];*/
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    _searchController.searchResultsUpdater = self;
    
    _searchController.dimsBackgroundDuringPresentation = NO;
    
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.FarmerTable.tableHeaderView = self.searchController.searchBar;
    　//之前是通过判断搜索时候的TableView，不过现在直接使用self.searchController.active进行判断即可，也就是UISearchController的active属性:
    
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [self.searchController.searchBar text];
    [self queryWithCondition:searchText];
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
    /*if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }*/
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
