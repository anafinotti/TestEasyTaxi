//
//  LocationService.m
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import "LocationService.h"
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
#import "Utils.h"


@implementation LocationService

//TODO
//fazer um bloco de sucesso, para retornar para a viewcontroller.
//mostrar todos os taxis proximos do local pesquisado na search bar.
+(void)getTaxis:(double)latitude
      longitude:(double)longitude
        success:(void (^)(Taxis *taxis))success
        failure:(void (^)(NSError *error))failure
{
    NSNumber*latitudeee = [NSNumber numberWithDouble:latitude]; // (double)latitude;
    NSNumber*lnggg = [NSNumber numberWithDouble:longitude];
    
    
    
    NSString* serverAddress = [Utils getServerAddress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"lat":latitudeee,
                             @"lng": lnggg};
    [manager GET:serverAddress parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSError *error = nil;
        
        NSMutableArray *arrayTaxi = [Taxi arrayOfModelsFromDictionaries:responseObject[@"taxis"] error:&error];

        Taxis *taxis = [[Taxis alloc] init];
        taxis.taxis = arrayTaxi;
        
        success(taxis);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}
@end
