//
//  LogListGanbuVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/16.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "LogListGanbuVC.h"

@interface LogListGanbuVC ()<UITableViewDataSource,UITableViewDelegate>
{
    JKAlertDialog *alert;
    UITableView *_ZJDTable;
    UITableView *_CUNTable;
    
    NSMutableArray *LogArr;//所有数据结果
    NSMutableArray *SearchShowArr;//搜索结果
    NSInteger rowscount;
    NSInteger page;
}
@property (nonatomic,strong) NSArray *ZJDArr;
@property (nonatomic,strong) NSArray *CUNArr;
@end

@implementation LogListGanbuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self getViewData];
}
-(void)initView{
    _CUNBtn.enabled = NO;
    _ZJDBtn.layer.cornerRadius = 4;
    _CUNBtn.layer.cornerRadius = 4;
    _ZJDTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 230) style:UITableViewStylePlain];
    _ZJDTable.delegate = self;
    _ZJDTable.dataSource = self;
    
    _CUNTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 390) style:UITableViewStylePlain];
    _CUNTable.delegate = self;
    _CUNTable.dataSource = self;

}
-(void)getViewData{
    [MBProgressHUD showMessage:@"构建页面"];
    //获取镇街道
    NSMutableDictionary *paramZJD = [[NSMutableDictionary alloc] init];
    [paramZJD setObject:@"1" forKey:@"Type"];
    [paramZJD setObject:@"" forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetZJDIndex" method:TBHttpRequestPost parameters:paramZJD prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _ZJDArr = [jsonData objectFromJSONData];
        MyLog(@"---**--%@",_ZJDArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
    //获取村社区
    /*NSMutableDictionary *paramCUN = [[NSMutableDictionary alloc] init];
    [paramCUN setObject:@"" forKey:@"zjd_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetCUNIndexByID" method:TBHttpRequestPost parameters:paramCUN prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _CUNArr = [jsonData objectFromJSONData];
        MyLog(@"---**--%@",_CUNArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];*/
    //获取日志
    /*NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
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
        [param setObject:@""forKey:@"myd"];
        page++;
    }
    else if (_flagLogZT.integerValue == 6){
        //已评价
        [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useType forKey:@"ssz_id"];
        [param setObject:@"" forKey:@"cun_id"];
        [param setObject:@"" forKey:@"wg_id"];
        [param setObject:@"" forKey:@"ztxx"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@""forKey:@"myd"];
        page++;
    }
    else {
        //1，2，3，4
        [param setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useType forKey:@"ssz_id"];
        [param setObject:@"" forKey:@"cun_id"];
        [param setObject:@"" forKey:@"wg_id"];
        [param setObject:_flagLogZT forKey:@"ztxx"];
        [param setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:@""forKey:@"myd"];
        page++;
    }
    //获取日志列表
    [[HttpClient httpClient] requestWithPath:@"/GetMQLogInfoPage" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [_rizhiTableView.footer endRefreshing];
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *middleArr = (NSArray *)[jsonData objectFromJSONData];
        if (middleArr.count<rowscount&&flagFirst==1) {
            [MBProgressHUD showError:@"已经加载了全部数据"];
        }
        else{
            [LogArr addObjectsFromArray:middleArr];
            SearchShowArr = [NSMutableArray arrayWithArray:LogArr];
            [self.rizhiTableView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_rizhiTableView.footer endRefreshing];
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
    MyLog(@"***%@",str);
    return  jsonData;
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

- (IBAction)clickZJDBtn:(id)sender {
    _CUNBtn.enabled = YES;//可选
    alert = [[JKAlertDialog alloc]initWithTitle:@"镇街道" message:@""];
    alert.contentView =  _ZJDTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];

}
- (IBAction)clickCUNBtn:(id)sender {
    alert = [[JKAlertDialog alloc]initWithTitle:@"村社区" message:@""];
    alert.contentView =  _CUNTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];

}
#pragma --mark table
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==_ZJDTable) {
        return _ZJDArr.count+1;
    }
    else{
        return _CUNArr.count+1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _ZJDTable) {//是否共性
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CommomCell"];
        static NSString *CellIdentifier = @"CommomCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"不是共性问题";
        }
        else{
            //cell.textLabel.text = [_ZJDArr[indexPath.row-1] objectForKey:@"rdwt_name"];
        }
        return cell;
        
    }
    else{
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"typeCell"];
        static NSString *CellIdentifier = @"typeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"未选择";
        }
        else
        {
            //cell.textLabel.text = [_CUNArr[indexPath.row-1] objectForKey:@"mqlb_name"];
        }
        return cell;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [alert dismiss];
   /* if (tableView == _CommonTable) {
        if (indexPath.row==0) {
            //flagGongXin = 2008;
        }
        else{
            flagGongXin = [NSString stringWithFormat:@"%@",[commomArr[indexPath.row-1] objectForKey:@"rdwt_id"]];//用于提交接口参数
            _commonF.text = [commomArr[indexPath.row-1] objectForKey:@"rdwt_name"];
            
        }
    }
    else{
        if (!indexPath.row==0) {
            flagLeiBie = [NSString stringWithFormat:@"%@",[typeArr[indexPath.row-1] objectForKey:@"mqlb_id"]];//用于提交接口参数
            _typeF.text = [typeArr[indexPath.row-1] objectForKey:@"mqlb_name"];
        }
        
        
    }*/
    
}

- (IBAction)clickSearchBtn:(id)sender {
}
@end
