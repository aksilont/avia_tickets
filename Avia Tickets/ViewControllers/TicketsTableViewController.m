//
//  TicketsTableViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 10.01.2021.
//

#import "TicketsTableViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataManager.h"

@interface TicketsTableViewController ()

@property (nonatomic, assign) BOOL isFavorites;
@property (nonatomic, strong) NSArray *tickets;

@property (nonatomic, weak) UISegmentedControl *segmentedControl;

@end

@implementation TicketsTableViewController

- (instancetype)initAsFavoriteTickets {
    self = [self initWithTickets:@[]];
    if (self) {
        self.isFavorites = YES;
        UISegmentedControl *segments = [[UISegmentedControl alloc] initWithItems:@[@"Tickets", @"Map prices"]];
        [segments addTarget:self action:@selector(changeSource:) forControlEvents:UIControlEventValueChanged];
        segments.tintColor = [UIColor blackColor];
        segments.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segments;
        self.segmentedControl = segments;
        [self changeSource:segments];
    }
    return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super self];
    if (self) {
        self.tickets = tickets;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isFavorites ? @"Favorites" : @"Tickets";
//    self.navigationController.navigationBar.prefersLargeTitles = self.isFavorites;
//    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:TicketTableViewCell.class forCellReuseIdentifier:[TicketTableViewCell identifier]];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if (self.isFavorites) {
//        self.tickets = [[CoreDataManager sharedInstance] favorites];
//    }
//}

#pragma mark - UI actions

- (void)changeSource:(UISegmentedControl *)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.tickets = [[CoreDataManager sharedInstance] favorites];
            [self.tableView reloadData];
            break;
        case 1:
            self.tickets = [[CoreDataManager sharedInstance] favoriteMapPrices];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TicketTableViewCell identifier] forIndexPath:indexPath];
    if (self.isFavorites) {
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            cell.favorite = self.tickets[indexPath.row];
        } else if (self.segmentedControl.selectedSegmentIndex == 1) {
            cell.favoriteMapPrice = self.tickets[indexPath.row];
        }
    } else {
        cell.ticket = self.tickets[indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFavorites) {
        return;
    }
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Ticket action" message:@"What do you wanna do with the ticket?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cansel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *action;
    Ticket *ticket = self.tickets[indexPath.row];
    CoreDataManager *manager = [CoreDataManager sharedInstance];
    if ([manager isFavorite:ticket]) {
        action = [UIAlertAction actionWithTitle:@"Remove from favorites" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [manager removeFromFavorite:ticket];
        }];
    } else {
        action = [UIAlertAction actionWithTitle:@"Add to favorites" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [manager addToFavorite:ticket];
        }];
    }
    [sheet addAction:action];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

@end
