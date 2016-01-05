//
//  GanbuLocationVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/31.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "GanbuLocationVC.h"

@interface GanbuLocationVC ()
{ BMKPointAnnotation* pointAnnotation;
    
}
@end

@implementation GanbuLocationVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地理信息";
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_mapView];
    NSString *latitudeStr = [_infoDic objectForKey:@"placeLatitude"];
    float latitude = latitudeStr.doubleValue;
    
    NSString *longitudeStr = [_infoDic objectForKey:@"placeLongitude"];
    float longitude = longitudeStr.doubleValue;
    
    
    if (pointAnnotation == nil&&(!ISNULLSTR(latitudeStr))&&(!ISNULLSTR(longitudeStr)) ) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = latitude;
        coor.longitude = longitude;
        pointAnnotation.coordinate = coor;
        [_mapView setCenterCoordinate:coor];
        pointAnnotation.title = [NSString stringWithFormat:@"走访农户：%@",[_infoDic objectForKey:@"rz_zfnh_name"]];
    }
    
    [_mapView addAnnotation:pointAnnotation];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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
