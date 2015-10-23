//
//  NetworkingReachability.m
//  BaseViewControllers
//
//  Created by YouXianMing on 15/8/6.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "NetworkingReachability.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

/**
 *  用于测试网络是否可以连接的基准URL地址
 */
static NSString *reachabeBaseURL = @"http://baidu.com/";

NSString *const NetworkingReachableViaWWANNotification = @"NetworkingReachableViaWWAN";
NSString *const NetworkingReachableViaWIFINotification = @"NetworkingReachableViaWIFI";
NSString *const NetworkingNotReachableNotification     = @"NetworkingNotReachable";

static AFHTTPRequestOperationManager *_managerReachability = nil;
static BOOL                           _canSendMessage      = YES;

@implementation NetworkingReachability

+ (void)initialize {
    
    if (self == [NetworkingReachability class]) {
        
        NSURL *baseURL       = [NSURL URLWithString:reachabeBaseURL];
        _managerReachability = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        
        NSOperationQueue *operationQueue = _managerReachability.operationQueue;
        [_managerReachability.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    [operationQueue setSuspended:NO];
                    if (_canSendMessage == YES) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkingReachableViaWWANNotification
                                                                            object:nil
                                                                          userInfo:nil];
                    }
                    
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    
                    if (_canSendMessage == YES) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkingReachableViaWIFINotification
                                                                            object:nil
                                                                          userInfo:nil];
                    }
                    
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    
                    if (_canSendMessage == YES) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkingNotReachableNotification
                                                                            object:nil
                                                                          userInfo:nil];
                    }
                    
                    break;
            }
        }];
    }
}

+ (void)startMonitoring {
    
    _canSendMessage = YES;
    [_managerReachability.reachabilityManager startMonitoring];
}

+ (void)stopMonitoring {
    
    _canSendMessage = NO;
    [_managerReachability.reachabilityManager stopMonitoring];
}

+ (BOOL)isReachable {
    
    return _managerReachability.reachabilityManager.isReachable;
}

+ (BOOL)isReachableViaWWAN {
    
    return _managerReachability.reachabilityManager.isReachableViaWWAN;
}

+ (BOOL)isReachableViaWiFi {
    
    return _managerReachability.reachabilityManager.isReachableViaWiFi;
}

@end
