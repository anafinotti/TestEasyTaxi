//
//  LocationController.m
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import "LocationController.h"
#import "LocationService.h"

@interface LocationController ()

@end

@implementation LocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [LocationService getTaxis:@-22.9855469 longitude:@-46.8520404];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
