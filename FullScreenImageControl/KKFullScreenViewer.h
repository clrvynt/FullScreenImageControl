//
//  KKFullScreenViewer.h
//  FullScreenImageControl
//
//  Created by clrvynt on 5/3/13.
//  Copyright (c) 2013 clrvynt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKFullScreenViewer : NSObject
{
    UIButton *closeButton;
    UIWindow *keyWindow;
    UIView *baseEmptyView;
    UIColor *baseViewBackgroundColor;
    CGFloat baseAlpha;
    
    UIDeviceOrientation currentOrientation;
    
    CGRect originalImageFrame;
    UIView *fullScreenView;
    UIView *parentView;
    BOOL isStatusBarHidden;
    UIColor *originalBackgroundColor;
    
    UITapGestureRecognizer *tapRecognizer;
    BOOL viewOpen;
}

+(KKFullScreenViewer *)sharedViewer;

-(void)showImageViewInFullScreen:(UIView *)v;
-(void)showImageViewInFullScreen:(UIView *)v withBackgroundColor:(UIColor *)bgColor andAlpha:(CGFloat)alpha;

@end
