//
//  APIManager.m
//  Avia Tickets
//
//  Created by Aksilont on 06.01.2021.
//

#import "APIManager.h"
#import "DataManager.h"
#import "Ticket.h"
#import "City.h"

#define API_TOKEN @"​2bc7f38716a185bc1800ad76e4a4c81c"
#define API_URL_IP_ADDRESS @"https://api.ipify.org/?format=json"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="
#define API_URL_CHEAP @"https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_MAP_PRICE @"https://map.aviasales.ru/prices.json?origin_iata="

@implementation APIManager

+ (instancetype)sharedInstance {
    static APIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [APIManager new];
    });
    return instance;
}

- (void)cityForCurrentIP:(void (^)(City *city))completion {
    [self IPAddressWithCompletion:^(NSString *ipAddress) {
        NSString *url = [NSString stringWithFormat:@"%@%@", API_URL_CITY_FROM_IP, ipAddress];
        [self load:url withCompletion:^(id  _Nullable result) {
            City *city;
            if ([result isKindOfClass:NSDictionary.class]) {
                NSDictionary *json = (NSDictionary *)result;
                NSString *iata = json[@"iata"];
                if (iata) {
                    city = [[DataManager sharedInstance] cityForIATA:iata];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(city);
            });
        }];
    }];
}

- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion {
    NSString *url = [NSString stringWithFormat:@"%@?%@&token=%@", API_URL_CHEAP, SearchRequestQuery(request), API_TOKEN];
    [self load:url withCompletion:^(id  _Nullable result) {
        NSMutableArray *tickets;
        if ([result isKindOfClass:NSDictionary.class]) {
            NSDictionary *json = result[@"data"][request.destination];
            tickets = [NSMutableArray new];
            for (NSString *key in json) {
                Ticket *ticket = [[Ticket alloc] initWithDictionary:json[key]];
                ticket.from = request.origin;
                ticket.to = request.destination;
                [tickets addObject:ticket];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(tickets);
        });
    }];
}

- (void)IPAddressWithCompletion:(void (^)(NSString *ipAddress))completion {
    [self load:API_URL_IP_ADDRESS withCompletion:^(id  _Nullable result) {
        if ([result isKindOfClass:NSDictionary.class]) {
            NSDictionary *json = (NSDictionary *)result;
            completion(json[@"ip"]);
        } else {
            completion(nil);
        }
    }];
}

- (void)load:(NSString *)urlsString withCompletion:(void (^)(id _Nullable result))completion {
    NSURL *url = [NSURL URLWithString:urlsString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(result);
        } else {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSLog(@"No data");
            }
            completion(nil);
        }
    }];
    [task resume];
}

NSString * SearchRequestQuery(SearchRequest request) {
    NSString *result = [NSString stringWithFormat:@"origin=%@&destination=%@", request.origin, request.destination];
    if (request.departDate && request.returnDate) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM";
        result = [result stringByAppendingFormat:@"&depart_date=%@&return_date=%@",
                  [formatter stringFromDate:request.departDate],
                  [formatter stringFromDate:request.returnDate]];
    }
    return result;
}

@end



