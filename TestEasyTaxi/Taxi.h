//
//  Taxi.h
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>


@interface Taxi : JSONModel

@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;
@property (nonatomic, strong) NSString <Optional> *driverCar;
@property (nonatomic, strong) NSString <Optional> *driverName;

@end
