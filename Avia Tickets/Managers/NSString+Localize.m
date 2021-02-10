//
//  NSString+Localize.m
//  Avia Tickets
//
//  Created by Aksilont on 10.02.2021.
//

#import "NSString+Localize.h"

@implementation NSString(Localize)
- (NSString *)localize {
    return NSLocalizedString(self, "");
}
@end
