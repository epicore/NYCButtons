//
//  ViewController.m
//  NYCButtonsDemo
//
//  Created by Joshua Weinberg on 5/26/16.
//  Copyright © 2016 Joshua Weinberg. All rights reserved.
//

#import "ViewController.h"
#import "NYCStickyButton.h"
#import "NYCSpinnerButton.h"
// catogories
#import "UIColor+colorWithHexString.h"

typedef NS_ENUM(NSInteger, BikeMapModeType){
    BIKE_MODE = 0,
    DOCK_MODE,
    BIKE_COMPASS_MODE,
    DOCK_COMPASS_MODE,
    MODES_TOTAL
};

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NYCStickyButton *bikeModeBtn;
@property (weak, nonatomic) IBOutlet NYCStickyButton *dockModeBtn;
@property (weak, nonatomic) IBOutlet NYCStickyButton *compassModeBtn;
@property (weak, nonatomic) IBOutlet NYCSpinnerButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIView *navHolder;

@property (strong, nonatomic) UIColor *defautColor;
@property (strong, nonatomic) UIColor *accentColor;
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) UIColor *bgColor;

@property BikeMapModeType mapModeType;
@property BOOL compassModeOn;
@end

@implementation ViewController
@synthesize mapModeType = _mapModeType;

- (BikeMapModeType) mapModeType{
    return _mapModeType;
}

- (void) setMapModeType:(BikeMapModeType)mapModeType{
    BOOL turnCompassOnOrOff = mapModeType == BIKE_COMPASS_MODE || mapModeType == DOCK_COMPASS_MODE;
    self.compassModeOn = turnCompassOnOrOff;
    _mapModeType = mapModeType;
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)handleMapRefresh:(id)sender {
    self.refreshBtn.isSpinning = YES;
    // set a timer to shut if off in 1 second.
    [self performSelector:@selector(resetRefreshButton)
               withObject:nil
               afterDelay:1.0];
}

- (IBAction)chooseBikeMode:(id)sender{
    if(self.compassModeOn){
        self.mapModeType = BIKE_COMPASS_MODE;
    } else {
        self.mapModeType = BIKE_MODE;
    }
    [self resetNavButtons];
}

- (IBAction)chooseDockMode:(id)sender{
    if(self.compassModeOn){
        self.mapModeType = DOCK_COMPASS_MODE;
    } else {
        self.mapModeType = DOCK_MODE;
    }
    
    [self resetNavButtons];
}

// toggle compass mode
- (IBAction)toggleCompassMode:(id)sender{
    switch (self.mapModeType) {
        case DOCK_MODE:
            self.mapModeType = DOCK_COMPASS_MODE;
            break;
        case DOCK_COMPASS_MODE:
            self.mapModeType = DOCK_MODE;
            break;
        case BIKE_MODE:
            self.mapModeType = BIKE_COMPASS_MODE;
            break;
        case BIKE_COMPASS_MODE:
            self.mapModeType = BIKE_MODE;
            break;
        default:
            break;
    }
    
    [self resetNavButtons];
}

#pragma mark -
#pragma mark View Controller Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavButtons];
    self.bgColor = [UIColor colorWithHexString:@"dddddd"];
    self.defautColor = [UIColor whiteColor];
    self.accentColor = [UIColor colorWithHexString:@"eeeeee"];
    self.highlightColor = [UIColor colorWithHexString:@"efefef"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self applyColors];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self chooseBikeMode:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Misc Helper methods

- (void) resetRefreshButton{
    self.refreshBtn.isSpinning = NO;
}

- (void) shutDownCompassMode{
    if(self.mapModeType == BIKE_COMPASS_MODE){
        self.mapModeType = BIKE_MODE;
    } else if(self.mapModeType == DOCK_COMPASS_MODE){
        self.mapModeType = DOCK_MODE;
    }
    [self resetNavButtons];
}

- (void) applyColors{
    // colors 
    self.navHolder.backgroundColor = self.bgColor;
    
    self.bikeModeBtn.defaultColor = self.defautColor;
    self.dockModeBtn.defaultColor = self.defautColor;
    self.compassModeBtn.defaultColor = self.defautColor;
    self.refreshBtn.defaultColor = self.defautColor;
    
    self.bikeModeBtn.stickyColor = self.accentColor;
    self.dockModeBtn.stickyColor = self.accentColor;
    self.compassModeBtn.stickyColor = self.accentColor;
    self.refreshBtn.spinningColor = self.accentColor;
    
    self.bikeModeBtn.highlightColor = self.highlightColor;
    self.dockModeBtn.highlightColor = self.highlightColor;
    self.compassModeBtn.highlightColor = self.highlightColor;
}


- (void) initNavButtons{
    self.bikeModeBtn.isSticky = YES;
    self.dockModeBtn.isSticky = YES;
    self.compassModeBtn.isSticky = YES;
    
    self.dockModeBtn.isAnimationEnabled = YES;
    self.bikeModeBtn.isAnimationEnabled = YES;
    self.compassModeBtn.isAnimationEnabled = YES;
    self.compassModeBtn.isSpinAnimationEnabled = YES;
}

- (void) flushNavButtons{
    // set the image first because isSelected will do an animation on it.
    [self.bikeModeBtn setImage:[UIImage imageNamed:@"bikeIconGreen"] forState:UIControlStateNormal];
    [self.dockModeBtn setImage:[UIImage imageNamed:@"dockIconGreen"] forState:UIControlStateNormal];
    [self.compassModeBtn setImage:[UIImage imageNamed:@"compassIconGreen"] forState:UIControlStateNormal];
    
    self.dockModeBtn.enabled = YES;
    self.bikeModeBtn.enabled = YES;
    self.dockModeBtn.isSelected = NO;
    self.bikeModeBtn.isSelected = NO;
    self.compassModeBtn.isSelected = NO;
    
    [self clearRefreshBtn];
}

- (void) resetNavButtons{
    
    [self flushNavButtons];
    
    switch (self.mapModeType) {
        case BIKE_COMPASS_MODE:
            self.bikeModeBtn.enabled = NO;
            [self.bikeModeBtn setImage:[UIImage imageNamed:@"bikeIconGrey"] forState:UIControlStateNormal];
            break;
        case DOCK_MODE:
            self.dockModeBtn.enabled = NO;
            [self.dockModeBtn setImage:[UIImage imageNamed:@"dockIconRed"] forState:UIControlStateNormal];
            self.dockModeBtn.isSelected = YES;
            break;
        case DOCK_COMPASS_MODE:
            self.dockModeBtn.enabled = NO;
            [self.dockModeBtn setImage:[UIImage imageNamed:@"dockIconGrey"] forState:UIControlStateNormal];
            break;
        default:
        case BIKE_MODE:
            self.bikeModeBtn.enabled = NO;
            [self.bikeModeBtn setImage:[UIImage imageNamed:@"bikeIconRed"] forState:UIControlStateNormal];
            self.bikeModeBtn.isSelected = YES;
            break;
    }
    
    if (self.compassModeOn){
        self.compassModeBtn.isSelected = YES;
        [self.compassModeBtn setImage:[UIImage imageNamed:@"compassIconRed"] forState:UIControlStateNormal];
    }
}

- (void) clearRefreshBtn{
    // clear the refreshBtn state and any forcerefresh that's running.
    if(self.refreshBtn.isSpinning){
        self.refreshBtn.isSpinning = NO;
    }
}

@end
