//
//  LocationService.h
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taxis.h"
#import <GoogleMaps/GoogleMaps.h>

@interface LocationService : NSObject

+(void)getTaxis:(double)latitude
      longitude:(double)longitude
        success:(void (^)(Taxis *taxis))success
        failure:(void (^)(NSError *error))failure;

-(NSString*)getFormatterAddressFromGoogleApi:(double)latitude
                                   longitude:(double)longitude;

@end
