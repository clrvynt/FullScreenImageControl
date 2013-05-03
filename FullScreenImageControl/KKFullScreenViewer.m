//
//  KKFullScreenViewer.m
//  FullScreenImageControl
//
//  Created by clrvynt on 5/3/13.
//  Copyright (c) 2013 clrvynt. All rights reserved.
//

#import "KKFullScreenViewer.h"

// Button dimensions
#define BUTTON_HEIGHT 30
#define BUTTON_WIDTH 30
#define RIGHT_BUTTON_GAP 5
#define TOP_BUTTON_GAP 5

#define BACKGROUND_COLOR [UIColor blackColor]

@implementation KKFullScreenViewer

+(KKFullScreenViewer *)sharedViewer
{
    static KKFullScreenViewer *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[KKFullScreenViewer alloc] init];
        
        // Create closeButton here.
        [_sharedClient initVars];
        
    });
    return _sharedClient;
}

-(void)initVars
{

    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    keyWindow = [[UIApplication sharedApplication] keyWindow];
    baseEmptyView = [[UIView alloc] init];
    baseAlpha = 1.0;
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(appFrame.size.width - BUTTON_WIDTH - RIGHT_BUTTON_GAP, TOP_BUTTON_GAP, BUTTON_WIDTH , BUTTON_HEIGHT)];
    
    [closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"close-highlighted.png"] forState:UIControlStateHighlighted];
    
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)showImageViewInFullScreen:(UIView *)v withBackgroundColor:(UIColor *)bgColor andAlpha:(CGFloat)alpha
{
    fullScreenView = v;
    baseViewBackgroundColor = bgColor;
    baseAlpha = alpha;
    
    [self fullScreen];
}

-(void)showImageViewInFullScreen:(UIView *)v
{
    fullScreenView = v;
    [self fullScreen];
    
}

-(void)fullScreen
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    parentView = fullScreenView.superview;
    originalImageFrame = fullScreenView.frame;
    originalBackgroundColor = fullScreenView.backgroundColor;
    currentOrientation = [UIDevice currentDevice].orientation;
    
    isStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    [UIView animateWithDuration:0.5 animations:^{
        if ( !isStatusBarHidden )
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [fullScreenView removeFromSuperview];
        fullScreenView.backgroundColor = [UIColor clearColor];
        fullScreenView.frame = [[UIScreen mainScreen] applicationFrame];
        baseEmptyView.frame = [[UIScreen mainScreen] applicationFrame];
        
        if ( baseViewBackgroundColor )
            baseEmptyView.backgroundColor = baseViewBackgroundColor;
        else
            baseEmptyView.backgroundColor = BACKGROUND_COLOR;
        if ( baseAlpha < 1.0 )
            baseEmptyView.alpha = baseAlpha;
        else
            baseEmptyView.alpha = 1.0;
        
        [keyWindow addSubview:baseEmptyView];
        [keyWindow addSubview:fullScreenView];
        [fullScreenView addGestureRecognizer:tapRecognizer];
        [closeButton setHidden:YES];
        [keyWindow addSubview:closeButton];
        viewOpen = YES;
    }];
    
    [self fixOrientation:[[UIDevice currentDevice] orientation]];
    // Register for rotation notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)closeButtonClicked:(id)sender
{
    // Remove the close button from this view
    [UIView animateWithDuration:0.5 animations:^ {
        [baseEmptyView removeFromSuperview];
        [closeButton removeFromSuperview];
        [fullScreenView removeFromSuperview];
        if ( !isStatusBarHidden )
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        fullScreenView.transform = CGAffineTransformIdentity;
        
        fullScreenView.backgroundColor = originalBackgroundColor;
        baseViewBackgroundColor = nil;
        baseAlpha = 1.0;
        
        fullScreenView.frame = originalImageFrame;
        [parentView addSubview:fullScreenView];
        viewOpen = NO;
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


-(void)orientationDidChange
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation) {
        return;
    }
    
    currentOrientation = orientation;
    
    [self fixOrientation:orientation];
}

-(void)fixOrientation:(UIDeviceOrientation)orientation
{
    // Apply transforms based on device orientation but only if we are not recording
    
    switch (orientation ) {
            
        case UIDeviceOrientationUnknown:
            NULL;
        case UIDeviceOrientationFaceUp:
            NULL;
        case UIDeviceOrientationFaceDown:
            NULL;
            break;
        case UIDeviceOrientationPortrait:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
                
                fullScreenView.transform = CGAffineTransformIdentity;
                closeButton.transform = CGAffineTransformIdentity;
                fullScreenView.frame = appFrame;
            }];
            break;
        }
        case UIDeviceOrientationLandscapeLeft:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
                
                fullScreenView.transform = CGAffineTransformMakeRotation(M_PI_2);
                fullScreenView.frame = appFrame;
                
                // Translate the button.
                CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(M_PI_2);
                CGAffineTransform translateTransform = CGAffineTransformTranslate(rotateTransform, appFrame.size.height - (BUTTON_WIDTH/2) - TOP_BUTTON_GAP - RIGHT_BUTTON_GAP - (BUTTON_HEIGHT/2), -(BUTTON_WIDTH/2) + (BUTTON_HEIGHT/2));
                closeButton.transform  = translateTransform;
            }];
            break;
        }
        case UIDeviceOrientationLandscapeRight:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
                
                fullScreenView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                fullScreenView.frame = appFrame;
                
                // Translate the button.
                CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_2);
                CGAffineTransform translateTransform = CGAffineTransformTranslate(rotateTransform, -(BUTTON_WIDTH/2) + RIGHT_BUTTON_GAP + TOP_BUTTON_GAP , -appFrame.size.width + BUTTON_WIDTH/2 + BUTTON_HEIGHT/2 + TOP_BUTTON_GAP + RIGHT_BUTTON_GAP );
                closeButton.transform  = translateTransform;
            }];
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:
            break;
    }
    
}

-(void)imageTapped:(UITapGestureRecognizer *)sender
{
    // Close button does not show by default.
    if ( [closeButton isHidden]) {
        [closeButton setHidden:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if ( viewOpen && ![closeButton isHidden]) {
                [closeButton setHidden:YES];
            }
        });
    }
    else
        [closeButton setHidden:YES];
}


@end
