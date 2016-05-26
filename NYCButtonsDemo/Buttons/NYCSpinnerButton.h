//
//  NYCSpinnerButton.h
//  Citybike Finder
//
//  Created by Joshua Weinberg on 3/9/16.
//  Copyright © 2016 Joshua Weinberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYCSpinnerButton : UIButton
@property BOOL isSpinning;
@property (strong, nonatomic) IBOutlet UIImage *surrogateImg;
@property (strong, nonatomic) UIColor *defaultColor;
@property (strong, nonatomic) UIColor *spinningColor;
@end
