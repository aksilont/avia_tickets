//
//  TicketTableViewCell.m
//  Avia Tickets
//
//  Created by Aksilont on 10.01.2021.
//

#import "TicketTableViewCell.h"

@interface TicketTableViewCell ()

@property (nonatomic, weak) UIImageView *airlineLogoView;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *placesLabel;
@property (nonatomic, weak) UILabel *dateLabel;

@end

@implementation TicketTableViewCell

+ (NSString *)identifier {
    return @"TicketTableViewCellIdentifier";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end
