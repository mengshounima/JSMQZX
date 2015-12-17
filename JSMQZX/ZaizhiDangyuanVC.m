//
//  ZaizhiDangyuanVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/17.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "ZaizhiDangyuanVC.h"

@interface ZaizhiDangyuanVC ()<UITableViewDataSource,UITableViewDelegate>
{
    JKAlertDialog *alert;
    UITableView *_DWXiaShuTable;
    UITableView *_DWQiTaTable;
    
    NSMutableArray *LogArr;//所有数据结果
    NSMutableArray *SearchShowArr;//搜索结果
    NSInteger rowscount;
    NSInteger page;

}
@property (nonatomic,strong) NSArray *DWXiaShuArr;
@property (nonatomic,strong) NSArray *DWQiTaArr;
@end

@implementation ZaizhiDangyuanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getViewData];
}
-(void)getViewData{
    [MBProgressHUD showMessage:@"构建页面"];
    //获取下属单位
    NSMutableDictionary *paramZJD = [[NSMutableDictionary alloc] init];
    [paramZJD setObject:@"1" forKey:@"Type"];
    [paramZJD setObject:[UserInfo sharedInstance].useID forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetDWIndex" method:TBHttpRequestPost parameters:paramZJD prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        _DWXiaShuArr = [jsonData objectFromJSONData];
        MyLog(@"---**--%@",_DWXiaShuArr);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//其他党委GetDWIndex  下属type=1
//机关下属党委
//党员报到GetDYBDIndexPage
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
