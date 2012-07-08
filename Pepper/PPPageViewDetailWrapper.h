//
//  PPPageViewDetail.h
//
//  Created by Torin Nguyen on 2/6/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPPageViewDetailDelegate
@optional
- (void)scrollViewDidZoom:(UIScrollView *)theScrollView;
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
@end

@interface PPPageViewDetailWrapper : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained) id customDelegate;
@property (nonatomic, strong) UIView *contentView;

- (void)setBackgroundImage:(UIImage*)image;
- (void)unloadContent;
- (void)reset;
- (void)layoutWithFrame:(CGRect)frame duration:(float)duration;

@end
