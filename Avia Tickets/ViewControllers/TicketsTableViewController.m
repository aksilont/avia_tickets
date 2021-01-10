//
//  TicketsTableViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 10.01.2021.
//

#import "TicketsTableViewController.h"
#import "TicketTableViewCell.h"

@interface TicketsTableViewController ()

@property (nonatomic, strong) NSArray *tickets;

@end

@implementation TicketsTableViewController

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super self];
    if (self) {
        self.tickets = tickets;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tickets";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:TicketTableViewCell.class forCellReuseIdentifier:[TicketTableViewCell identifier]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TicketTableViewCell identifier] forIndexPath:indexPath];
    cell.ticket = self.tickets[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

@end
