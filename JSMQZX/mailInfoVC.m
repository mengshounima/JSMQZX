//
//  mailInfoVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/19.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "mailInfoVC.h"
#define mailFont [UIFont systemFontOfSize:13]
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
    
    UIScrollView *myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:myScroll];
    UIView *backView = [[UIView alloc] init];
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 5;
    [myScroll addSubview:backView];
    //字体为system14
    _IDLABEL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-36, 20)];
    _IDLABEL.text = [NSString stringWithFormat:@"民生留言[ID:%@]",[_infoDic objectForKey:@"ID"]];
    _IDLABEL.textColor = choiceColor(16, 86, 148);
    _IDLABEL.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_IDLABEL];
    _IDLABEL.font = [UIFont systemFontOfSize:16];
    
    
    float Y = CGRectGetMaxY(_IDLABEL.frame);
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line];
    
    
    _zhuangtaiL =  [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    _zhuangtaiL.text = [NSString stringWithFormat:@"信件状态:%@",[_infoDic objectForKey:@"ZT"]];
    [backView addSubview:_zhuangtaiL];
    _zhuangtaiL.font = mailFont;
    Y = CGRectGetMaxY(_zhuangtaiL.frame);
    //线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line1];
  
    _sendPeopleL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    _sendPeopleL.text = [NSString stringWithFormat:@"写信人:%@",[_infoDic objectForKey:@"username"]];
    [backView addSubview:_sendPeopleL];
    _sendPeopleL.font = mailFont;
    
    Y = CGRectGetMaxY(_sendPeopleL.frame);
    //线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line2];

    _dateL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    _dateL.text = [NSString stringWithFormat:@"来信时间:%@",[_infoDic objectForKey:@"add_date"]];
    [backView addSubview:_dateL];
    _dateL.font = mailFont;
    Y = CGRectGetMaxY(_dateL.frame);
    //线
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line3];
    
    _addressL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    _addressL.text = [NSString stringWithFormat:@"联系地址:%@",[_infoDic objectForKey:@"Address"]];
    [backView addSubview:_addressL];
    _addressL.font = mailFont;
    
    Y = CGRectGetMaxY(_addressL.frame);
    //线
    UIView *line13 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line13.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line13];
    
    _phoneL =  [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    _phoneL.text = [NSString stringWithFormat:@"联系电话:%@",[_infoDic objectForKey:@"tel"]];
    [backView addSubview:_phoneL];
    _phoneL.font = mailFont;
    Y = CGRectGetMaxY(_phoneL.frame);
    //线
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line4];
    
    _toPeopleL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, 20)];
    _toPeopleL.text = [NSString stringWithFormat:@"受信人:%@",[_infoDic objectForKey:@"sjr_name"]];
    [backView addSubview:_toPeopleL];
    _toPeopleL.font = mailFont;
    
    Y = CGRectGetMaxY(_toPeopleL.frame);
    //线
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH-20, 1)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line5];
    
    //主题
    NSString *titleStr = [NSString stringWithFormat:@"信件主题:%@",[_infoDic objectForKey:@"mail_title"]];
    CGSize titleRect = [self sizeWithText:titleStr font:mailFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(8, Y+1, SCREEN_WIDTH-36, titleRect.height)];
    _titleL.font = mailFont;
    _titleL.numberOfLines = 0;
    _titleL.text = titleStr;
    [backView addSubview:_titleL];
    //分割线
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleL.frame), SCREEN_WIDTH-20, 1)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line6];
    
    
    Y = CGRectGetMaxY(_titleL.frame)+1;
    //内容
    NSString *contentStr = [NSString stringWithFormat:@"信件内容:%@",[_infoDic objectForKey:@"mail_content"]];
     CGSize contentRect = [self sizeWithText:contentStr font:mailFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    _contentL = [[UILabel alloc] initWithFrame: CGRectMake(8, Y, SCREEN_WIDTH-36, contentRect.height)];
    _contentL.font = mailFont;
    _contentL.numberOfLines = 0;
    //_contentL.backgroundColor = [UIColor greenColor];
    _contentL.text = contentStr;
    [backView addSubview:_contentL];
    
    //分割线
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentL.frame), SCREEN_WIDTH-20, 1)];
    line7.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line7];
    
    
    Y = CGRectGetMaxY(_contentL.frame)+1;
    //回复内容
    NSString *replyStr = [NSString stringWithFormat:@"回复内容:%@",[_infoDic objectForKey:@"REPLY"]];
     CGSize replyRect = [self sizeWithText:replyStr font:mailFont maxSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)];
    _reply = [[UILabel alloc] initWithFrame:CGRectMake(8, Y, SCREEN_WIDTH-36, replyRect.height)];
    _reply.font = mailFont;
    _reply.numberOfLines = 0;
    //_reply.backgroundColor = [UIColor yellowColor];
    _reply.text = replyStr;
    
    [backView addSubview:_reply];
    
    Y = CGRectGetMaxY(_reply.frame);
    //总高度
    float allHeight = Y+20;
    MyLog(@"%f",allHeight);
    myScroll.contentSize = CGSizeMake(0, allHeight+40);
    
    
    backView.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, allHeight);
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.cornerRadius = 5;
    backView.layer.borderWidth = 1;

    
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
