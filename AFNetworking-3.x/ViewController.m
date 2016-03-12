//
//  ViewController.m
//  AFNetworking-3.x
//
//  Created by YouXianMing on 16/3/12.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "ViewController.h"
#import "WeatherDataSerializer.h"
#import "Networking.h"
#import "NetworkingIndicator.h"
#import "NetworkingReachability.h"

typedef enum : NSUInteger {
    
    kForecastDaily = 1000,
    
} ENetworkingTag;

@interface ViewController () <AbsNetworkingDelegate>

@property (nonatomic, strong) Networking  *networking;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [NetworkingIndicator showNetworkActivityIndicator:YES];
    [NetworkingReachability startMonitoring];
    
    // 添加网络监听
    [self addNetworkingObserver];
    
    // 初始化网络请求
    self.networking = [Networking getMethodNetworkingWithUrlString:@"http://api.openweathermap.org/data/2.5/forecast/daily"
                                                 requestDictionary:@{@"lat"   :  @"39.907501",
                                                                     @"lon"   :  @"116.397232",
                                                                     @"APPID" :  @"8781e4ef1c73ff20a180d3d7a42a8c04"}
                                                   requestBodyType:[HttpBodyType type]
                                                  responseDataType:[JsonDataType type]];
    
    // 可以注释掉（设置结果的序列化）
    self.networking.responseDataSerializer = [WeatherDataSerializer new];
    
    self.networking.timeoutInterval = @(10.f);
    self.networking.delegate        = self;
    self.networking.tag             = kForecastDaily;
    [self.networking startRequest];
}

- (void)requestSucess:(AbsNetworking *)networking data:(id)data {
    
    if (networking.tag == kForecastDaily) {
        
        NSLog(@"%@", networking.networkingInfomation);
        NSLog(@"%@", data);
    }
}

- (void)requestFailed:(AbsNetworking *)networking error:(NSError *)error {
    
    if (networking.tag == kForecastDaily) {
        
        NSLog(@"%@", error);
    }
}

#pragma mark - 监听网络状态

- (void)addNetworkingObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEvent:)
                                                 name:NetworkingReachableViaWIFINotification object:nil];
}

- (void)notificationEvent:(id)sender {
    
    NSLog(@"%@", sender);
}

@end
