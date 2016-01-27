//
//  Taxi.m
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import "Taxi.h"
#import <JSONKeyMapper.h>

@implementation Taxi


+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"driver-car":@"driverCar",
                                                       @"driver-name":@"driverName",
                                                       @"lat":@"lat",
                                                       @"lng":@"lng"}];
}
@end
