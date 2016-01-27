//
//  ViewController.m
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/24/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import "ViewController.h"
#import "LocationService.h"
#import "Taxis.h"
#import "Utils.h"
#import <GoogleMaps/GoogleMaps.h>


@interface ViewController ()

@end

@implementation ViewController {
    BOOL firstLocationUpdate_;
    CLLocation *taxiLocation;
}

-(instancetype)initWithCoordinate:(CLLocation*)location {
    //if(!self)
        //self = ;
    
    taxiLocation = location;
    
    return self;
}

-(void)setTaxiLocation {
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(taxiLocation.coordinate.latitude, taxiLocation.coordinate.longitude);

    marker.map = self.mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSearchBar];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    [self setGoogleMap];
}


-(void)setupSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, 230,44)];
    
    searchBar.delegate = self;
    
    searchBar.placeholder = @"Search";
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    searchBarItem.tag = 123;
    searchBarItem.customView.hidden = YES;
    searchBarItem.customView.alpha = 0.0f;
    self.navigationItem.leftBarButtonItem = searchBarItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem = leftItem;
}

- (void)searchButtonTapped:(id)sender
{
    NSArray *buttonsArray = self.navigationController.navigationBar.topItem.leftBarButtonItems;
    for(UIBarButtonItem *item in buttonsArray)
    {
        if(item.tag == 123 && item.customView.hidden)
        {
            item.customView.hidden = NO;
            if([item.customView isKindOfClass:[UISearchBar class]])
                [item.customView becomeFirstResponder];
            UIBarButtonItem *rightItem = self.navigationController.navigationBar.topItem.rightBarButtonItem;
            [rightItem setTitle:@"Cancel"];
        }
        else
        {
            item.customView.hidden = YES;
            if([item.customView isKindOfClass:[UISearchBar class]])
                [item.customView resignFirstResponder];
            UIBarButtonItem *rightItem = self.navigationController.navigationBar.topItem.rightBarButtonItem;
            
            [rightItem setTitle:@"Search"];
            
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Implement here if the view has registered KVO
    [self.mapView removeObserver:self forKeyPath:@"myLocation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        firstLocationUpdate_ = YES;
        
        CLLocation *location = [object valueForKeyPath:keyPath];
        self.mapView.settings.myLocationButton = YES;
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}

- (NSString *)deviceLocation
{
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    return theLocation;
}


-(void)setGoogleMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.locationManager.location.coordinate.latitude
                                                            longitude:self.locationManager.location.coordinate.longitude
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;

    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    
    marker.icon = [Utils image:[UIImage imageNamed:@"pinHome"] scaledToSize:CGSizeMake(50.0f, 50.0f)];
    marker.map = self.mapView;
    marker.title = @"Current location";
    self.view = self.mapView;
}

#pragma mark LocationManager delegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
      if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        self.mapView.myLocationEnabled = YES;
        self.mapView.settings.myLocationButton = YES;
    }
}


-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSError *error;
    
//    CLLocation *location = [locations firstObject];
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//    //marker.title = address;
//    marker.map = self.mapView;
//    
//    
//    NSString *geocodeApiUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
//
//    NSLog(@"URL: %@",geocodeApiUrl);
//    geocodeApiUrl = [geocodeApiUrl stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//
//    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:geocodeApiUrl]];
//
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
//
//    NSArray<NSDictionary *> *formattedAddressArray = [[jsonDict valueForKey:@"results"] valueForKey:@"formatted_address"];
//
//    NSArray<NSDictionary *> *locationCoordinate = [[jsonDict valueForKey:@"results"] valueForKeyPath:@"geometry.location"];
//
//
//    for (int i = 0; i < formattedAddressArray.count; i++)
//    {
//        NSString* address = [NSString stringWithFormat:@"%@", [formattedAddressArray objectAtIndex:i]];
//        Taxi *model = [[Taxi alloc] initWithDictionary:[locationCoordinate objectAtIndex:i] error:&error];
//        GMSMarker *marker = [[GMSMarker alloc] init];
//        marker.position = CLLocationCoordinate2DMake(model.lat, model.lng);
//        marker.title = address;
//        marker.map = self.mapView;
//    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search button clicked");

    [self.mapView clear];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:searchBar.text inRegion:nil
                 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                     
                     CLPlacemark *myPlacemark = [placemarks firstObject];

                     NSMutableString *address = [NSMutableString stringWithString:myPlacemark.locality];
                     [address appendString:@", "];
                     [address appendString:myPlacemark.subLocality];
                     [address appendString:@"-"];
                     [address appendString:myPlacemark.country];
                     
                     CLLocation *location = myPlacemark.location;
                     
                     [LocationService getTaxis:location.coordinate.latitude
                                     longitude:location.coordinate.longitude
                                       success:^(Taxis *taxis) {
                                           
                                           GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];

                                           for (Taxi *taxi in taxis.taxis) {
                                          
                                            
                                               CLLocation *location = [[CLLocation alloc] initWithLatitude:taxi.lat longitude:taxi.lng];
                                               
                                               GMSMarker *marker = [[GMSMarker alloc] init];
                                               marker.position = CLLocationCoordinate2DMake(taxi.lat, taxi.lng);
                                               marker.title = address;
                                               bounds = [bounds includingCoordinate:marker.position];
                                               marker.map = self.mapView;
                                           }
                                           [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];

                      

                                    
                                           
                                           
                         NSLog(@"success!");
                     } failure:^(NSError *error) {
                         NSLog(@"%@", error);
                     }];
                 }];
}

@end