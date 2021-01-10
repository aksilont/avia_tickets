//
//  SearchRequest.h
//  Avia Tickets
//
//  Created by Aksilont on 03.01.2021.
//

#import <Foundation/Foundation.h>

typedef struct {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destination;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;
