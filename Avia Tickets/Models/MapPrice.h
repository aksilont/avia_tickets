//
//  MapPrice.h
//  Avia Tickets
//
//  Created by Aksilont on 18.01.2021.
//

#import <Foundation/Foundation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapPrice : NSObject

@property (nonatomic, strong) City *destination;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSDate *departure;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, assign) NSInteger numberOfChanges;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) BOOL actual;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin:(City *)origin;

@end

NS_ASSUME_NONNULL_END
