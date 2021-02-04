//
//  ContentViewController.h
//  Avia Tickets
//
//  Created by Aksilont on 03.02.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : UIViewController

@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) int index;

@end

NS_ASSUME_NONNULL_END
