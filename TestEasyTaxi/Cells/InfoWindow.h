//
//  InfoWindow.h
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/28/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoWindow : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelDriverName;
@property (strong, nonatomic) IBOutlet UILabel *labelDriverCar;
@property (strong, nonatomic) IBOutlet UILabel *labelAddress;

@end
