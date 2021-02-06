//
//  TicketsTableViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 10.01.2021.
//

#import "TicketsTableViewController.h"
#import "TicketTableViewCell.h"

#import "Ticket.h"

#import "CoreDataManager.h"
#import "NotificationCenter.h"

@interface TicketsTableViewController ()

@property (nonatomic, assign) BOOL isFavorites;
@property (nonatomic, strong) TicketTableViewCell *notificationCell;
@property (nonatomic, strong) NSArray *tickets;

@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, weak) UITextField *dateTextField;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;

@end

@implementation TicketsTableViewController

- (instancetype)initAsFavoriteTickets {
    self = [self init];
    if (self) {
        self.isFavorites = YES;
        self.tickets = @[];
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
    self = [super init];
    if (self) {
        self.tickets = tickets;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isFavorites ? @"Favorites" : @"Tickets";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:TicketTableViewCell.class forCellReuseIdentifier:[TicketTableViewCell identifier]];
    
    if (!self.isFavorites) {
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        picker.minimumDate = [NSDate date];
        self.datePicker = picker;

        UITextField *textField = [[UITextField alloc] initWithFrame:self.view.bounds];
        textField.hidden = YES;
        textField.inputView = picker;

        UIToolbar *keyboardToolbar = [UIToolbar new];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];

        textField.inputAccessoryView = keyboardToolbar;
        self.dateTextField = textField;
        [self.view addSubview:textField];
    }
}

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

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    if (self.datePicker.date && self.notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ by %@ ₽", self.notificationCell.ticket.from, self.notificationCell.ticket.to, self.notificationCell.ticket.price];
        
        NSURL *imageURL;
        if (self.notificationCell.airlineLogoView.image) {
            NSString *airlinePath = [NSString stringWithFormat:@"/%@", self.notificationCell.ticket.airline];
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:airlinePath];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = self.notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        
        Notification notification = notificationMake(@"Notification about ticket", message, self.datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Success"
                                              message:[NSString stringWithFormat:@"Notification will be send at %@", self.datePicker.date]
                                              preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    self.datePicker.date = [NSDate date];
    self.notificationCell = nil;
    [self.view endEditing:YES];
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
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
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
    
    UIAlertAction *notification = [UIAlertAction actionWithTitle:@"Remind me" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.dateTextField becomeFirstResponder];
    }];
    
    [sheet addAction:action];
    [sheet addAction:notification];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

@end
