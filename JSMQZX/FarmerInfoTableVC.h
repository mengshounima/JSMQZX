//
//  FarmerInfoTableVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/11.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "AddVisitLogVC.h"
@interface FarmerInfoTableVC : UITableViewController
@property (nonatomic,weak) NSDictionary *farmerInfo;
@property (strong, nonatomic) IBOutlet UITableView *InfoTableVIew;
@property (weak, nonatomic) NSNumber *FlagSuiji ;
@end
