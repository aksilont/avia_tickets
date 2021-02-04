//
//  ContentViewController.m
//  Avia Tickets
//
//  Created by Aksilont on 03.02.2021.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation ContentViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, [UIScreen mainScreen].bounds.size.height / 2 - 100.0, 200.0, 200.0)];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.layer.cornerRadius = 8.0;
    image.clipsToBounds = YES;
    [self.view addSubview:image];
    self.imageView = image;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, CGRectGetMinY(image.frame) - 61.0, 200.0, 21.0)];
    title.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightHeavy];
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    self.titleLabel = title;
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, CGRectGetMaxY(image.frame) + 20.0, 200.0, 21.0)];
    content.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightHeavy];
    content.numberOfLines = 0;
    content.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:content];
    self.contentLabel = content;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    float height = heightForText(title, self.titleLabel.font, 200.0);
    self.titleLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, CGRectGetMinY(self.imageView.frame) - 40.0 - height, 200.0, height);
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    self.contentLabel.text = contentText;
    float height = heightForText(contentText, self.contentLabel.font, 200.0);
    self.contentLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, CGRectGetMaxY(self.imageView.frame) + 20.0, 200.0, height);
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    self.imageView.backgroundColor = UIColor.purpleColor;
}

float heightForText(NSString *text, UIFont *font, float width) {
    if (text && [text isKindOfClass:[NSString class]]) {
        CGSize size = CGSizeMake(width, FLT_MAX);
        CGRect needLabel = [text boundingRectWithSize:size
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
        return ceilf(needLabel.size.height);
    }
    return 0.0;
}

@end
