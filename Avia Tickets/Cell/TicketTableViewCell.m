//
//  TicketTableViewCell.m
//  Avia Tickets
//
//  Created by Aksilont on 10.01.2021.
//

#import "TicketTableViewCell.h"

#import <YYWebImage/YYWebImage.h>

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
        self.contentView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *price = [[UILabel alloc] initWithFrame:self.bounds];
        price.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:price];
        self.priceLabel = price;
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:self.bounds];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:logo];
        self.airlineLogoView = logo;
        
        UILabel *places = [[UILabel alloc] initWithFrame:self.bounds];
        places.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
        places.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:places];
        self.placesLabel = places;
        
        UILabel *date = [[UILabel alloc] initWithFrame:self.bounds];
        date.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        [self.contentView addSubview:date];
        self.dateLabel = date;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    self.priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    self.airlineLogoView.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    self.placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(self.priceLabel.frame) + 16.0, 100.0, 20.0);
    self.dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(self.placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@ ₽", ticket.price];
    self.placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    self.dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    
    NSURL *urlLogo = [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", ticket.airline]];
    [self.airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];

}

@end
