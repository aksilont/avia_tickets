//
//  FavoriteMapPrice+CoreDataProperties.m
//  Avia Tickets
//
//  Created by Aksilont on 29.01.2021.
//
//

#import "FavoriteMapPrice+CoreDataProperties.h"

@implementation FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
}

@dynamic created;
@dynamic airline;
@dynamic destination;
@dynamic origin;
@dynamic departure;
@dynamic returnDate;
@dynamic value;

@end
