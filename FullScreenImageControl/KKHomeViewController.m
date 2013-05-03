//
//  KKHomeViewController.m
//  FullScreenImageControl
//
//  Created by clrvynt on 5/3/13.
//  Copyright (c) 2013 clrvynt. All rights reserved.
//

#import "KKHomeViewController.h"
#import "KKFullScreenViewer.h"

#define NUM_IMAGES 3
#define HEIGHT_OF_VIEW 200
#define GAP_BETWEEN_VIEWS 10

@interface KKHomeViewController ()

@end

@implementation KKHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view from its nib.
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapped:)];
    _tapRecognizer.numberOfTapsRequired = 1;
    _tapRecognizer.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:_tapRecognizer];
    _scrollView.clipsToBounds = NO;
    
    _scrollView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    // Create a scrollview with 3 images and some stuff under the image.
    for ( int i = 0 ; i < NUM_IMAGES ; i++ )
    {
        UIView *aView = [self getImageViewForY:( HEIGHT_OF_VIEW * i + GAP_BETWEEN_VIEWS * i  + GAP_BETWEEN_VIEWS) forTag:i];
        [_scrollView addSubview:aView];
        
    }
    
    _scrollView.bounces = NO;
    //_scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, ( HEIGHT_OF_VIEW * NUM_IMAGES + GAP_BETWEEN_VIEWS * NUM_IMAGES + GAP_BETWEEN_VIEWS));


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)getImageViewForY:(int)y forTag:(int)tag
{
    UIView *_view1 = [[UIView alloc] initWithFrame:CGRectMake(GAP_BETWEEN_VIEWS ,y, 300, HEIGHT_OF_VIEW)];
    _view1.backgroundColor = [UIColor whiteColor];
    _view1.clipsToBounds = NO;
    _view1.tag = tag;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", tag + 1]]];
    imgView.frame = CGRectMake(10, 10, 280, 160);
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_view1 addSubview:imgView];
    
    UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, 280, 20)];
    _label.text = @"A label here";
    
    [_view1 addSubview:_label];
    
    return _view1;
    
}

-(void)imgTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"Img tapped");
    CGPoint pt = [sender locationInView:self.view];
    
    UIView *v = [self.view hitTest:pt withEvent:nil];
    if ([v isKindOfClass:[UIImageView class]]) {
        [[KKFullScreenViewer sharedViewer] showImageViewInFullScreen:v];
    }
    
}


@end
