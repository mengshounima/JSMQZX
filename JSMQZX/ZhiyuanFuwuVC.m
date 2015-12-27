//
//  ZhiyuanFuwuVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/26.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "ZhiyuanFuwuVC.h"
#import "JKAlertDialog.h"
#import "MJStatusFrame.h"
@interface ZhiyuanFuwuVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
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
@property (nonatomic,strong) NSString *ZJDFlag;
@property (nonatomic,strong) NSString *CUNFlag;
@property (nonatomic,strong)  NSMutableArray *statusFrameArray;
@end

@implementation ZhiyuanFuwuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self getViewData];
}
-(void)initData{
    _ZJDArr = [[DataCenter sharedInstance] ReadZJDData].zjdArr;
    page = 1;
    rowscount = 20;
}

-(void)initView{
    _CUNBtn.enabled = NO;
    _ZJDBtn.layer.cornerRadius = 4;
    _CUNBtn.layer.cornerRadius = 4;
    _ZJDTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _ZJDTable.delegate = self;
    _ZJDTable.dataSource = self;
    
    _CUNTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7) style:UITableViewStylePlain];
    _CUNTable.delegate = self;
    _CUNTable.dataSource = self;
    _mySearchBar.delegate = self;
    //搜索键盘点击done缩回键盘
    _mySearchBar.returnKeyType = UIReturnKeyDone;
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _mySearchBar.text = @"";
    SearchShowArr = [LogArr mutableCopy];
    [_LogTableView reloadData];
    [_mySearchBar resignFirstResponder];
}
-(void)getViewData{
    
    [MBProgressHUD showMessage:@"加载中"];
    //获取服务列表
    NSMutableDictionary *paramFuwu = [[NSMutableDictionary alloc] init];
    [paramFuwu setObject:[[DataCenter sharedInstance] ReadData].UserInfo.useID forKey:@"userId"];
    if (ISNULLSTR(_ZJDFlag)) {
        [paramFuwu setObject:@"" forKey:@"ssz_id"];

    }
    else{
        [paramFuwu setObject:_ZJDFlag forKey:@"ssz_id"];
    }
        if (ISNULLSTR(_CUNFlag)) {
        [paramFuwu setObject:@"" forKey:@"cun_id"];
    }
    else{
         [paramFuwu setObject:_CUNFlag forKey:@"cun_id"];
    }
    [paramFuwu setObject:@"" forKey:@"ID"];
    [paramFuwu setObject:@"" forKey:@"BD_ID"];
    [paramFuwu setObject:[NSNumber numberWithInteger:rowscount] forKey:@"rowscount"];
    [paramFuwu setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [[HttpClient httpClient] requestWithPath:@"/GetDYFWInfo" method:TBHttpRequestPost parameters:paramFuwu prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        LogArr = (NSMutableArray *)[jsonData objectFromJSONData];
        SearchShowArr = [NSMutableArray arrayWithArray:LogArr];
        //极端cell高度
        _statusFrameArray = [NSMutableArray array];
        for (NSDictionary *dict in SearchShowArr) {
        
            MJStatusFrame *statusFrame = [[MJStatusFrame alloc] init];
            statusFrame.huodongStr = [NSString stringWithFormat:@"活动内容:%@",[dict objectForKey:@"fw_nr"]] ;//服务内容str
            statusFrame.dangyuanStr = [NSString stringWithFormat:@"参加党员:%@",[dict objectForKey:@"fw_dy_name"]] ;//参加党员
            
            [statusFrame HeightSetMethod];
            // 3.2.添加模型对象到数组中
            [_statusFrameArray addObject:statusFrame];
        }
        
        
        [self.LogTableView reloadData];
        page++;

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
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
    MyLog(@"***%@",str);
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
        NSString *namePinyinStr = [Single objectForKey:@"fw_nr"];
        if (!ISNULLSTR(namePinyinStr)) {
            if ([namePinyinStr rangeOfString:searchKey].location != NSNotFound) {
                [SearchShowArr addObject:Single];
                
                continue;
            }
        }
    }
    [_LogTableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ZJDTable) {
        static NSString *ID = @"ZJDCellFuwu";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"选择镇(街道)";
        }
        else{
            cell.textLabel.text = [_ZJDArr[indexPath.row-1] objectForKey:@"zjd_name"];
        }
        return  cell;
        
    }
    else if (tableView == _CUNTable)
    {
        static NSString *ID = @"CUNCellFuwu";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"选择村(社区)";
        }
        else{
            cell.textLabel.text = [_CUNArr[indexPath.row-1] objectForKey:@"cun_name"];
        }
        return  cell;

    }
    else{
        //服务列表
        static NSString *ID = @"FuwuCell";
        FuwuCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FuwuCell" owner:nil options:nil] lastObject];
        }
        [cell updateCell:SearchShowArr[indexPath.row]];
        cell.statusFrame = _statusFrameArray[indexPath.row];
        return  cell;

    }
    
}
//动态调整cell高度，根据文本
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _LogTableView) {
        // 取出这行对应的frame模型
        MJStatusFrame *statusFrame = _statusFrameArray[indexPath.row];
        return statusFrame.cellHeight;

    }
    else{
        return 44;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _ZJDTable) {
        return _ZJDArr.count+1;
    }
    else if (tableView == _CUNTable){
        return _CUNArr.count +1;
    }
    else{
        return SearchShowArr.count;
    }
}
//点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ZJDTable) {
        [alert dismiss];
        if (indexPath.row == 0) {
            //传管理员自己的ssz
            _ZJDFlag = @"";
            [_ZJDBtn setTitle:@"选择镇(街道)" forState: UIControlStateNormal ];
        }
        else{
            _ZJDFlag = [NSString stringWithFormat:@"%@",[_ZJDArr[indexPath.row-1] objectForKey:@"zjd_id"]];//用于提交接口参数
            [_ZJDBtn setTitle:[_ZJDArr[indexPath.row-1] objectForKey:@"zjd_name"] forState: UIControlStateNormal ];
            //作请求，得到该镇内的村
            [self getCunData:_ZJDFlag];
        }
        
    }
    else if (tableView == _CUNTable) {
        [alert dismiss];
        if (indexPath.row == 0) {
            //传管理员自己的ssz
            _CUNFlag = @"";
            [_CUNBtn setTitle:@"选择村(社区)" forState: UIControlStateNormal ];
        }
        else{
            _CUNFlag = [NSString stringWithFormat:@"%@",[_CUNArr[indexPath.row-1] objectForKey:@"cun_id"]];//用于提交接口参数
            [_CUNBtn setTitle:[_CUNArr[indexPath.row-1] objectForKey:@"cun_name"] forState: UIControlStateNormal ];
        }

    }
    else{
         //点击列表，详情
         [self performSegueWithIdentifier:@"ZhiyuanFuwuToFuwuInfo" sender:SearchShowArr[indexPath.row]];//log详情
    }
}



-(void)getCunData:(NSString *)ZJD_ID{
    [MBProgressHUD showMessage:@"获取该镇的村列表"];
    //获取下属单位
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:ZJD_ID forKey:@"zjd_id"];
    [[HttpClient httpClient] requestWithPath:@"/GetCUNIndexByID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _CUNArr = (NSArray *)[jsonData objectFromJSONData];

        [_CUNTable reloadData];
         _CUNBtn.enabled = YES;//可选
        MyLog(@"村%@",_CUNArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        MyLog(@"***%@",error);
    }];
}



//点击镇街道
- (IBAction)clickZJDBtn:(id)sender{
    //弹框
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择镇/街道" message:@""];
    alert.contentView =  _ZJDTable;
    
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
    
}
- (IBAction)clickCUNBtn:(id)sender{
    alert = [[JKAlertDialog alloc]initWithTitle:@"选择村/社区" message:@""];
    alert.contentView =  _CUNTable;
    [alert addButtonWithTitle:@"取消"];
    
    [alert show];
}
- (IBAction)clickSearchBtn:(id)sender{
    page = 1;
    [self getViewData];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FuwuInfoVC *fuwuVC = segue.destinationViewController;
    fuwuVC.infoDic = sender;
}


@end
