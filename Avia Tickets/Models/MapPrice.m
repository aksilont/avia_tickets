//
//  MapPrice.m
//  Avia Tickets
//
//  Created by Aksilont on 18.01.2021.
//

#import "MapPrice.h"
#import "DataManager.h"

@implementation MapPrice

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin:(City *)origin {
    self = [super init];
    if (self) {
        self.destination = [[DataManager sharedInstance] cityForIATA:[dictionary valueForKey:@"destination"]];
        self.origin = origin;
        self.departure = [self dateFromString:dictionary[@"depart_date"]];
        self.returnDate = [self dateFromString:dictionary[@"return_date"]];
        self.numberOfChanges = [dictionary[@"number_of_changes"] integerValue];
        self.value = [dictionary[@"value"] integerValue];
        self.distance = [dictionary[@"distance"] integerValue];
        self.airline = dictionary[@"airline"];
        self.actual = [dictionary[@"actual"] boolValue];
    }
    return self;
}

- (NSDate * _Nullable)dateFromString:(NSString *)dateString {
    if (!dateString) { return nil; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString:dateString];
}

@end
