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
#import "InfoWindow.h"
#import "SVProgressHUD.h"
#import <GoogleMaps/GoogleMaps.h>


@interface ViewController () {
    NSMutableArray *googlePins;
}
@end

@implementation ViewController {
    BOOL firstLocationUpdate_;
}
#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSearchBar];

    [self startUpdatingLocation];
    
    [self setGoogleMap];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObservers];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeObservers];
    // Implement here if the view has registered KVO

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark SearchBar

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

#pragma mark KVO
-(void)addObservers {
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
}

-(void)removeObservers {
    [self.mapView removeObserver:self forKeyPath:@"myLocation"];
}

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

#pragma mark Current Location

-(void)startUpdatingLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}


- (NSString *)deviceLocation
{
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    return theLocation;
}


#pragma mark GMSMapViewDelegate

-(void)setGoogleMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.locationManager.location.coordinate.latitude
                                                            longitude:self.locationManager.location.coordinate.longitude
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.delegate = self;

    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    
    marker.icon = [Utils image:[UIImage imageNamed:@"pinHome"] scaledToSize:CGSizeMake(50.0f, 50.0f)];
    marker.map = self.mapView;
    marker.userData = @{ @"driverName":@"Home" };
    marker.title = @"Current location";
    self.view = self.mapView;
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    NSLog(@"marker info Window >>>>>>");
    

    
    LocationService *svc = [[LocationService alloc] init];
    NSString *address = [svc getFormatterAddressFromGoogleApi:marker.position.latitude longitude:marker.position.longitude];
    
    InfoWindow *view =  [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 2.0f;
    view.labelDriverName.text = [marker.userData objectForKey:@"driverName"];
    view.labelDriverCar.text = [marker.userData objectForKey:@"driverCar"];
    view.labelAddress.text = address;
    
   
    
    return view;
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    NSLog(@"Did Tap Marker >>>>>>");
    
    [mapView setSelectedMarker:marker];
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    bounds = [bounds includingCoordinate:marker.position];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                                            longitude:marker.position.longitude
                                                                 zoom:18];
    
    [self.mapView animateToCameraPosition:camera];
    return YES;
}

#pragma mark CLLocationManager delegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
      if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        self.mapView.myLocationEnabled = YES;
        self.mapView.settings.myLocationButton = YES;
    }
}

-(NSString *)getAddress:(double)latitude
              longitude:(double)longitude {
    
    LocationService *svc = [[LocationService alloc] init];
    return  [svc getFormatterAddressFromGoogleApi:latitude longitude:longitude];
}

#pragma mark UISearchBar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search button clicked");

    [searchBar resignFirstResponder];
    
    [self.mapView clear];
    
    [self removeObservers];
    [self setGoogleMap];
    [self addObservers];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [SVProgressHUD showWithStatus:@"Carregando..."];
    [geocoder geocodeAddressString:searchBar.text inRegion:nil
                 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                     
                     CLPlacemark *myPlacemark = [placemarks firstObject];
                     
                     CLLocation *location = myPlacemark.location;
                     
                     [LocationService getTaxis:location.coordinate.latitude
                                     longitude:location.coordinate.longitude
                                       success:^(Taxis *taxis) {
                                           
                                           GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
                                           
                                           googlePins = [[NSMutableArray alloc] init];
                                           
                                           if([taxis.taxis count] > 0) {
                                           
                                               for (Taxi *taxi in taxis.taxis) {
                                                   GMSMarker *marker = [[GMSMarker alloc] init];
                                                   marker.position = CLLocationCoordinate2DMake(taxi.lat, taxi.lng);
                                                   marker.infoWindowAnchor = CGPointMake(0.44f, 0.0f);
                                                   bounds = [bounds includingCoordinate:marker.position];
                                                   marker.map = self.mapView;
                                                   marker.userData = @{ @"driverName":taxi.driverName,
                                                                        @"driverCar":taxi.driverCar};
                                                   
                                                   [googlePins addObject:marker];
                                               }
                                               [SVProgressHUD dismiss];
                                               [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
                                           }
                                           else {
                                               [SVProgressHUD dismiss];
                                               [self showAlert:@"No results found"];
                                               
                                           }
                                           searchBar.text = @"";
                 
                         NSLog(@"success!");
                     } failure:^(NSError *error) {
                         NSLog(@"%@", error);
                         [SVProgressHUD dismiss];
                         [self showAlert:error.localizedDescription];
                     }];
                 }];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}


-(void)showAlert:(NSString*)errorMessage {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Alert"
                                message:errorMessage
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end