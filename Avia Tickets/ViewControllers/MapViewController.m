//
//  MapViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 19.01.2021.
//

#import <MapKit/MapKit.h>

#import "MapViewController.h"

#import "APIManager.h"
#import "DataManager.h"
#import "LocationManager.h"

#import "City.h"
#import "MapPrice.h"


@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) City *origin;
@property (nonatomic, copy) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Prices map";
    
    MKMapView *map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    map.delegate = self;
    map.showsUserLocation = YES;
    [self.view addSubview:map];
    self.mapView = map;
    
    [[DataManager sharedInstance] loadData];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(didLoadData) name:kDataManagerLoadDataDidComplete object:nil];
    [nc addObserver:self selector:@selector(didUpdateLocation:) name:kLocationManagerDidUpdateLocation object:nil];
}

- (void)didLoadData {
    self.locationManager = [LocationManager new];
}

- (void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
    
    if (currentLocation) {
        self.origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if(self.origin) {
            [[APIManager sharedInstance] mapPriceFor:self.origin withCompletion:^(NSArray * _Nonnull prices) {
                self.prices = prices;
            }];
        }
    }
}

- (void)setPrices:(NSArray *)prices {
    _prices = [prices copy];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (MapPrice *price in prices) {
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
        annotation.subtitle = [NSString stringWithFormat:@"%ld ₽", (long)price.value];
        annotation.coordinate = price.destination.coordinate;
        [self.mapView addAnnotation:annotation];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
