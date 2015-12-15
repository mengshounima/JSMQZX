//
//  MinQinRiZhiTableVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/8.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "MinQinRiZhiTableVC.h"

@interface MinQinRiZhiTableVC ()

@end

@implementation MinQinRiZhiTableVC

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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"MinQinCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"随机走访";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"联系结对农户";
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"未走访农户";
    }
    else{
        cell.textLabel.text = @"已走访农户";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //添加走访日志
        [self performSegueWithIdentifier:@"MinQinRiZhiToAddVisitLog" sender:nil];
    }
    else if (indexPath.row == 1){
        //联系结对农户 1
        [self performSegueWithIdentifier:@"MinQinRiZhiToSelectFarmer" sender:[NSNumber numberWithInteger:1]];
    }
    else if (indexPath.row == 2){
        //未走访 3
        [self performSegueWithIdentifier:@"MinQinRiZhiToSelectFarmer" sender:[NSNumber numberWithInteger:3]];
    }
    else{
        //已走访 2
        [self performSegueWithIdentifier:@"MinQinRiZhiToSelectFarmer" sender:[NSNumber numberWithInteger:2]];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MinQinRiZhiToAddVisitLog"]) {
        AddVisitLogVC *addVisit = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"MinQinRiZhiToSelectFarmer"]){
        SelectFarmerVC *farmers = segue.destinationViewController;
        farmers.flagPeopleSelect = sender;//结对,未走访，已走访
    }
}


@end
