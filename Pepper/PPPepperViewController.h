//
//  PPScrollListViewControllerViewController.h
//  pepper
//
//  Created by Torin Nguyen on 25/4/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPageViewContentWrapper.h"
#import "PPPageViewDetailWrapper.h"

//For demo purpose
#define DEMO_NUM_BOOKS               64
#define DEMO_NUM_PAGES               100

@class PPPepperViewController;

@protocol PPScrollListViewControllerDataSource <NSObject>

/*
 * Delegate to return the number of books
 * Please ignore the dummy parameter, reserved for future use
 */
- (int)ppPepperViewController:(PPPepperViewController*)scrollList numberOfBooks:(int)dummy;

/*
 * Delegate to return the number of pages in the given book index
 */
- (int)ppPepperViewController:(PPPepperViewController*)scrollList numberOfPagesForBookIndex:(int)bookIndex;

/*
 * Delegate to return the book cover views
 */
- (UIView*)ppPepperViewController:(PPPepperViewController*)scrollList viewForBookIndex:(int)bookIndex withFrame:(CGRect)frame reusableView:(UIView*)contentView;

/*
 * Delegate to return the page views in 3D mode
 */
- (UIView*)ppPepperViewController:(PPPepperViewController*)scrollList thumbnailViewForPageIndex:(int)pageIndex inBookIndex:(int)bookIndex withFrame:(CGRect)frame reusableView:(UIView*)contentView;

/*
 * Delegate to return the page views in fullscreen/detailed mode
 */
- (UIView*)ppPepperViewController:(PPPepperViewController*)scrollList detailViewForPageIndex:(int)pageIndex inBookIndex:(int)bookIndex withFrame:(CGRect)frame reusableView:(UIView*)contentView;

@end

@protocol PPScrollListViewControllerDelegate <NSObject>
@optional

/*
 * This is called when the book list is being scrolled
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didScrollWithBookIndex:(float)bookIndex;

/*
 * This is called after the fullscreen list has finish snapping to a page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didSnapToBookIndex:(int)bookIndex;

/*
 * This is called when a book cover is tapped on
 * The book will open automatically if delegate does not implement this (default)
 * If implemented you need to call [pepperViewController openCurrentBookAtPageIndex:0]; yourself
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didTapOnBookIndex:(int)bookIndex;

/*
 * This is called just before & after the book opens & closes
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList willOpenBookIndex:(int)bookIndex andDuration:(float)duration;
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didOpenBookIndex:(int)bookIndex atPageIndex:(int)pageIndex;
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didCloseBookIndex:(int)bookIndex;

/*
 * When the book is being closed, the library will calculate the necessary alpha value to reveal the initial menu bar
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList closingBookWithAlpha:(float)alpha;

/*
 * This is called when a page is tapped on
 * The page will zoom to fullscreen mode automatically if delegate does not implement this (default)
 * If implemented, you need to call [pepperViewController openPageIndex:xxx]; yourself
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didTapOnPageIndex:(int)pageIndex;

/*
 * This is called when the 3D/Pepper page view is being flipped
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didFlippedWithIndex:(float)index;

/*
 * This is called after the flipping finish snapping to 3D/Pepper page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didFinishFlippingWithIndex:(float)index;

/*
 * This is called when the fullscreen/detail list is being scrolled
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didScrollWithPageIndex:(float)pageIndex;

/*
 * This is called after the fullscreen/detail list has finish snapping to a page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didSnapToPageIndex:(int)pageIndex;

/*
 * This is called during & after a fullscreen/detail page is zoom
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didZoomWithPageIndex:(int)pageIndex zoomScale:(float)zoomScale;
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didEndZoomingWithPageIndex:(int)pageIndex zoomScale:(float)zoomScale;

/*
 * This is called after a transition between Pepper mode & Fullscreen mode
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList willOpenPageIndex:(int)pageIndex;
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didOpenPageIndex:(int)pageIndex;
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didClosePageIndex:(int)pageIndex;

@end





@interface PPPepperViewController : UIViewController
<
 PPScrollListViewControllerDataSource,
 PPScrollListViewControllerDelegate
>

@property (nonatomic, unsafe_unretained) id <PPScrollListViewControllerDelegate> delegate;

// This cannot be changed in free-to-try version
@property (nonatomic, unsafe_unretained) id <PPScrollListViewControllerDataSource> dataSource;

// Configurable on-the-fly
@property (nonatomic, assign) BOOL hideFirstPage;
@property (nonatomic, assign) BOOL enableBorderlessGraphic;
@property (nonatomic, assign) BOOL enableBookScale;
@property (nonatomic, assign) BOOL enableBookRotate;
@property (nonatomic, assign) BOOL enableBookShadow;
@property (nonatomic, assign) BOOL enableOneSideZoom;
@property (nonatomic, assign) BOOL enableOneSideMiddleZoom;
@property (nonatomic, assign) BOOL enableHighSpeedScrolling;
@property (nonatomic, assign) BOOL scaleOnDeviceRotation;
@property (nonatomic, assign) float animationSlowmoFactor;

// Read-only properties
@property (nonatomic, assign) float controlIndex;
@property (nonatomic, readonly) float controlAngle;
@property (nonatomic, readonly) BOOL isBookView;
@property (nonatomic, readonly) BOOL isDetailView;

+ (NSString*)version;

- (void)reload;
- (BOOL)isPepperView;

// Book list
- (int)getCurrentBookIndex;
- (BOOL)hasBookInBookScrollView:(int)bookIndex;
- (void)openCurrentBookAtPageIndex:(int)pageIndex;
- (void)closeCurrentBook:(BOOL)animated;
- (PPPageViewContentWrapper*)getBookViewAtIndex:(int)bookIndex;

// Pepper list
- (void)openPageIndex:(int)pageIndex;
- (void)closeCurrentPage:(BOOL)animated;
- (BOOL)hasPageInPepperView:(int)index;
- (PPPageViewContentWrapper*)getPepperPageAtIndex:(int)pageIndex;
- (void)animateControlIndexTo:(float)index duration:(float)duration;

// Page list
- (int)getCurrentPageIndex;
- (BOOL)hasPageInPageScrollView:(int)pageIndex;
- (void)scrollToPage:(int)pageIndex duration:(float)duration;
- (PPPageViewDetailWrapper*)getDetailViewAtIndex:(int)pageIndex;

@end
