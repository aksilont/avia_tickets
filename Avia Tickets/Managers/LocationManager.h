//
//  LocationManager.h
//  Avia Tickets
//
//  Created by Aksilont on 18.01.2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLocationManagerDidUpdateLocation @"LocationManagerDidUpdateLocation"

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, readonly) CLLocation *currentLocation;

@end

NS_ASSUME_NONNULL_END
