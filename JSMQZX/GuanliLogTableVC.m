//
//  GuanliLogTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/4.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import "GuanliLogTableVC.h"

@interface GuanliLogTableVC ()

@end

@implementation GuanliLogTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"GanbuRizhiRootCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row==0) {
        cell.textLabel.text = @"未办理日志";
    }
    else if (indexPath.row ==1){
        cell.textLabel.text = @"已办理日志";
    }
    else{
        cell.textLabel.text = @"辖区内所有日志";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        [self performSegueWithIdentifier:@"GuanliyuanTableTLogolist" sender:[NSNumber numberWithInteger:0]];
    }
    else if (indexPath.row ==1){
        [self performSegueWithIdentifier:@"GuanliyuanTableTLogolist" sender:[NSNumber numberWithInteger:1]];
    }
    else {
        [self performSegueWithIdentifier:@"GuanliyuanTableTLogolist" sender:[NSNumber numberWithInteger:2]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LogListGanbuVC *ganbuLogList = segue.destinationViewController;
    ganbuLogList.flagLogZT = sender;
}


@end
