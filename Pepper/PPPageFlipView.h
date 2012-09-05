//
//  PPPageFlipView.h
//
//  Created by Torin Nguyen on 20/8/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPageFlipView;

@protocol PPPageFlipControllerDelegate <NSObject>
@optional
- (void)ppPageFlipView:(PPPageFlipView*)theFlipView didFinishFlippingWithIndex:(float)index;
- (void)ppPageFlipView:(PPPageFlipView*)theFlipView didFlippedWithIndex:(float)index;
@end

@interface PPPageFlipView : UIView

@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, assign) BOOL zoomingOneSide;
@property (nonatomic, assign) float m34;
@property (nonatomic, assign) float currentPageIndex;
@property (nonatomic, assign) float numberOfPages;

@property (nonatomic, unsafe_unretained) UIView *theView0;
@property (nonatomic, unsafe_unretained) UIView *theView1;
@property (nonatomic, unsafe_unretained) UIView *theView2;
@property (nonatomic, unsafe_unretained) UIView *theView3;
@property (nonatomic, unsafe_unretained) UIView *theView4;
@property (nonatomic, unsafe_unretained) UIView *theView5;

- (BOOL)isBusy;

@end
