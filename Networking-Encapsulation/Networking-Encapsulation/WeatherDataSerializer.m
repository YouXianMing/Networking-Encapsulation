//
//  WeatherDataSerializer.m
//  Networking-Encapsulation
//
//  Created by YouXianMing on 15/10/23.
//  Copyright © 2015年 ZiPeiYi. All rights reserved.
//

#import "WeatherDataSerializer.h"

@implementation WeatherDataSerializer

- (id)transformResponseDataWithInputData:(id)data {
    
    return [[WeatherInfoModel alloc] initWithDictionary:data];
}

@end
