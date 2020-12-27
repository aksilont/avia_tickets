//
//  Airport.h
//  Avia Tickets
//
//  Created by Aksilont on 27.12.2020.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Airport : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString * timezone;
@property (nonatomic, strong) NSDictionary *translations;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign, getter=isFlightable) BOOL flightable;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
