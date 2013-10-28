//
//  Article.m
//  News
//
//  Created by Igal Kreichman on 10/22/13.
//  Copyright (c) 2013 Skycure. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(NSURL *)image content:(NSString *)content
{
    self = [super init];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
        self.content = content;
    }
    return self;
}

@end
