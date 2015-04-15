//
//  ViewController.h
//  高德地图
//
//  Created by MAC on 15/4/13.
//  Copyright (c) 2015年 SaiDiCaprio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "Connection.h"
#import "ZipArchive.h"
#import "xmlParser.h"
#import "TraTableCell.h"

#define AmapDemoKey @"96400e36181f3e3922cd5978f608f0f0"
#define SCREEN_VIEW_WIDTH self.view.bounds.size.width
#define SCREEN_VIEW_HEIGHT self.view.bounds.size.height
#define kDefaultLocationZoomLevel       16.1
#define TerminalChildKey @"142898880300000402259971"

#define Server            @"http://123.57.72.120:8090/ServerSide/"
#define TerminalParentKey @"User/List?key="
#define getMapTrajectory  @"UserTrail/Download?key="

#define TABLE_ORIGIN_Y  [self originHeight]

@interface ViewController : UIViewController <MAMapViewDelegate,AMapSearchDelegate,responseDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ZipArchive *_zipArchive;
    Connection *_connection;
    xmlParser *_parser;
    
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    NSUserDefaults *_userDefaultsInfo;
    
    CLLocationDegrees _latitudeDegree;
    CLLocationDegrees _longitudeDegree;
    CLLocationCoordinate2D _coordinate;
    CLLocation *_currentLocation;
    
    NSMutableArray *_zipFileList;
    NSMutableArray *_Annotations;
    NSMutableString *_zipPath;
    NSMutableString *_xmlPath;
    NSMutableString *_xmlName;
    
    NSData *_datas;
    
    MAPointAnnotation *_destinationPoint;
    AMapReGeocodeSearchResponse *_AMapresponse;
    
    NSMutableString *_ret;
    NSMutableArray *resultAddress;
    NSTimer *Timer;
    
    UIButton *_locationButton;
    UITableView *ShowTraTable;
    
    int count,count2,count3,_temp_int;
    float Current_Version;
    BOOL isClicked,isShowTracTable;
    
    IBOutlet UIImageView *TitleImage;
    UIButton *ButtonBG;
}

- (IBAction)ShowTraTable;

@end

