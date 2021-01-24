//
//  PlaceViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 02.01.2021.
//

#import "PlaceViewController.h"


#define kReuseIdentifier @"CellIdentifier"

@interface PlaceViewController () <UISearchResultsUpdating>

@property (nonatomic, assign) PlaceType placeType;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, copy) NSArray *currentArray;
@property (nonatomic, copy) NSArray *filteredArray;

@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type {
    self = [super init];
    if (self) {
        self.placeType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.delegate = self;
    table.dataSource = self;
    self.tableView = table;
    [self.view addSubview:table];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.obscuresBackgroundDuringPresentation = NO;
    searchController.searchResultsUpdater = self;
    self.filteredArray = @[];
    
    self.navigationItem.searchController = searchController;
    
    UISegmentedControl *segments = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
    [segments addTarget:self action:@selector(changeSource:) forControlEvents:UIControlEventValueChanged];
    segments.tintColor = [UIColor blackColor];
    segments.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segments;
    self.segmentedControl = segments;
    [self changeSource:segments];
    
    switch (self.placeType) {
        case PlaceTypeArrival:
            self.title = @"Arrival";
            break;
        case PlaceTypeDeparture:
            self.title = @"Departure";
            break;
    }
}

- (void)changeSource:(UISegmentedControl *)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.currentArray = [[DataManager sharedInstance] citites];
            break;
        case 1:
            self.currentArray = [[DataManager sharedInstance] airports];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchController.searchBar.text];
        self.filteredArray = [self.currentArray filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredArray = @[];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredArray.count > 0 ? self.filteredArray.count : self.currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *array = self.filteredArray.count > 0 ? self.filteredArray : self.currentArray;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        City *city = array[indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    } else {
        Airport *airport = array[indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int)self.segmentedControl.selectedSegmentIndex + 1);
    NSArray *array = self.filteredArray.count > 0 ? self.filteredArray : self.currentArray;
    [self.delegate selectPlace:array[indexPath.row] withType:self.placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
