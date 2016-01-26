//
//  Utils.m
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSString*)getServerAddress {
    NSDictionary *mainDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
    
    return [mainDictionary objectForKey:@"serverAddress"];
}
@end
