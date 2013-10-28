//
//  ArticleView.h
//  News
//
//  Created by Igal Kreichman on 10/22/13.
//  Copyright (c) 2013 Skycure. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Article.h"

@interface ArticleView : UITableViewCell

- (id)initWithArticle:(Article *)article;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;

@end
