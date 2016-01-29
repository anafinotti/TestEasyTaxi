//
//  Utils.h
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/25/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+(NSString*)getConfigurationValueForKey:(NSString*)key;
+(UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size;
@end
