//
//  FarmerInfoTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/11.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "FarmerInfoTableVC.h"

@interface FarmerInfoTableVC ()
{
    NSDictionary *farmerDic;//所以数据结果
}
@end

@implementation FarmerInfoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFarmerDetail];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getFarmerDetail{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[DataCenter sharedInstance] ReadData].UserInfo.useID ;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:[_farmerInfo objectForKey:@"user_id"] forKey:@"PeopleID"];
    [[HttpClient httpClient] requestWithPath:@"/GetPeopleInfo" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *arr = (NSArray *)[jsonData objectFromJSONData];
        farmerDic = arr[0];
        MyLog(@"%@",farmerDic);
        [self.InfoTableVIew reloadData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 17;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"farmerInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row ==0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"户主姓名:%@",[farmerDic objectForKey:@"user_name"]];
    }
    else if (indexPath.row ==1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"所属镇/村:%@",[farmerDic objectForKey:@"zjd_name"]];


    }
    else if (indexPath.row ==2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"所属村/社区:%@",[farmerDic objectForKey:@"cun_name"]];
;
        
    }
    else if (indexPath.row ==3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"所属网格:%@",[farmerDic objectForKey:@"wg_name"]];
;
        
    }
    else if (indexPath.row ==4)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"家庭成员数:%@",[farmerDic objectForKey:@"user_jtcys"]];
        
    }
    else if (indexPath.row ==5)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"户内党员情况(党员姓名及其与户主关系):%@",[farmerDic objectForKey:@"user_hndy"]];
        
    }
    else if (indexPath.row ==6)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"低保情况:%@",[farmerDic objectForKey:@"user_dbqk"]];
;
        
    }
    else if (indexPath.row ==7)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"是否有重点关注对象:%@",[farmerDic objectForKey:@"user_sfgz"]];
        
    }
    else if (indexPath.row ==8)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系方式:%@",[farmerDic objectForKey:@"user_lxfs"]];
        
    }
    else if (indexPath.row ==9)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"三户合一情况:%@",[farmerDic objectForKey:@""]];
        
    }
    else if (indexPath.row ==10)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系党员%@",[farmerDic objectForKey:@"user_lxdy_name"]];
        
    }
    else if (indexPath.row ==11)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系党员联系方式:%@",[farmerDic objectForKey:@"user_lxdy_lxfs"]];
        
    }
    else if (indexPath.row ==12)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系镇干部:%@",[farmerDic objectForKey:@"user_zgb_Name"]];
        
    }
    else if (indexPath.row ==13)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系镇干部职务级别:%@",[farmerDic objectForKey:@"zwlb_name"]];
        
    }
    else if (indexPath.row ==14)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系村干部:%@",[farmerDic objectForKey:@"user_cgb_Name"]];
        
    }
    else if (indexPath.row ==15)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"重点户类型:%@",[farmerDic objectForKey:@""]];
        
    }
    else if (indexPath.row ==16)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"是否重点走访重点户:%@",[farmerDic objectForKey:@""]];
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
    label.text = [NSString stringWithFormat:@"详细信息[编号:%@]",[farmerDic objectForKey:@"user_id"]];
    label.textAlignment = NSTextAlignmentCenter;
    return  label;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-200, 28)];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.layer.cornerRadius = 6;
    [btn setTitle:@"选择该农户" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickFarmer) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}
-(void)clickFarmer{
    //跳转到添加日志页面
    //添加通知,传参农户姓名和id
    NSDictionary *farmerInfo = @{@"user_name":[farmerDic objectForKey:@"user_name"],@"user_id":[farmerDic objectForKey:@"user_id"]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectOneFarmer" object:farmerInfo];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2]  animated:NO];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
