//
//  mailInfoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/19.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "mailInfoVC.h"

@interface mailInfoVC ()
@property (nonatomic,strong) NSDictionary *infoDic;
@end

@implementation mailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
}
-(void)getData{
    [MBProgressHUD showMessage:@"加载中"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *idStr = [[UserInfo sharedInstance] ReadData].useID;
    [param setObject:_IDNum forKey:@"ID"];
    [param setObject:idStr forKey:@"userId"];
    [[HttpClient httpClient] requestWithPath:@"/GetMailInfoByID" method:TBHttpRequestPost parameters:param prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSData* jsonData = [self XMLString:responseObject];
        NSArray *midArr = (NSArray *)[jsonData objectFromJSONData];
        _infoDic = midArr[0];
      
        [self initView];
        
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
    _IDLABEL.text = [NSString stringWithFormat:@"民生留言[ID:%@]",[_infoDic objectForKey:@"ID"]];
    _zhuangtaiL.text = [NSString stringWithFormat:@"信件状态:%@",[_infoDic objectForKey:@"ZT"]];
    _sendPeopleL.text = [NSString stringWithFormat:@"写信人:%@",[_infoDic objectForKey:@"username"]];
    _dateL.text = [NSString stringWithFormat:@"来信时间:%@",[_infoDic objectForKey:@"add_date"]];
    _addressL.text = [NSString stringWithFormat:@"联系地址:%@",[_infoDic objectForKey:@"Address"]];
    _phoneL.text = [NSString stringWithFormat:@"联系电话:%@",[_infoDic objectForKey:@"tel"]];
    _titleL.text = [NSString stringWithFormat:@"受信人:%@",[_infoDic objectForKey:@"sjr_name"]];
    _titleL.text = [NSString stringWithFormat:@"信件主题:%@",[_infoDic objectForKey:@"mail_title"]];
     _contentL.text = [NSString stringWithFormat:@"信件内容:%@",[_infoDic objectForKey:@"mail_content"]];
    _reply.text = [NSString stringWithFormat:@"回复内容:%@",[_infoDic objectForKey:@"REPLY"]];
    
    
    
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
