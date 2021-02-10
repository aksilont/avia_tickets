//
//  ViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 27.12.2020.
//

#import "MainViewController.h"
#import "PlaceViewController.h"
#import "TicketsTableViewController.h"
#import "FirstViewController.h"

#import "DataManager.h"
#import "APIManager.h"
#import "ProgressView.h"
#import "NSString+Localize.h"

#import "SearchRequest.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, weak) UIButton *departureButton;
@property (nonatomic, weak) UIButton *arrivalButton;
@property (nonatomic, weak) UIButton *searchButton;

@property (nonatomic, assign) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self presentFirstViewControllerIfNeeded];
}

- (void)presentFirstViewControllerIfNeeded {
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        FirstViewController *firstVC = [[FirstViewController alloc] initWithTransitionStyle:(UIPageViewControllerTransitionStyleScroll) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:nil];
        firstVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:firstVC animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    self.title = [@"main_search" localize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadData) name:kDataManagerLoadDataDidComplete object:nil];
    
    [[DataManager sharedInstance] loadData];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(20.0, 140.0, self.view.bounds.size.width - 40.0, 170.0)];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    container.layer.shadowRadius = 20.0;
    container.layer.shadowOpacity = 1.0;
    container.layer.cornerRadius = 6.0;
    [self.view addSubview:container];
    
    UIButton *depart = [UIButton buttonWithType:UIButtonTypeSystem];
    [depart addTarget:self action:@selector(didTapPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [depart setTitle:[@"main_from" localize] forState:UIControlStateNormal];
    depart.tintColor = [UIColor blackColor];
    depart.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    depart.layer.cornerRadius = 4.0;
    depart.frame = CGRectMake(10.0, 20.0, container.bounds.size.width - 20.0, 60.0);
    [container addSubview:depart];
    self.departureButton = depart;
    
    UIButton *arrival = [UIButton buttonWithType:UIButtonTypeSystem];
    [arrival addTarget:self action:@selector(didTapPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [arrival setTitle:[@"main_to" localize] forState:UIControlStateNormal];
    arrival.tintColor = [UIColor blackColor];
    arrival.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    arrival.layer.cornerRadius = 4.0;
    arrival.frame = CGRectMake(10.0, CGRectGetMaxY(depart.frame) + 10.0, depart.bounds.size.width, depart.bounds.size.height);
    [container addSubview:arrival];
    self.arrivalButton = arrival;
    
    UIButton *search = [UIButton buttonWithType:UIButtonTypeSystem];
    [search addTarget:self action:@selector(didTapSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [search setTitle:[@"main_search" localize] forState:UIControlStateNormal];
    search.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    search.tintColor = [UIColor whiteColor];
    search.backgroundColor = [UIColor blackColor];
    search.layer.cornerRadius = 8.0;
    search.frame = CGRectMake(30.0, CGRectGetMaxY(container.frame) + 30.0, self.view.bounds.size.width - 60.0, 60.0);
    [self.view addSubview:search];
    self.searchButton = search;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)didLoadData {
    [[APIManager sharedInstance] cityForCurrentIP:^(City * _Nonnull city) {
        [self setPlace:city withType:PlaceTypeDeparture andDataType:DataSourceTypeCity forButton:self.departureButton];
    }];
    
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

- (void)didTapSearchButton:(UIButton *)sender {
    if (self.searchRequest.origin && self.searchRequest.destination) {
        [[ProgressView sharedInstance] show:^{
            [[APIManager sharedInstance] ticketsWithRequest:self.searchRequest withCompletion:^(NSArray * _Nonnull tickets) {
                [[ProgressView sharedInstance] dismiss:^{
                    if (tickets.count > 0) {
                        TicketsTableViewController *vc = [[TicketsTableViewController alloc] initWithTickets:tickets];
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:[@"tickets_not_found" localize] preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }];
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[@"error" localize] message:[@"not_set_place_arrival_or_departure" localize] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }

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
