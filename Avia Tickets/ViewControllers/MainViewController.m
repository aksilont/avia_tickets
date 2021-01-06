//
//  ViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 27.12.2020.
//

#import "MainViewController.h"
#import "PlaceViewController.h"
#import "DataManager.h"
#import "SearchRequest.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, weak) UIButton *departureButton;
@property (nonatomic, weak) UIButton *arrivalButton;

@property (nonatomic, assign) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Search";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadData) name:kDataManagerLoadDataDidComplete object:nil];
    
    [[DataManager sharedInstance] loadData];
    
    UIButton *depart = [UIButton buttonWithType:UIButtonTypeSystem];
    [depart addTarget:self action:@selector(didTapPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [depart setTitle:@"From" forState:UIControlStateNormal];
    depart.tintColor = [UIColor blackColor];
    depart.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    depart.frame = CGRectMake(30.0, 140.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    [self.view addSubview:depart];
    self.departureButton = depart;
    
    UIButton *arrival = [UIButton buttonWithType:UIButtonTypeSystem];
    [arrival addTarget:self action:@selector(didTapPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [arrival setTitle:@"To" forState:UIControlStateNormal];
    arrival.tintColor = [UIColor blackColor];
    arrival.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    arrival.frame = CGRectMake(30.0, CGRectGetMaxY(depart.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    [self.view addSubview:arrival];
    self.arrivalButton = arrival;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)didLoadData {
//    self.view.backgroundColor = [UIColor systemYellowColor];
}

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place
          withType:placeType
       andDataType:dataType
         forButton:(placeType == PlaceTypeDeparture) ? self.departureButton : self.arrivalButton];
}

- (void)didTapPlaceButton:(UIButton *)sender {
    PlaceViewController *vc;
    if ([sender isEqual:self.departureButton]) {
        vc = [[PlaceViewController alloc] initWithType:PlaceTypeDeparture];
    } else {
        vc = [[PlaceViewController alloc] initWithType:PlaceTypeArrival];
    }
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    
    switch (dataType) {
        case DataSourceTypeCity: {
            City *city = (City *)place;
            title = city.name;
            iata = city.code;
            break;
        }
        case DataSourceTypeAirport: {
            Airport *airport = (Airport *)place;
            title = airport.name;
            iata = airport.code;
            break;
        }
        default:
            break;
    }
    
    if(placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destination = iata;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    
}

@end
