//
//  WeatherModelSerializer.m
//  Networking
//
//  Created by YouXianMing on 15/11/6.
//  Copyright © 2015年 ZiPeiYi. All rights reserved.
//

#import "WeatherModelSerializer.h"
#import "WeatherInfoModel.h"

@implementation WeatherModelSerializer

- (id)serializeResponseData:(id)data {

    return [[WeatherInfoModel alloc] initWithDictionary:data];
}

@end
