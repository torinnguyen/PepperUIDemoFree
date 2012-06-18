//
//  PPScrollListViewControllerViewController.h
//  pepper
//
//  Created by Torin Nguyen on 25/4/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//For demo purpose
#define DEMO_NUM_BOOKS               16
#define DEMO_NUM_PAGES               64

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
 * The book will open automatically by the library if AUTO_OPEN_BOOK is enabled (default)
 * Otherwise you need to call [pepperViewController openCurrentBookAtPageIndex:0]; yourself
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
 * The book will open automatically by the library if AUTO_OPEN_PAGE is enabled (default)
 * Otherwise you need to call [pepperViewController openPageIndex:xxx]; yourself
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didTapOnPageIndex:(int)pageIndex;

/*
 * This is called when the 3D page view is being flipped
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didFlippedWithIndex:(float)index;

/*
 * This is called after the flipping finish snapping to a page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didFinishFlippingWithIndex:(float)index;

/*
 * This is called when the fullscreen list is being scrolled
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didScrollWithPageIndex:(float)pageIndex;

/*
 * This is called after the fullscreen list has finish snapping to a page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didSnapToPageIndex:(int)pageIndex;

/*
 * This is called during & after a fullscreen page is zoom
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didZoomWithPageIndex:(int)pageIndex zoomScale:(float)zoomScale;
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didEndZoomingWithPageIndex:(int)pageIndex zoomScale:(float)zoomScale;

@end





@interface PPPepperViewController : UIViewController
<
 PPScrollListViewControllerDataSource,
 PPScrollListViewControllerDelegate
>

// Delegate & datasource protocol
@property (nonatomic, unsafe_unretained) id <PPScrollListViewControllerDelegate> delegate;

// Not available in free-to-try static library
//@property (nonatomic, unsafe_unretained) id <PPScrollListViewControllerDataSource> dataSource;

@property (nonatomic, assign) BOOL hideFirstPage;
@property (nonatomic, assign) BOOL enableBookScale;
@property (nonatomic, assign) BOOL enableBookRotate;
@property (nonatomic, assign) BOOL oneSideZoom;             //experimental, don't touch this
@property (nonatomic, assign) BOOL scaleOnDeviceRotation;
@property (nonatomic, assign) float animationSlowmoFactor;
@property (nonatomic, assign) float pepperPageSpacing;

// Read-only properties
@property (nonatomic, readonly) float controlIndex;
@property (nonatomic, readonly) float controlAngle;
@property (nonatomic, readonly) BOOL isBookView;
@property (nonatomic, readonly) BOOL isDetailView;

+ (NSString*)version;

- (void)reload;

// Book list
- (void)openCurrentBookAtPageIndex:(int)pageIndex;

// Pepper list
- (void)openPageIndex:(int)pageIndex;

// Page list
- (void)scrollToPage:(int)pageIndex duration:(float)duration;
  
@end
