//
//  Taxis.h
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "Taxi.h"

@interface Taxis : JSONModel

@property (nonatomic, strong) NSArray<Taxi *> *taxis;
@end
