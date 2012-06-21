//
//  MyPageBaseView.m
//
//  Created by Torin Nguyen on 26/4/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PPPepperContants.h"
#import "MyPageBaseView.h"
#import "MyImageCache.h"

@interface MyPageBaseView()
@end

@implementation MyPageBaseView

@synthesize imageView;
@synthesize loadingIndicator;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.backgroundColor = [UIColor clearColor];
    
    int margin = 10;
    CGRect imageFrame = CGRectMake(margin, margin+EDGE_PADDING, frame.size.width-2*margin, frame.size.height-2*EDGE_PADDING-2*margin);
    self.imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = margin;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.shouldRasterize = YES;
    self.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:self.imageView];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingIndicator.center = CGPointMake(CGRectGetMidX(self.imageView.bounds), CGRectGetMidY(self.imageView.bounds));
    self.loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.loadingIndicator.contentMode = UIViewContentModeCenter;
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.color = [UIColor orangeColor];
    [self.loadingIndicator stopAnimating];
    [self.imageView addSubview:self.loadingIndicator];
  }
  return self;
}

//
// Get image asynchronously from somewhere
//

- (void)fetchImageWithUrl:(NSString *)stringUrl
{
  if (stringUrl == nil)
    return;

  //Local image
  if (![stringUrl hasPrefix:@"http"]) {
    self.imageView.image = [UIImage imageNamed:stringUrl];
    [self.loadingIndicator stopAnimating];
    return;
  }
  
  //Has cache
  UIImage *image = [[MyImageCache sharedCached] imageForKey:stringUrl];
  if (image != nil) {
    self.imageView.image = image;
    self.imageView.backgroundColor = [UIColor greenColor];
    [self.loadingIndicator stopAnimating];
    [self.imageView setNeedsDisplay];
    return;
  }
  
  [self.loadingIndicator startAnimating];
  
  //Asynchronous loading using GCD
  __block MyPageBaseView* _self = self;
  dispatch_queue_t backgroundQueue = dispatch_queue_create("com.companyname.downloadqueue", NULL);
  dispatch_async(backgroundQueue, ^(void) {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:stringUrl]]];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      _self.imageView.image = image;
      [_self.loadingIndicator stopAnimating];
      [[MyImageCache sharedCached] addImage:image ForKey:stringUrl];
    });
  });
}

@end
