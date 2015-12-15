//
//  RiZhiBanLiTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/13.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "RiZhiBanLiTableVC.h"

@interface RiZhiBanLiTableVC ()

@end

@implementation RiZhiBanLiTableVC

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"RiZhiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"未办理日志";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"提交上级日志";
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"无诉求日志";
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"已办理日志";
    }
    else if (indexPath.row == 4){
        cell.textLabel.text = @"未评价日志";
    }
    else{
        cell.textLabel.text = @"已经评价日志";
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //未办理日志列表
        [self performSegueWithIdentifier:@"RiZhiBanLiRootToWeiBanli" sender:[NSNumber numberWithInteger:2]];
    }
    else if (indexPath.row == 1 ){
        //提交上级
        [self performSegueWithIdentifier:@"RiZhiBanLiRootToWeiBanli" sender:[NSNumber numberWithInteger:3]];
    }
    else if (indexPath.row == 2 ){
        //无诉求
        [self performSegueWithIdentifier:@"RiZhiBanLiRootToWeiBanli" sender:[NSNumber numberWithInteger:4]];
    }
    else if (indexPath.row == 3 ){
        //已办理
        [self performSegueWithIdentifier:@"RiZhiBanLiRootToWeiBanli" sender:[NSNumber numberWithInteger:1]];
    }
    else if (indexPath.row == 4 ){
        //未评价
        [self performSegueWithIdentifier:@"RiZhiBanLiRootToWeiBanli" sender:[NSNumber numberWithInteger:5]];
    }
    else{
        //已经评价
        [self performSegueWithIdentifier:@"RiZhiBanLiRootToWeiBanli" sender:[NSNumber numberWithInteger:6]];
        }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RiZhiBanLiRootToWeiBanli"]) {
        WeiBanLiVC *weibanli = segue.destinationViewController;
        weibanli.flagLogZT = sender;//未办理日志
    }
}


@end
