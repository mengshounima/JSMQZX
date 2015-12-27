//
//  mailInfoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/19.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "mailInfoVC.h"
#define mailFont [UIFont systemFontOfSize:14]
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
    NSString *idStr =[[DataCenter sharedInstance] ReadData].UserInfo.useID ;
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
    //字体为system14
        _IDLABEL.text = [NSString stringWithFormat:@"民生留言[ID:%@]",[_infoDic objectForKey:@"ID"]];
    _zhuangtaiL.text = [NSString stringWithFormat:@"信件状态:%@",[_infoDic objectForKey:@"ZT"]];
    _sendPeopleL.text = [NSString stringWithFormat:@"写信人:%@",[_infoDic objectForKey:@"username"]];
    _dateL.text = [NSString stringWithFormat:@"来信时间:%@",[_infoDic objectForKey:@"add_date"]];
    _addressL.text = [NSString stringWithFormat:@"联系地址:%@",[_infoDic objectForKey:@"Address"]];
    _phoneL.text = [NSString stringWithFormat:@"联系电话:%@",[_infoDic objectForKey:@"tel"]];
      _toPeopleL.text = [NSString stringWithFormat:@"受信人:%@",[_infoDic objectForKey:@"sjr_name"]];
    
    float Y = CGRectGetMaxY(_toPeopleL.frame)+1;
    //主题
    NSString *titleStr = [NSString stringWithFormat:@"信件主题:%@",[_infoDic objectForKey:@"mail_title"]];
    CGSize titleRect = [self sizeWithText:titleStr font:mailFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y, SCREEN_WIDTH-36, titleRect.height)];
    _titleL.font = mailFont;
    _titleL.numberOfLines = 0;
    _titleL.text = titleStr;
    //_titleL.backgroundColor = [UIColor redColor];
    [self.backView addSubview:_titleL];
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleL.frame), SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:line];
    
    
    Y = CGRectGetMaxY(_titleL.frame)+1;
    //内容
    NSString *contentStr = [NSString stringWithFormat:@"信件内容:%@",[_infoDic objectForKey:@"mail_content"]];
     CGSize contentRect = [self sizeWithText:contentStr font:mailFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    _contentL = [[UILabel alloc] initWithFrame: CGRectMake(8, Y, SCREEN_WIDTH-36, contentRect.height)];
    _contentL.font = mailFont;
    _contentL.numberOfLines = 0;
    //_contentL.backgroundColor = [UIColor greenColor];
    _contentL.text = contentStr;
    [self.backView addSubview:_contentL];
    
    //分割线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentL.frame), SCREEN_WIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:line1];
    
    
    Y = CGRectGetMaxY(_contentL.frame)+1;
    //回复内容
    NSString *replyStr = [NSString stringWithFormat:@"回复内容:%@",[_infoDic objectForKey:@"REPLY"]];
     CGSize replyRect = [self sizeWithText:replyStr font:mailFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    _reply = [[UILabel alloc] initWithFrame:CGRectMake(8, Y, SCREEN_WIDTH-36, replyRect.height)];
    _reply.font = mailFont;
    _reply.numberOfLines = 0;
    //_reply.backgroundColor = [UIColor yellowColor];
    _reply.text = replyStr;
    
    [self.backView addSubview:_reply];
    
    //总高度
    float allHeight = Y+replyRect.height+20;
    MyLog(@"%f",allHeight);
    _myScrollView.contentSize = CGSizeMake(0, allHeight);
    _backView.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, allHeight);
    _backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _backView.layer.cornerRadius = 5;
    _backView.layer.borderWidth = 1;

    
}
//计算文本尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    MyLog(@"%@",[text class]);
    if (ISNULL(text))
    {
        return CGSizeMake(0, 25);
    }
    else
    {
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
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
