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
#import "CoreDataManager.h"
#import "NSString+Localize.h"

#import "City.h"
#import "MapPrice.h"
#import "FavoriteMapPrice+CoreDataClass.h"
#import "PointAnnotationMapPrice.h"

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) City *origin;
@property (nonatomic, copy) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [@"map_tab" localize];
    
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    PointAnnotationMapPrice *an = (PointAnnotationMapPrice *)view.annotation;
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:[@"actions_with_tickets" localize] message:[@"actions_with_tickets_describe" localize] preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action;
//    MapPrice *price = [self.prices objectAtIndex:(unsigned)an.index];
    MapPrice *price = an.price;
    CoreDataManager *manager = [CoreDataManager sharedInstance];
    if ([manager isFavoriteMapPrice:price]) {
        action = [UIAlertAction actionWithTitle:[@"remove_from_favorite" localize] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [manager removeFromFavoriteMapPrice:price];
            [mapView deselectAnnotation:view.annotation animated:YES];
        }];
    } else {
        action = [UIAlertAction actionWithTitle:[@"add_to_favorite" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [manager addToFavoriteMapPrice:price];
            [mapView deselectAnnotation:view.annotation animated:YES];
        }];
    }
    [sheet addAction:action];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [mapView deselectAnnotation:view.annotation animated:YES];
    }];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)setPrices:(NSArray *)prices {
    _prices = [prices copy];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (MapPrice *price in prices) {
        PointAnnotationMapPrice *annotation = [PointAnnotationMapPrice new];
        annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
        annotation.subtitle = [NSString stringWithFormat:@"%ld ₽", (long)price.value];
        annotation.coordinate = price.destination.coordinate;
        annotation.index = (NSInteger *)[prices indexOfObject:price];
        annotation.price = price;
        [self.mapView addAnnotation:annotation];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
