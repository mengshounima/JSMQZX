//
//  HelperVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/5.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import "HelperVC.h"

@interface HelperVC ()

@end

@implementation HelperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"使用帮助";

    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:webV];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    if (_flagHelp.intValue==3) {
        //镇管理员
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"Help-3"
                                                              ofType:@"htm"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        MyLog(@"路径：%@",htmlPath);
        MyLog(@"内容：%@",htmlCont);
        [webV loadHTMLString:htmlCont baseURL:baseURL];
    }
    else if (_flagHelp.intValue==1) {
        //管理员
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"Help-4"
                                                              ofType:@"htm"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [webV loadHTMLString:htmlCont baseURL:baseURL];
    }
    else{
        //一般用户
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"Help-2"
                                                              ofType:@"htm"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [webV loadHTMLString:htmlCont baseURL:baseURL];

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
