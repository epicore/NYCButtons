//
//  NYCStickyButton.h
//  Citybike Finder
//
//  Created by Joshua Weinberg on 2/29/16.
//  Copyright © 2016 Joshua Weinberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYCStickyButton : UIButton
@property (strong, nonatomic) UIColor *defaultColor;
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) UIColor *stickyColor;
@property BOOL isSpinAnimationEnabled;
@property BOOL isAnimationEnabled;
@property BOOL isSticky;
@property BOOL isSelected;
@property (readonly) BOOL isAnimating;
@property (readonly) CGFloat animSpeed;
@end
