//
//  DataManager.h
//  Avia Tickets
//
//  Created by Aksilont on 27.12.2020.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@class City, Airport, Country;

#define kDataManagerLoadDataDidComplete @"​DataManagerLoadDataDidComplete"

typedef enum {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

@interface DataManager : NSObject

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *citites;
@property (nonatomic, strong, readonly) NSArray *airports;

+ (instancetype)sharedInstance;

- (void)loadData;
- (City *)cityForIATA:(NSString *)iata;
- (City *)cityForLocation:(CLLocation *)location;

@end

NS_ASSUME_NONNULL_END
