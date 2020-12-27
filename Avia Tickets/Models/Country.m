//
//  Country.m
//  Avia Tickets
//
//  Created by Aksilont on 27.12.2020.
//

#import "Country.h"

@implementation Country

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.name = dictionary[@"name"];
        self.currency = dictionary[@"currency"];
        self.translations = dictionary[@"name_translations"];
        self.code = dictionary[@"code"];
    }
    return self;
}

@end
