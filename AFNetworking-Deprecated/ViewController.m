//
//  ViewController.m
//  AFNetworking-Deprecated
//
//  Created by YouXianMing on 15/11/6.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "ViewController.h"
#import "GetNetworking.h"
#import "WeatherDataSerializer.h"
#import "NetworkingReachability.h"

typedef enum : NSUInteger {
    
    kNetworking,
    
} EFlag;

@interface ViewController () <NetworkingDelegate>

@property (nonatomic, strong) Networking *networking;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self networkingToGetWeatherInfo];
    
    // 监听网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationEvent:)
                                                 name:NetworkingReachableViaWIFINotification
                                               object:nil];
}

- (void)notificationEvent:(id)sender {
    
    NSLog(@"%@", sender);
}

- (void)networkingToGetWeatherInfo {
    
    if (self.networking.isRunning) {
        
        return;
    }
    
    self.networking = [GetNetworking networkingWithUrlString:@"http://api.openweathermap.org/data/2.5/forecast/daily"
                                           requestDictionary:@{@"lat"   :  @"39.907501",
                                                               @"lon"   :  @"116.397232",
                                                               @"APPID" :  @"8781e4ef1c73ff20a180d3d7a42a8c04"}
                                                    delegate:self
                                             timeoutInterval:nil
                                                         tag:kNetworking
                                        requestSerialization:nil
                                       responseSerialization:[AFJSONResponseSerializer serializer]];
    
    self.networking.responseDataSerializer = [WeatherDataSerializer new];
    [self.networking startRequest];
}

#pragma mark - networking delegate method
- (void)requestSucess:(Networking *)networking data:(id)data {
    
    if (networking.tag == kNetworking) {
        
        WeatherInfoModel *model = networking.data;
        NSLog(@"%@", model.city);
    }
}

- (void)requestFailed:(Networking *)networking error:(NSError *)error {
    
    if (networking.tag == kNetworking) {
        
        // todo
    }
}


@end
