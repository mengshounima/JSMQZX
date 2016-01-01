//
//  GanbuLocationVC.h
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/31.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface GanbuLocationVC : UIViewController<BMKMapViewDelegate>
@property (nonatomic,weak) NSDictionary *infoDic;//传递参数
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;

@end
