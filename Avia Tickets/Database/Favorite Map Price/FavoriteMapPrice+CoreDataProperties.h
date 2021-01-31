//
//  FavoriteMapPrice+CoreDataProperties.h
//  Avia Tickets
//
//  Created by Aksilont on 29.01.2021.
//
//

#import "FavoriteMapPrice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSString *destination;
@property (nullable, nonatomic, copy) NSString *origin;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nonatomic) int64_t value;

@end

NS_ASSUME_NONNULL_END
