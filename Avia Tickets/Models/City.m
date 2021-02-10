//
//  City.m
//  Avia Tickets
//
//  Created by Aksilont on 27.12.2020.
//

#import "City.h"

@implementation City

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.name = dictionary[@"name"];
        self.timezone = dictionary[@"time_zone"];
        self.translations = dictionary[@"name_translations"];
        self.countryCode = dictionary[@"country_code"];
        self.code = dictionary[@"code"];
        
        NSDictionary *coords = dictionary[@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = coords[@"lon"];
            NSNumber *lat = coords[@"lat"];
            if (lon && ![lon isEqual:[NSNull null]] && lat && ![lat isEqual:[NSNull null]]) {
                self.coordinate = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
            }
        }
        [self localizeName];
    }
    return self;
}

- (void)localizeName {
    if (!self.translations) return;
    NSLocale *locale = [NSLocale currentLocale];
    NSString *localeId = [locale.localeIdentifier substringToIndex:2];
    if (localeId) {
        if ([self.translations valueForKey:localeId]) {
            self.name = [self.translations valueForKey:localeId];
        }
    }
}

@end
