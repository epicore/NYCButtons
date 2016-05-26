//
//  NYCSpinnerButton.m
//  Citybike Finder
//
//  Created by Joshua Weinberg on 3/9/16.
//  Copyright © 2016 Joshua Weinberg. All rights reserved.
//

#import "NYCSpinnerButton.h"
// categories
#import "UIView+CenterView.h"

@interface NYCSpinnerButton()
@property (strong, nonatomic) IBOutlet UIImageView *surrogateImgView;
@property CGFloat animSpeed;
@end

@implementation NYCSpinnerButton
@synthesize isSpinning = _isSpinning,
            defaultColor = _defaultColor,
            spinningColor = _spinningColor,
            surrogateImg = _surrogateImg;

- (UIImage*) surrogateImg{
    return _surrogateImg;
}

- (void) setSurrogateImg:(UIImage *)img{
    _surrogateImg = img;
    self.surrogateImgView.image = img;
}

- (BOOL) isSpinning{
    return _isSpinning;
}

- (void) setIsSpinning:(BOOL)isSpinning{
    if(_isSpinning != isSpinning){
        if(isSpinning){
            [self spinAnimation];
            self.backgroundColor = self.spinningColor;
        } else {
            self.backgroundColor = self.defaultColor;
        }
        self.enabled = !isSpinning; // prevent animations from stacking
        _isSpinning = isSpinning;
    }
}

- (UIColor*) defaultColor{
    return _defaultColor;
}

- (void) setDefaultColor:(UIColor*)color{
    self.backgroundColor = color;
    _defaultColor = color;
}

#pragma mark -
#pragma mark Lifecycle methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self initializeSpinnerBtn];
    }
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    [self initializeSpinnerBtn];
    [self centerSurrogateImageView];
}

// init helper methods

- (void) initializeSpinnerBtn{
    _isSpinning = NO;
    self.animSpeed = 0.5;
    self.backgroundColor = [UIColor clearColor];
    [self copyButtonImageToViewAsSurrogate];
    self.surrogateImgView.layer.anchorPoint = CGPointMake(0.45,0.5); // the icon is a little lopsided.
    [self clearButtonImage];
    [self.imageView removeFromSuperview];
}

- (void) centerSurrogateImageView{
    [self centerSubView:self.surrogateImgView];
}

#pragma mark -
#pragma mark overrides

- (void) setImage:(UIImage *)image forState:(UIControlState)controlState{
    self.surrogateImg = image;
}

#pragma mark -
#pragma mark Spin Animation methods

- (void)spinAnimation {
    
    [UIView animateWithDuration:self.animSpeed/2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
                         self.surrogateImgView.transform = transform;
                     } completion:^(BOOL completed){
                         [UIView animateWithDuration:self.animSpeed/2
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                             self.surrogateImgView.transform = CGAffineTransformIdentity;
                                          } completion:^(BOOL completed){
                                              if(self.isSpinning){
                                                  [self spinAnimation];
                                              }
                                          }];
                     }];
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
