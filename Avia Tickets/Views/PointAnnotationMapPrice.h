//
//  PointAnnotationMapPrice.h
//  Avia Tickets
//
//  Created by Aksilont on 31.01.2021.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MapPrice;

@interface PointAnnotationMapPrice : MKPointAnnotation
@property (nonatomic, nonnull) NSInteger *index;
@property (nonatomic, nonnull) MapPrice *price;
@end

NS_ASSUME_NONNULL_END
