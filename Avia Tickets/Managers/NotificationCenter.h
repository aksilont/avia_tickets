//
//  NotificationCenter.h
//  Avia Tickets
//
//  Created by Aksilont on 05.02.2021.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct Notification {
    __unsafe_unretained NSString * _Nullable title;
    __unsafe_unretained NSString * _Nonnull body;
    __unsafe_unretained NSDate * _Nonnull date;
    __unsafe_unretained NSURL * _Nullable imageURL;
} Notification;

@interface NotificationCenter : NSObject

+ (instancetype _Nonnull)sharedInstance;

- (void)registerService;
- (void)sendNotification:(Notification)notification;

Notification notificationMake(NSString * _Nullable title, NSString * _Nonnull body, NSDate * _Nonnull date, NSURL * _Nullable imageURL);

@end

NS_ASSUME_NONNULL_END
