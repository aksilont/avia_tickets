//
//  FirstViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 04.02.2021.
//

#import "FirstViewController.h"
#import "ContentViewController.h"

#define CONTENT_COUNT 4

@interface FirstViewController ()

@property (nonatomic, weak) UIButton *nextButton;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation FirstViewController {
    struct firstContentData {
        __unsafe_unretained NSString *title;
        __unsafe_unretained NSString *contentText;
        __unsafe_unretained NSString *imageName;
    } contentData[CONTENT_COUNT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self createContentDataArray];
    
    self.dataSource = self;
    self.delegate = self;
    ContentViewController *startVC = [self viewControllerAtIndex:0];
    [self setViewControllers:@[startVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];
    
    UIPageControl *pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100.0, self.view.bounds.size.width, 50.0)];
    pageCtrl.numberOfPages = CONTENT_COUNT;
    pageCtrl.currentPage = 0;
    pageCtrl.pageIndicatorTintColor = [UIColor darkGrayColor];
    pageCtrl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:pageCtrl];
    self.pageControl = pageCtrl;
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeSystem];
    next.frame = CGRectMake(self.view.bounds.size.width - 100.0, self.view.bounds.size.height - 100.0, 100.0, 50.0);
    [next addTarget:self action:@selector(nextButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [next setTintColor:[UIColor blackColor]];
    [self.view addSubview:next];
    self.nextButton = next;
    [self updateButtonWithIndex:0];
}

- (void)createContentDataArray {
    NSArray *titles = [NSArray arrayWithObjects:@"About", @"Avia Tickets", @"Map price", @"Favorites", nil];
    NSArray *contents = [NSArray arrayWithObjects:@"App for ticket search", @"Find the cheapest tickets", @"View the price map", @"Save your  tickets to favorites", nil];
    for (int i = 0; i < 4; ++i) {
        contentData[i].title = [titles objectAtIndex:i];
        contentData[i].contentText = [contents objectAtIndex:i];
        contentData[i].imageName = [NSString stringWithFormat:@"first-%d", i + 1];
    }
}

- (ContentViewController *)viewControllerAtIndex:(int)index {
    if (index < 0 || index >= CONTENT_COUNT) {
        return nil;
    }
    ContentViewController *contentVC = [ContentViewController new];
    contentVC.title = contentData[index].title;
    contentVC.contentText = contentData[index].contentText;
    contentVC.image = [UIImage imageNamed:contentData[index].imageName];
    contentVC.index = index;
    return contentVC;
}

- (void)updateButtonWithIndex:(int)index {
    switch (index) {
        case 0:
        case 1:
        case 2:
            [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
            self.nextButton.tag = 0;
            break;
        case 3:
            [self.nextButton setTitle:@"Ready" forState:UIControlStateNormal];
            self.nextButton.tag = 1;
            break;
        default:
            break;
    }
}

- (void)nextButtonDidTap:(UIButton *)sender {
    int index = ((ContentViewController *)[self.viewControllers firstObject]).index;
    if (sender.tag) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_start"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        [self setViewControllers:@[[self viewControllerAtIndex:index + 1]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
                      completion:^(BOOL finished) {
            weakSelf.pageControl.currentPage = index+1;
            [weakSelf updateButtonWithIndex:index+1];
        }];
    }
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        int index = ((ContentViewController *)[pageViewController.viewControllers firstObject]).index;
        self.pageControl.currentPage = index;
        [self updateButtonWithIndex:index];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = ((ContentViewController *)viewController).index;
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int index = ((ContentViewController *)viewController).index;
    index++;
    return [self viewControllerAtIndex:index];
}

@end
