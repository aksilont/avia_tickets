//
//  CoreDataManager.h
//  Avia Tickets
//
//  Created by Aksilont on 27.01.2021.
//

#import <Foundation/Foundation.h>
#import "FavoriteTicket+CoreDataClass.h"
#import "FavoriteMapPrice+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@class Ticket, MapPrice;

@interface CoreDataManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray<FavoriteTicket *> *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;
- (void)removeFavoriteTicket:(FavoriteTicket *)ticket;


- (BOOL)isFavoriteMapPrice:(MapPrice *)price;
- (NSArray<FavoriteMapPrice *> *)favoriteMapPrices;
- (void)addToFavoriteMapPrice:(MapPrice *)mapPrice;
- (void)removeFromFavoriteMapPrice:(MapPrice *)mapPrice;
- (void)removeFavoriteMapPrice:(FavoriteMapPrice *)mapPrice;

@end

NS_ASSUME_NONNULL_END
