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

+(UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}
@end
