//
//  ViewController.m
//  TestEasyTaxi
//
//  Created by Ana Finotti on 1/24/16.
//  Copyright © 2016 Finotti. All rights reserved.
//

#import "ViewController.h"
#import "Taxi.h"

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
    
    marker.map = self.mapView;
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
    NSString *geocodeApiUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];

    NSLog(@"URL: %@",geocodeApiUrl);
    geocodeApiUrl = [geocodeApiUrl stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:geocodeApiUrl]];

    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];

    NSArray<NSDictionary *> *formattedAddressArray = [[jsonDict valueForKey:@"results"] valueForKey:@"formatted_address"];

    NSArray<NSDictionary *> *locationCoordinate = [[jsonDict valueForKey:@"results"] valueForKeyPath:@"geometry.location"];


    for (int i = 0; i < formattedAddressArray.count; i++)
    {
        Taxi *model = [[Taxi alloc] initWithDictionary:[locationCoordinate objectAtIndex:i] error:&error];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(model.lat, model.lng);
        //marker.title = address;
        marker.map = self.mapView;
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search button clicked");
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:searchBar.text inRegion:nil
                 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                     
                     CLPlacemark *myPlacemark = [placemarks firstObject];
                     
                     
                     NSString *countryCode = myPlacemark.ISOcountryCode;
                     NSString *countryName = myPlacemark.country;
                     NSString *city1 = myPlacemark.subLocality;
                     NSString *city2 = myPlacemark.locality;
                 }];

    
}

@end