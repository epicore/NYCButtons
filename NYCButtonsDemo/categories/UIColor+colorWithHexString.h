//
//  UIColor+colorWithHexString.h
//  Citybike Finder
//
//  Created by Joshua Weinberg on 11/23/13.
//  Copyright (c) 2013 Joshua Weinberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorWithHexString)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
