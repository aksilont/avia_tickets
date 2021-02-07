//
//  CoreDataManager.m
//  Avia Tickets
//
//  Created by Aksilont on 27.01.2021.
//

#import "CoreDataManager.h"
#import "Ticket.h"
#import "MapPrice.h"

@interface CoreDataManager ()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end

@implementation CoreDataManager

+ (instancetype)sharedInstance {
    static CoreDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CoreDataManager new];
    });
    return instance;
}

#pragma mark - Favorite tickets

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (NSArray<FavoriteTicket *> *)favorites {
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    NSError *error;
    request.sortDescriptors = @[
//        [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]
        [NSSortDescriptor sortDescriptorWithKey:@"departure" ascending:YES]
    ];
    
    NSArray *tickets = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return tickets;
}

- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *object = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:self.persistentContainer.viewContext];
    object.price = ticket.price.intValue;
    object.airline = ticket.airline;
    object.departure = ticket.departure;
    object.expires = ticket.expires;
    object.flightNumber = ticket.flightNumber.intValue;
    object.returnDate = ticket.returnDate;
    object.from = ticket.from;
    object.to = ticket.to;
    object.created = [NSDate date];
    [self saveContext];
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *object = [self favoriteFromTicket:ticket];
    if (object) {
        [self.persistentContainer.viewContext deleteObject:object];
        [self saveContext];
    }
}

- (void)removeFavoriteTicket:(FavoriteTicket *)ticket {
    [self.persistentContainer.viewContext deleteObject:ticket];
    [self saveContext];
}

#pragma mark - Favorite tickets Private

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    NSError *error;
    NSString *formatPredicate = @"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld";
    request.predicate = [NSPredicate predicateWithFormat:formatPredicate,
                         (long)ticket.price.integerValue,
                         ticket.airline,
                         ticket.from,
                         ticket.to,
                         ticket.departure,
                         ticket.expires,
                         (long)ticket.flightNumber.integerValue];
    NSArray *tickets = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    return tickets.firstObject;
}

#pragma mark - Favorite map prices

- (BOOL)isFavoriteMapPrice:(MapPrice *)price {
    return [self favoriteFromMapPrice:price] != nil;
}

- (NSArray<FavoriteMapPrice *> *)favoriteMapPrices {
    NSFetchRequest *request = [FavoriteMapPrice fetchRequest];
    NSError *error;
    request.sortDescriptors = @[
//        [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]
        [NSSortDescriptor sortDescriptorWithKey:@"departure" ascending:YES]
    ];
    
    NSArray *mapPrices = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return mapPrices;
}

- (void)addToFavoriteMapPrice:(MapPrice *)mapPrice {
    FavoriteMapPrice *object = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteMapPrice" inManagedObjectContext:self.persistentContainer.viewContext];
    object.created = [NSDate date];
    object.destination = mapPrice.destination.code;
    object.origin = mapPrice.origin.code;
    object.departure = mapPrice.departure;
    object.returnDate = mapPrice.returnDate;
    object.value = mapPrice.value;
    object.airline = mapPrice.airline;
    [self saveContext];
}

- (void)removeFromFavoriteMapPrice:(MapPrice *)mapPrice {
    FavoriteMapPrice *object = [self favoriteFromMapPrice:mapPrice];
    if (object) {
        [self.persistentContainer.viewContext deleteObject:object];
        [self saveContext];
    }
}

- (void)removeFavoriteMapPrice:(FavoriteMapPrice *)mapPrice {
    [self.persistentContainer.viewContext deleteObject:mapPrice];
    [self saveContext];
}
#pragma mark - Favorite map prices Private

- (FavoriteMapPrice *)favoriteFromMapPrice:(MapPrice *)mapPrice {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *request = [FavoriteMapPrice fetchRequest];
    NSError *error;
    NSString *formatPredicate = @"destination == %@ AND origin == %@ AND departure == %@ AND returnDate == %@ AND value == %ld AND airline == %@";
    request.predicate = [NSPredicate predicateWithFormat:formatPredicate,
                         mapPrice.destination.code,
                         mapPrice.origin.code,
                         mapPrice.departure,
                         mapPrice.returnDate,
                         mapPrice.value,
                         mapPrice.airline];
    NSArray *mapPrices = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    return mapPrices.firstObject;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Tickets"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
