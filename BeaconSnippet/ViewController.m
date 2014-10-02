//
//  ViewController.m
//  BeaconSnippet
//
//  Created by Abue on 2014/10/02.
//  Copyright (c) 2014年 designium. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initCLLocationManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//CLLocationManger初期化
-(void)initCLLocationManager
{
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        // CLLocationManagerの生成とデリゲートの設定
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        
        // 生成したUUIDからNSUUIDを作成
        NSString *uuid = @"00000000-1C0D-1001-B000-001C4DBB2074";
        
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
        
        // CLBeaconRegionを作成
        self.region = [[CLBeaconRegion alloc]
                       initWithProximityUUID:self.proximityUUID
                       identifier:@"MyBeacon"];
        
        self.region.notifyOnEntry = YES;
        self.region.notifyOnExit = YES;
        self.region.notifyEntryStateOnDisplay = YES;
        
        
        // 領域監視を開始
        [self.manager startMonitoringForRegion:self.region];
        
        // 領域計測開始
        [self.manager startRangingBeaconsInRegion:self.region];
    }
}

// Beaconに入ったときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

// Beaconから出たときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

// Beaconとの状態が確定したときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"CLRegionStateInside");
            break;
        case CLRegionStateOutside:
            NSLog(@"CLRegionStateOutside");
            break;
        case CLRegionStateUnknown:
            NSLog(@"CLRegionStateUnknown");
            break;
        default:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    CLProximity proximity = CLProximityUnknown;
    NSString *proximityString = @"CLProximityUnknown";
    CLLocationAccuracy locationAccuracy = 0.0;
    NSInteger rssi = 0;
    NSNumber* major = @0;
    NSNumber* minor = @0;
    
    // 最初のオブジェクト = 最も近いBeacon
    CLBeacon *beacon = beacons.firstObject;
    
    proximity = beacon.proximity;
    locationAccuracy = beacon.accuracy;
    rssi = beacon.rssi;
    major = beacon.major;
    minor = beacon.minor;
    
    CGFloat alpha = 1.0;
    switch (proximity) {
        case CLProximityUnknown:
            proximityString = @"Unknown";
            alpha = 0.3;
            break;
        case CLProximityImmediate:
            proximityString = @"Immediate";
            alpha = 1.0;
            break;
        case CLProximityNear:
            proximityString = @"Near";
            alpha = 0.8;
            break;
        case CLProximityFar:
            proximityString = @"Far";
            alpha = 0.5;
            break;
        default:
            break;
    }
    
    self.uuidLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@", major];
    self.minorLabel.text = [NSString stringWithFormat:@"%@", minor];
    self.proximityLabel.text = proximityString;
    self.accuracyLabel.text = [NSString stringWithFormat:@"%0.3f", locationAccuracy];
    self.rssiLabel.text = [NSString stringWithFormat:@"%d dB", rssi];
    
    if ([minor isEqualToNumber:@1] && locationAccuracy >=-1) {
        // Beacon A
        self.beaconLabel.text = @"A";
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0.749 blue:1.0 alpha:alpha];
    } else if ([minor isEqualToNumber:@2]) {
        // Beacon B
        self.beaconLabel.text = @"B";
        self.view.backgroundColor = [UIColor colorWithRed:0.604 green:0.804 blue:0.196 alpha:alpha];
    } else if ([minor isEqualToNumber:@3]) {
        // Beacon C
        self.beaconLabel.text = @"C";
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.412 blue:0.706 alpha:alpha];
    } else if ([minor isEqualToNumber:@4]) {
        // Beacon C
        self.beaconLabel.text = @"D";
        self.view.backgroundColor = [UIColor colorWithRed:0.412 green:0.412 blue:0.706 alpha:alpha];
    } else if ([minor isEqualToNumber:@5]) {
        // Beacon C
        self.beaconLabel.text = @"E";
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.706 blue:0.706 alpha:alpha];
    } else {
        self.beaconLabel.text = @"-";
        self.view.backgroundColor = [UIColor colorWithRed:0.663 green:0.663 blue:0.663 alpha:1.0];
    }
    
    self.currentMinor = minor;
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            break;
        default:
            break;
    }
}

@end
