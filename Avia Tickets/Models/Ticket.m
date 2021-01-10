//
//  Ticket.m
//  Avia Tickets
//
//  Created by Aksilont on 10.01.2021.
//

#import "Ticket.h"

@implementation Ticket

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.airline = dictionary[@"airline"];
        self.expires = dateFromString(dictionary[@"expires_at"]);
        self.departure = dateFromString(dictionary[@"departure_at"]);
        self.flightNumber = dictionary[@"flight_number"];
        self.price = dictionary[@"price"];
        self.returnDate = dateFromString(dictionary[@"return_at"]);
    }
    return self;
}

NSDate *dateFromString(NSString *dateString) {
    if(!dateString) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *correctStringDate = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    correctStringDate = [correctStringDate stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:correctStringDate];
    
}

@end
