//
//  ViewController.h
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/24/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@end

