//
//  LocationService.h
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationService : NSObject

+(void)getTaxis:(NSNumber *)latitude
      longitude:(NSNumber *)longitude;
@end
