//
//  ViewController.m
//  Networking
//
//  Created by YouXianMing on 15/11/6.
//  Copyright © 2015年 ZiPeiYi. All rights reserved.
//

#import "ViewController.h"
#import "V_2_X_Networking.h"
#import "V_2_X_NetworkingReachability.h"
#import "WeatherModelSerializer.h"

@interface ViewController () <NetworkingDelegate>

@property (nonatomic, strong) Networking *networking;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 开始网络请求
    self.networking = [V_2_X_Networking getMethodNetworkingWithUrlString:@"http://api.openweathermap.org/data/2.5/forecast/daily"
                                                       requestDictionary:@{@"lat"   :  @"39.907501",
                                                                           @"lon"   :  @"116.397232",
                                                                           @"APPID" :  @"8781e4ef1c73ff20a180d3d7a42a8c04"}
                                                         requestBodyType:[HttpBodyType type]
                                                        responseDataType:[JsonDataType type]];
    self.networking.delegate = self;
//    self.networking.responseDataSerializer = [WeatherModelSerializer new];
    [self.networking startRequest];
    
    // 监听网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationEvent:)
                                                 name:NetworkingReachableViaWIFINotification
                                               object:nil];
}

- (void)requestSucess:(Networking *)networking data:(id)data {

    NSLog(@"%@", data);
    
    NSLog(@"originalResponseData --> %@", networking.originalResponseData);
    
    NSLog(@"serializerResponseData --> %@", networking.serializerResponseData);
}

- (void)requestFailed:(Networking *)networking error:(NSError *)error {

    NSLog(@"%@", error);
}

- (void)notificationEvent:(id)sender {
    
    NSLog(@"%@", sender);
}

@end
