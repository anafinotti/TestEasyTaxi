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
#import "Taxis.h"
#import "Taxi.h"

@implementation LocationService


//TODO
//fazer um bloco de sucesso, para retornar para a viewcontroller.
//mostrar todos os taxis proximos do local pesquisado na search bar.
+(void)getTaxis:(NSNumber *)latitude
      longitude:(NSNumber *)longitude {
    
    NSString* serverAddress = [Utils getServerAddress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"lat": latitude,
                             @"lng": longitude};
    [manager GET:serverAddress parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSError *error = nil;
        Taxis *model = [[Taxis alloc] initWithDictionary:responseObject error:&error];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
