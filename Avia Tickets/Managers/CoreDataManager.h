//
//  CoreDataManager.h
//  Avia Tickets
//
//  Created by Aksilont on 27.01.2021.
//

#import <Foundation/Foundation.h>
#import "FavoriteTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@class Ticket;

@interface CoreDataManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray<FavoriteTicket *> *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

@end

NS_ASSUME_NONNULL_END
