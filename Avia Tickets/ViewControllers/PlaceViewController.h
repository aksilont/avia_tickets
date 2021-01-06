//
//  PlaceViewController.h
//  Avia Tickets
//
//  Created by Aksilont on 02.01.2021.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"
#import "City.h"
#import "Airport.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PlaceType {
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;

@protocol PlaceViewControllerDelegate <NSObject>

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;

@end

@interface PlaceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<PlaceViewControllerDelegate>delegate;
- (instancetype)initWithType:(PlaceType)type;

@end

NS_ASSUME_NONNULL_END
