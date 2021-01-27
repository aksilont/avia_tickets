//
//  TicketTableViewCell.h
//  Avia Tickets
//
//  Created by Aksilont on 10.01.2021.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@class Ticket, FavoriteTicket;

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) FavoriteTicket *favorite;
@property (nonatomic, strong) Ticket *ticket;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
