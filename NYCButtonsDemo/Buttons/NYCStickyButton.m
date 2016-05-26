//
//  NYCStickyButton.m
//  Citybike Finder
//
//  Created by Joshua Weinberg on 2/29/16.
//  Copyright © 2016 Joshua Weinberg. All rights reserved.
//

#import "NYCStickyButton.h"
// categories
#import "UIView+CenterView.h"

@interface NYCStickyButton()
@property (strong, nonatomic) IBOutlet UIImageView *surrogateImgView;
@property (strong, nonatomic) UIImage *surrogateImg;
@end

@implementation NYCStickyButton
@synthesize isSelected = _isSelected;
@synthesize defaultColor = _defaultColor;
@synthesize isAnimating = _isAnimating;
@synthesize animSpeed = _animSpeed;
@synthesize surrogateImg = _surrogateImg;

#pragma mark -
#pragma mark Getters and Setters

- (UIImage*) surrogateImg{
    return _surrogateImg;
}

- (void) setSurrogateImg:(UIImage *)img{
    _surrogateImg = img;
    self.surrogateImgView.image = img;
}

- (BOOL) isAnimating{
    return _isAnimating;
}

- (UIColor*) defaultColor{
    return _defaultColor;
}

- (void) setDefaultColor:(UIColor*)color{
    self.backgroundColor = color;
    _defaultColor = color;
}

- (BOOL) isSelected{
    return _isSelected;
}

-(void) setIsSelected:(BOOL)selectMe{
    if(self.isSticky){
        // if it's sticky we do background color change and save the value
        self.selected = selectMe;
        self.backgroundColor = selectMe? self.stickyColor : self.defaultColor;
        _isSelected = selectMe;
    }
}

#pragma mark -
#pragma mark Lifecycle methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self initializeStickyBtn];
    }
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    [self initializeStickyBtn];
    [self centerSurrogateImageView];
}

// init helper method

- (void) initializeStickyBtn{
    _animSpeed = 0.2f;
    self.isSticky = NO;
    self.isSpinAnimationEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    [self copyButtonImageToViewAsSurrogate];
    [self clearButtonImage];
    [self.imageView removeFromSuperview];
    
    [self addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(endAnimation) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark overrides

- (void) setImage:(UIImage *)image forState:(UIControlState)controlState{
    self.surrogateImg = image;
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    // if its sticky or the highlightColor is set
    // we can do background color changes
    if(self.isSticky || self.highlightColor){
        if(highlighted){
            self.backgroundColor = self.highlightColor? self.highlightColor : self.stickyColor;
        }
    }
}

- (void) centerSurrogateImageView{
    [self centerSubView:self.surrogateImgView];
}

#pragma mark -
#pragma mark Animation methods

- (void) startAnimation{
    
    _isAnimating = YES;
    
    // create the compund transform
    CGAffineTransform entireTransform = CGAffineTransformMakeScale(1.25, 1.25);
    if(self.isSpinAnimationEnabled){
        CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI*9/10);
        entireTransform = CGAffineTransformConcat(entireTransform, rotate);
    }
    
    [UIView animateWithDuration:self.animSpeed
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:(void (^)(void)) ^{
                         
                         self.surrogateImgView.transform = entireTransform;
                     } completion:^(BOOL completed){
                         [self turnOffIsAnimating];
                     }];
}

- (void) endAnimation{
    
    _isAnimating = YES;

    [UIView animateWithDuration:self.animSpeed
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:(void (^)(void)) ^{
                         self.surrogateImgView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:self.animSpeed
                                               delay:0
                                             options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                          animations:(void (^)(void)) ^{
                                              self.surrogateImgView.transform = CGAffineTransformIdentity;
                                          } completion:^(BOOL completed){
                                              [self turnOffIsAnimating];
                                          }];
                     }];
}

// helper method
- (void) turnOffIsAnimating{
    _isAnimating = NO;
    if (self.surrogateImg){
        self.surrogateImgView.image = self.surrogateImg;
    }
}

#pragma mark -
#pragma mark Animation Helper methods

- (void) copyButtonImageToViewAsSurrogate{
    // copy button imageView over to our surrogate
    self.surrogateImgView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    [self.surrogateImgView addConstraints:self.imageView.constraints];
    self.surrogateImg = self.imageView.image;
    [self addSubview:self.surrogateImgView];
}

- (void) clearButtonImage{
    // clear the actual button image and animate our surrrogate
    [super setImage:nil forState:UIControlStateNormal];
    [super setImage:nil forState:UIControlStateDisabled];
    [super setImage:nil forState:UIControlStateSelected];
    [super setImage:nil forState:UIControlStateHighlighted];
}

@end
