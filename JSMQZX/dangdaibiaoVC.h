//
//  dangdaibiaoVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/26.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "DangdaibiaoInfoVC.h"
@interface dangdaibiaoVC : UIViewController
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *_mySearchBar;
}
@property (weak, nonatomic) IBOutlet UITableView *myTable;



@end
