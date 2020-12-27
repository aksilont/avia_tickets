//
//  ViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 27.12.2020.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadData) name:kDataManagerLoadDataDidComplete object:nil];
    
    [[DataManager sharedInstance] loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)didLoadData {
    self.view.backgroundColor = [UIColor systemYellowColor];
}

@end
