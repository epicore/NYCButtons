//
//  UIView+CenterView.m
//  Citybike Finder
//
//  Created by Joshua Weinberg on 3/31/16.
//  Copyright © 2016 Joshua Weinberg. All rights reserved.
//

#import "UIView+CenterView.h"

@implementation UIView (CenterView)

- (void) centerSubView:(UIView*)subView{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
}

@end
