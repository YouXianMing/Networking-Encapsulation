//
//  WeatherDataSerializer.m
//  AFNetworking-3.x
//
//  Created by YouXianMing on 16/3/12.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "WeatherDataSerializer.h"
#import "WeatherInfoModel.h"

@implementation WeatherDataSerializer

- (id)serializeResponseData:(id)data {

    return [[WeatherInfoModel alloc] initWithDictionary:data];
}

@end
