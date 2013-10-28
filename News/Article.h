//
//  Article.h
//  News
//
//  Created by Igal Kreichman on 10/22/13.
//  Copyright (c) 2013 Skycure. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(NSURL *)image content:(NSString *)content;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSURL *image;
@property (strong, nonatomic) NSString *content;

@end
