//
//  MainArticleView.m
//  News
//
//  Created by Igal Kreichman on 10/22/13.
//  Copyright (c) 2013 Skycure. All rights reserved.
//

#import "MainArticleView.h"

#import "Article.h"

@implementation MainArticleView

- (id)initWithArticle:(Article *)article
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.title.text = article.title;
        
        if (article.image) {
            NSData *data = [NSData dataWithContentsOfURL:article.image];
            self.image.image = [[UIImage alloc] initWithData:data];
        }
    }
    return self;
}

@end
