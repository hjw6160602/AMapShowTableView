//
//  ViewController.m
//  高德地图
//
//  Created by MAC on 15/4/13.
//  Copyright (c) 2015年 SaiDiCaprio. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController

#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [self initControls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - init

- (void)initMapView{
    [MAMapServices sharedServices].apiKey = AmapDemoKey;
    float MapViewHeight = TitleImage.frame.size.height+20;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, MapViewHeight, SCREEN_VIEW_WIDTH, SCREEN_VIEW_HEIGHT)];
    _mapView.delegate = self;
    _mapView.compassOrigin = CGPointMake(20, 20);
    _mapView.scaleOrigin = CGPointMake(20, 550);
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
}

- (void)initControls{
    Current_Version = [[UIDevice currentDevice].systemVersion floatValue];
    isShowTracTable = NO;
    ShowTraTable = [[UITableView alloc]init];
    double x = 116.324615;
    double y = 39.999216;
    _longitudeDegree = x;
    _latitudeDegree = y;
    _coordinate.longitude = _longitudeDegree;
    _coordinate.latitude = _latitudeDegree;
    
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(20, 500, 40, 40);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    _locationButton.backgroundColor = [UIColor whiteColor];
    _locationButton.layer.cornerRadius = 5;
    
    [_locationButton addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    isClicked = NO;
    [_mapView addSubview:_locationButton];
    
    
    ShowTraTable.backgroundColor = [UIColor grayColor];
    ShowTraTable.alpha = 0.7;
    ShowTraTable.delegate = self;
    ShowTraTable.dataSource = self;
    ShowTraTable.frame = CGRectMake(SCREEN_VIEW_WIDTH-263, 0, 263, SCREEN_VIEW_HEIGHT-TABLE_ORIGIN_Y);
    
    ButtonBG = [[UIButton alloc]init];
    ButtonBG.frame = CGRectMake(SCREEN_VIEW_WIDTH, 0, SCREEN_VIEW_WIDTH, SCREEN_VIEW_HEIGHT-TABLE_ORIGIN_Y);
    [ButtonBG addTarget:self action:@selector(onButtonBG) forControlEvents:UIControlEventTouchUpInside];

    //ButtonBG.alpha = 0;
    [ButtonBG addSubview:ShowTraTable];
    [_mapView addSubview:ButtonBG];
    resultAddress = [[NSMutableArray alloc]init];
    [self initSandBoxPath];
}

#pragma mark - Actions

- (void)locateAction{
    isClicked = !isClicked;
    if (isClicked){
        [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
        Timer = [NSTimer scheduledTimerWithTimeInterval:10  target:self selector:@selector(initData) userInfo:nil repeats:YES];
        [self initData];
    }
    else{
        [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
        [Timer invalidate];
    }
}

- (IBAction)ShowTraTable {
    if (!isShowTracTable) {
        [UIView animateWithDuration:0.5f animations:^{
            ButtonBG.frame = CGRectMake(0, 0, SCREEN_VIEW_WIDTH, SCREEN_VIEW_HEIGHT-TABLE_ORIGIN_Y);
            //ButtonBG.hidden = YES;
            isShowTracTable = YES;
        } completion:^(BOOL finished) {}];
    }
    else if(isShowTracTable){
        [UIView animateWithDuration:0.5f animations:^{
            ButtonBG.frame = CGRectMake(SCREEN_VIEW_WIDTH, 0, SCREEN_VIEW_WIDTH, SCREEN_VIEW_HEIGHT-TABLE_ORIGIN_Y);
            isShowTracTable = NO;
        } completion:^(BOOL finished) {}];
    }
}

- (void)onButtonBG{
    [UIView animateWithDuration:0.5f animations:^{
        ButtonBG.frame = CGRectMake(SCREEN_VIEW_WIDTH, 0, SCREEN_VIEW_WIDTH, SCREEN_VIEW_HEIGHT-TABLE_ORIGIN_Y);
        isShowTracTable = NO;
    } completion:^(BOOL finished) {}];
}

- (void)initSandBoxPath{
    NSString *tmpDir =  NSTemporaryDirectory();
    _zipPath = [NSMutableString new];
    _xmlPath = [NSMutableString new];
    _xmlName = [NSMutableString new];
    [_zipPath appendString:tmpDir];
    [_xmlPath appendString:tmpDir];
    _xmlName = _xmlPath;
    [_zipPath appendString:@"Download.zip"];
    NSLog(@"%@\n%@\n",_zipPath,_xmlPath);
}

- (void)initData{
    _connection = [[Connection alloc]init];
    _userDefaultsInfo = [NSUserDefaults standardUserDefaults];
    [self initConnection];
}

- (void)initConnection{
    NSString *httpBody =[[NSString alloc] initWithFormat: @"{\"begintime\":\"%d\",\"endtime\":\"%d\",\"key\":\"%@\",\"max\":\"100\"}",0,0,TerminalChildKey];
    
    NSLog(@"%@",httpBody);
    NSMutableString *URL = [[NSMutableString alloc]init];
    
    [URL appendString:Server];
    [URL appendString:getMapTrajectory];
    [URL appendString:TerminalParentKey];
    
    NSLog(@"%@",URL);
    [_connection postRequest:URL HTTPBody:httpBody delegate:self typeid:0];
}

#pragma mark - 响应委托回调
- (void) onResponseResult:(NSString*)errorID Data:(NSData *)Data{
    if([errorID isEqual:@"0"] || errorID==nil){
        _datas = Data;
        [_connection Write2File:_zipPath data:_datas];
        [self unzipDownloadData];
    }
    //跳过服务器返回数据，直接显示轨迹地图＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝/
    [self initXMLData];
}

- (void)unzipDownloadData{
    [_connection Write2File:_zipPath data:_connection.datas];
    _zipArchive = [[ZipArchive alloc]init];
    if ([_zipArchive UnzipOpenFile:_zipPath]){
        NSLog(@"打开压缩文件成功！");
        if ([_zipArchive UnzipFileTo:_xmlPath overWrite:YES]){
            NSLog(@"解压成功！");
            if ([_zipArchive UnzipCloseFile])
                NSLog(@"关闭压缩文件成功！");
            else NSLog(@"关闭压缩文件失败！");
        }
        else NSLog(@"解压失败！");
    }
    else NSLog(@"打开压缩文件失败！");
    _zipFileList = [NSMutableArray new];
    _zipFileList = [_zipArchive getList];
    NSLog(@"已为您解压文件：\n%@",_zipFileList);
    [self initXMLData];
}

- (void) initXMLData {
    _parser = [[xmlParser alloc]init];
//    NSString *tempDir = NSTemporaryDirectory();
//    NSMutableString *xmlName = [[NSMutableString alloc]init];
//    [xmlName appendString:tempDir];
//    [xmlName appendString:[_zipFileList objectAtIndex:0]];
//    
//    NSLog(@"%@",xmlName);
//    NSError *error;
//    NSString *xmlString = [[NSString alloc] initWithContentsOfFile:xmlName encoding:NSUTF8StringEncoding error:&error];
//    NSLog(@"\n%@",xmlString);
//    [_parser startAnalysis:xmlString];
    [_parser startAnalysis:@"location.xml"];
    NSLog(@"xml解析完成...");
    NSLog(@"[_parser.pos count]:%lu",(unsigned long)[_parser.pos count]);
    count = 0;
    [self locate];
}

- (void)locate{
    _Annotations = [_Annotations init];
    NSString *longitude = [_parser.pos[count] valueForKey:@"x"];
    NSString *latitude = [_parser.pos[count] valueForKey:@"y"];
    double x = [longitude doubleValue];
    double y = [latitude doubleValue];
    
    _longitudeDegree = x;
    _latitudeDegree = y;
    _coordinate.longitude = _longitudeDegree;
    _coordinate.latitude = _latitudeDegree;
    
    //传入坐标数据，开始进行反编码
    [self reGeoAction: _coordinate];
}

- (void)reGeoAction : (CLLocationCoordinate2D) coordinate{
    _search = [[AMapSearchAPI alloc] initWithSearchKey:AmapDemoKey Delegate:self];
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [_search AMapReGoecodeSearch:request];
}

- (void)addDestinationAnnotation : (CLLocationCoordinate2D) coordinate{
    // 添加标注

}

//设置bubble的subtitle
- (NSString *) bubbleTitle{
    NSString *province, *city, *district, *street, *streetNo;
    
    province = _AMapresponse.regeocode.addressComponent.province;
    city = _AMapresponse.regeocode.addressComponent.city;
    district = _AMapresponse.regeocode.addressComponent.district;
    street = _AMapresponse.regeocode.addressComponent.streetNumber.street;
    streetNo = _AMapresponse.regeocode.addressComponent.streetNumber.number;
    //私有变量 字符串数组初始化
    _ret=[[NSMutableString alloc]init];
    if(province)
        [_ret appendString:province];
    if(![city isEqual:@""] && province)
        [_ret appendString:@", "];
    if(city)
        [_ret appendString:city];
    if(![province isEqual:@""] && district)
        [_ret appendString:@", "];
    if(district)
        [_ret appendString:district];
    
    if(street && (city || province))
        [_ret appendString:@" ● "];
    if(street)
        [_ret appendString:street];
    if(streetNo)
       if (streetNo.length == 1)
            [_ret appendFormat:@"%@号", streetNo];
    return _ret;
}

#pragma mark - AMapSearchDelegate

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    _AMapresponse = response;

    _destinationPoint = [[MAPointAnnotation alloc] init];
    _destinationPoint.coordinate = _coordinate;
    _destinationPoint.title = [self bubbleTitle];
    
    NSDictionary *addressDic = [[NSDictionary alloc]init];
    addressDic = [_parser.pos objectAtIndex:count];
    NSString* time_string = [addressDic objectForKey:@"time"];
    double unixTimeStamp = [time_string doubleValue];
    NSTimeInterval _interval=unixTimeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDate *yesterdayDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] - 24*3600)];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeOrigin= [_formatter stringFromDate:date];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *yesterdayStr = [_formatter stringFromDate:yesterdayDate];
    NSString *timeDate = [_formatter stringFromDate:date];
    NSString *currentTime = [_formatter stringFromDate:[NSDate date]];
    NSString *clockTime = [timeOrigin substringFromIndex:10];
    NSString *Addresstime = [[NSString alloc]init];
    
    if ([timeDate isEqualToString:currentTime])
        Addresstime = [NSString stringWithFormat:@"今天%@",clockTime];
    else if([timeDate isEqualToString:yesterdayStr])
        Addresstime = [NSString stringWithFormat:@"昨天%@",clockTime];
    else
        Addresstime = timeOrigin;
    _destinationPoint.subtitle = Addresstime;

    NSString *title = _destinationPoint.title;
    NSString *result_address = [NSString stringWithFormat:@"%@\n%@",Addresstime,title];
    NSMutableDictionary *resultAddressDic = [[NSMutableDictionary alloc]init];;
    [resultAddressDic setObject:result_address forKey:@"result_Address"];
    
    [resultAddress addObject:resultAddressDic];
    
    [_mapView addAnnotation:_destinationPoint];
    
    if (count < [_parser.pos count]-1)  {
        count++;
        [self locate];
    }
    if (count == [_parser.pos count]-1) {
        [ShowTraTable reloadData];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if (annotation == _destinationPoint)
    {
        static NSString *reuseIndetifier = @"startAnnotationReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        //annotationView.image = [UIImage imageNamed:@"location"];
        
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        annotationView.centerOffset = CGPointMake(0, -18);
        
        return annotationView;
    }
    return nil;
}

#pragma mark - UITableViewDataSource @required
//回调次数为Section条目个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == ShowTraTable){
        NSInteger temp = [resultAddress count];
        if (temp >=100) {
            return 100;
        }
        return temp;
    }
    else return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger num = [resultAddress count];
    
    if (count2 >= num) {
        count2=0;
    }
    
    TraTableCell *cell = [TraTableCell cellWithTableView:tableView];
    NSDictionary *temp_Dictionary = [[NSDictionary alloc]init];
    temp_Dictionary = [resultAddress objectAtIndex:count2];
    
    cell.LabelCell.text = [temp_Dictionary objectForKey:@"result_Address"];
    count2 ++;
    return cell;
    
}

- (int)originHeight
{
    if (Current_Version >6.0 && Current_Version<7.0) {
        return 44;
    }
    else{
        return 64;
    }
}

@end
