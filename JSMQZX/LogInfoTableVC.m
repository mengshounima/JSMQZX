//
//  LogInfoTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "LogInfoTableVC.h"

@interface LogInfoTableVC ()

@end

@implementation LogInfoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getFarmerDetail{
    /*[MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[UserInfo sharedInstance] ReadData].useID;
    [param setObject:idStr forKey:@"userId"];
    [param setObject:[_farmerInfo objectForKey:@"user_id"] forKey:@"rz_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetMQLogInfoByID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *arr = (NSArray *)[jsonData objectFromJSONData];
        farmerDic = arr[0];
        MyLog(@"%@",farmerDic);
        [self.InfoTableVIew reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败"];
    }];*/
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 17;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"logInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"test";
    /*if (indexPath.row ==0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"走访日期:%@",[farmerDic objectForKey:@"user_name"]];
    }
    else if (indexPath.row ==1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"走访干部:%@",[farmerDic objectForKey:@"zjd_name"]];
        
        
    }
    else if (indexPath.row ==2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"走访镇/街道:%@",[farmerDic objectForKey:@"cun_name"]];
        ;
        
    }
    else if (indexPath.row ==3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"走访村/社区:%@",[farmerDic objectForKey:@"wg_name"]];
        ;
        
    }
    else if (indexPath.row ==4)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"所属网格:%@",[farmerDic objectForKey:@"user_jtcys"]];
        
    }
    else if (indexPath.row ==5)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"走访农户:%@",[farmerDic objectForKey:@"user_hndy"]];
        
    }
    else if (indexPath.row ==6)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"民情概况:%@",[farmerDic objectForKey:@"user_dbqk"]];
        ;
        
    }
    else if (indexPath.row ==7)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"民生类别:%@",[farmerDic objectForKey:@"user_sfgz"]];
        
    }
    else if (indexPath.row ==8)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"民生需求:%@",[farmerDic objectForKey:@"user_lxfs"]];
        
    }
    else if (indexPath.row ==9)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"填写日期:%@",[farmerDic objectForKey:@""]];
        
    }
    else if (indexPath.row ==10)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"办理结果%@",[farmerDic objectForKey:@"user_lxdy_name"]];
        
    }
    else if (indexPath.row ==11)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"转交日期:%@",[farmerDic objectForKey:@"user_lxdy_lxfs"]];
        
    }
    else if (indexPath.row ==12)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"附加照片%@",[farmerDic objectForKey:@"user_zgb_Name"]];
        
    }
    else if (indexPath.row ==13)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"日志位置%@",[farmerDic objectForKey:@"zwlb_name"]];
        
    }*/
    return cell;
}/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}*/
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
    label.text = [NSString stringWithFormat:@"详细信息[编号:%@]",[farmerDic objectForKey:@"user_id"]];
    label.textAlignment = NSTextAlignmentCenter;
    return  label;
}*/
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
