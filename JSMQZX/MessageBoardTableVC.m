//
//  MessageBoardTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/19.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "MessageBoardTableVC.h"

@interface MessageBoardTableVC ()<UISearchBarDelegate>
{
    NSMutableArray *SearchShowArr;
}
@property (nonatomic,strong) NSArray *mailArr;

@end

@implementation MessageBoardTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self initView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//留言板列表
-(void)getData{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetMailIndex" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _mailArr = (NSArray *)[jsonData objectFromJSONData];
        SearchShowArr = [NSMutableArray arrayWithArray:_mailArr];
        [self.tableView reloadData];
      
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

-(void)initView{
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"搜索"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    self.tableView.tableHeaderView = _mySearchBar;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return  SearchShowArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"mailCell";
    mailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"mailCell" owner:nil options:nil] lastObject];
        
    }
    [cell updateCell:SearchShowArr[indexPath.row]];
    
    return cell;
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
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_mySearchBar resignFirstResponder];
}
-(void)queryWithCondition:(NSString *)searchKey
{//搜索网格名
    [SearchShowArr removeAllObjects];
    for (int i=0;i<[_mailArr count];i++) {
        NSDictionary *Single=[_mailArr objectAtIndex:i];
        
        if (ISNULLSTR(searchKey)) {//没有值，显示全部
            SearchShowArr = [_mailArr mutableCopy];
            break;
        }
        
        NSString *namePinyinStr = [Single objectForKey:@"mail_title"];
        if (!ISNULLSTR(namePinyinStr)) {
            if ([namePinyinStr rangeOfString:searchKey].location != NSNotFound) {
                [SearchShowArr addObject:Single];
                
                continue;
            }
        }
    }
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"mailRootTomailInfo" sender:SearchShowArr[indexPath.row]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    mailInfoVC *infoVc = segue.destinationViewController;
    NSDictionary *dic = sender;
    infoVc.IDNum = [dic objectForKey:@"ID"];
}


@end
