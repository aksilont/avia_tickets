//
//  TabBarController.m
//  Avia Tickets
//
//  Created by Aksilont on 24.01.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TicketsTableViewController.h"

#import "NSString+Localize.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = [self createViewControllers];
    self.tabBar.tintColor = UIColor.blackColor;
}

- (NSArray<UIViewController *> *)createViewControllers {
    NSMutableArray<UIViewController *> *controllers = [NSMutableArray new];
    
    MainViewController *mainVC = [MainViewController new];
    mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"search_tab" localize]
                                                      image:[UIImage systemImageNamed:@"magnifyingglass.circle"]
                                              selectedImage:[UIImage systemImageNamed:@"magnifyingglass.circle.fill"]];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [controllers addObject:mainNC];
    
    
    MapViewController *mapVC = [MapViewController new];
    mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"map_tab" localize]
                                                      image:[UIImage systemImageNamed:@"map"]
                                              selectedImage:[UIImage systemImageNamed:@"map.fill"]];
//    UINavigationController *mapNC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [controllers addObject:mapVC];
    
    TicketsTableViewController *favoriteVC = [[TicketsTableViewController alloc] initAsFavoriteTickets];
    favoriteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"favorites_tab" localize]
                                                      image:[UIImage systemImageNamed:@"star"]
                                              selectedImage:[UIImage systemImageNamed:@"star.fill"]];
    UINavigationController *favoriteNC = [[UINavigationController alloc] initWithRootViewController:favoriteVC];
    [controllers addObject:favoriteNC];
    
    return controllers;
}

@end
