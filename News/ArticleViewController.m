//
//  ArticleViewController.m
//  News
//
//  Created by Igal Kreichman on 10/22/13.
//  Copyright (c) 2013 Skycure. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UITextView *content;

@end

@implementation ArticleViewController

- (void)viewDidLoad
{
    self.myTitle.text = self.article.title;
    self.subtitle.text = self.article.subtitle;
    self.content.text = self.article.content;
    
    if (self.article.image) {
        NSData *data = [NSData dataWithContentsOfURL:self.article.image];
        self.image.image = [UIImage imageWithData:data];
    }
}

@end
