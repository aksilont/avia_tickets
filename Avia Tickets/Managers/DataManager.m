//
//  DataManager.m
//  Avia Tickets
//
//  Created by Aksilont on 27.12.2020.
//

#import "DataManager.h"
#import "Country.h"
#import "City.h"
#import "Airport.h"

@implementation DataManager

+ (instancetype)sharedInstance {
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DataManager new];
    });
    return instance;
}

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJSON = [self arrayFromFile:@"countries" ofType:@"json"];
        self->_countries = [self createObjectFromArray:countriesJSON withType:DataSourceTypeCountry];
        NSArray *citiesJSON = [self arrayFromFile:@"cities" ofType:@"json"];
        self->_citites = [self createObjectFromArray:citiesJSON withType:DataSourceTypeCity];
        NSArray *airportsJSON = [self arrayFromFile:@"airports" ofType:@"json"];
        self->_airports = [self createObjectFromArray:airportsJSON withType:DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete object:nil];
        });
        NSLog(@"Data load complete!");
    });
}

- (City *)cityForIATA:(NSString *)iata {
    if (iata) {
        for (City *city in self.citites) {
            if ([city.code isEqualToString:iata]) {
                return city;
            }
        }
    }
    return nil;
}

- (NSArray *)arrayFromFile:(NSString *)filename ofType:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:nil];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (NSMutableArray *)createObjectFromArray:(NSArray *)array withType:(DataSourceType)type {
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *json in array) {
        switch (type) {
            case DataSourceTypeCountry: {
                Country *country = [[Country alloc] initWithDictionary:json];
                [result addObject:country];
                break;
            }
            case DataSourceTypeCity: {
                City *city = [[City alloc] initWithDictionary:json];
                [result addObject:city];
                break;
            }
            case DataSourceTypeAirport: {
                Airport * airport = [[Airport alloc] initWithDictionary:json];
                [result addObject:airport];
                break;
            }
            default:
                break;
        }
    }
    return result;
}

@end
