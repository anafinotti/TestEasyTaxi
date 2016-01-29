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
    
    
    
    NSString* serverAddress = [Utils getConfigurationValueForKey:@"serverAddress"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSTimeInterval timeInterval = 15;
    manager.requestSerializer.timeoutInterval = timeInterval;
    
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

-(NSString*)getFormatterAddressFromGoogleApi:(double)latitude
                              longitude:(double)longitude
{
    NSString *url = [Utils getConfigurationValueForKey:@"apiGoogleGetAddress"];
    
    NSString *geocodeApiUrl = [NSString stringWithFormat:url, latitude, longitude];
    
    NSLog(@"URL: %@",geocodeApiUrl);
    geocodeApiUrl = [geocodeApiUrl stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:geocodeApiUrl]];
    
    NSError *error;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    NSArray<NSDictionary *> *formattedAddressArray = [[jsonDict valueForKey:@"results"] valueForKey:@"formatted_address"];
    
    return [NSString stringWithFormat:@"%@,", [formattedAddressArray firstObject]];
    
}
@end
