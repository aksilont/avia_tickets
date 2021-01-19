//
//  APIManager.h
//  Avia Tickets
//
//  Created by Aksilont on 06.01.2021.
//

#import <Foundation/Foundation.h>
#import "SearchRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class City;

@interface APIManager : NSObject

+ (instancetype)sharedInstance;

- (void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
- (void)mapPriceFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion;

@end

NS_ASSUME_NONNULL_END
