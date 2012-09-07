//
//  PPViewController.m
//
//  Created by Torin Nguyen on 2/6/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#include <stdlib.h>   //simply for random number function

#import "PPViewController.h"
#import "PPPepperViewController.h"
#import "MyBookOrPageView.h"
#import "MyPageViewDetail.h"
#import "MyImageCache.h"

@interface PPViewController () <PPScrollListViewControllerDataSource, PPScrollListViewControllerDelegate>
@property (nonatomic, strong) IBOutlet UIView * menuView;
@property (nonatomic, strong) IBOutlet UIView * speedView;
@property (nonatomic, strong) IBOutlet UISegmentedControl * speedSegmented;
@property (nonatomic, strong) IBOutlet UISegmentedControl * contentSegmented;
@property (nonatomic, strong) IBOutlet UISegmentedControl * fullscreenEffectSegmented;
@property (nonatomic, strong) IBOutlet UISwitch * switchRandomPage;
@property (nonatomic, strong) IBOutlet UISwitch * switchScaleOnDeviceRotation;
@property (nonatomic, strong) IBOutlet UISwitch * switchBorderlessGraphic;
@property (nonatomic, strong) IBOutlet UISwitch * switchOneSideZoom;
@property (nonatomic, strong) IBOutlet UILabel * lblSpeed;
@property (nonatomic, strong) IBOutlet UILabel * lblVersion;
@property (nonatomic, strong) IBOutlet UIButton * btnClose;

@property (nonatomic, strong) PPPepperViewController * pepperViewController;
@property (nonatomic, strong) NSMutableArray *bookDataArray;
@property (nonatomic, assign) BOOL iOS5AndAbove;
@end

@implementation PPViewController
@synthesize menuView;
@synthesize speedView;
@synthesize speedSegmented;
@synthesize contentSegmented;
@synthesize fullscreenEffectSegmented;
@synthesize switchRandomPage;
@synthesize switchScaleOnDeviceRotation;
@synthesize switchBorderlessGraphic;
@synthesize switchOneSideZoom;
@synthesize lblSpeed;
@synthesize lblVersion;
@synthesize btnClose;

@synthesize pepperViewController;
@synthesize bookDataArray;
@synthesize iOS5AndAbove;

- (void)viewDidLoad
{
  [super viewDidLoad];

  //Basic setup
  self.pepperViewController = [[PPPepperViewController alloc] init];  
  self.pepperViewController.view.frame = self.view.bounds;
  [self.view addSubview:self.pepperViewController.view];

  //iOS5
  self.iOS5AndAbove = ([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending);
  if (self.iOS5AndAbove) {
    [self addChildViewController:self.pepperViewController];
    [self.pepperViewController didMoveToParentViewController:self];   
  }
  
  //Supply it with your own data/model
  self.pepperViewController.delegate = self;        //we are simply printing out all delegate events in this demo
  //self.pepperViewController.dataSource = self;    //not available in free-to-try version
  
  //Optional customization
  /*
   self.pepperViewController.enableBookShadow = YES;
   self.pepperViewController.enableBorderlessGraphic = YES;
   self.pepperViewController.enableOneSideZoom = YES;
   self.pepperViewController.enableOneSideMiddleZoom = YES;
   self.pepperViewController.enablePageCurlEffect = YES;   //iOS5 and above only, will fallback to enablePageFlipEffect or scrollview
   self.pepperViewController.enablePageFlipEffect = YES;
   self.pepperViewController.hideFirstPage = YES;
   */
  
  //Default customization options
  [self onSpeedChange:self.speedSegmented];
  [self onFullscreenEffectChange:self.fullscreenEffectSegmented];
  [self onSwitchRandomPage:self.switchRandomPage];
  [self onSwitchScaleOnDeviceRotation:self.switchScaleOnDeviceRotation];
  [self onSwitchBorderlessGraphic:self.switchBorderlessGraphic];
  [self onSwitchOneSideZoom:self.switchOneSideZoom];
  
  //Version number
  self.lblVersion.text = [NSString stringWithFormat:@"Free-to-try demo\nVersion %@", [PPPepperViewController version]];
  
  //Bring our top level menu to highest z-index
  [self.view bringSubviewToFront:self.menuView];
  [self.view bringSubviewToFront:self.speedView];
  
  //Hide close button initially
  [self showHideCloseButton:NO];
  
  //Initialize data
  [self initializeBookData];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  //iOS4
  if (!self.iOS5AndAbove)
    [self.pepperViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

  //iOS4
  if (!self.iOS5AndAbove)
    [self.pepperViewController viewDidAppear:animated];
  
  [self.pepperViewController reload];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
  [self.pepperViewController didReceiveMemoryWarning];
  [super didReceiveMemoryWarning];
}


#pragma mark - View rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration {  
  //iOS4
  if (!self.iOS5AndAbove)
    [self.pepperViewController willRotateToInterfaceOrientation:toInterfaceOrientation
                                                       duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                         duration:(NSTimeInterval)duration {
  //iOS4
  if (!self.iOS5AndAbove)
    [self.pepperViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                                                duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  //iOS4
  if (!self.iOS5AndAbove)
    [self.pepperViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}



#pragma mark - Actions

- (IBAction)onSpeedChange:(id)sender
{
  int idx = self.speedSegmented.selectedSegmentIndex;
  float factor = 1.0;
  switch (idx) {
    case 2:      factor = 12.0f;      break;
    case 1:      factor = 2.0f;       break;
    default:     break;
  }
  self.pepperViewController.animationSlowmoFactor = factor;
}

/*
 * This is non-functional in free-to-try version
 * Switch between text demo & image demo
 */
- (IBAction)onContentChange:(id)sender
{
  int idx = self.contentSegmented.selectedSegmentIndex;
  int bookIndex = [self.pepperViewController getCurrentBookIndex];
  if (idx == 0) {
    self.pepperViewController.enableBorderlessGraphic = NO;
    self.pepperViewController.dataSource = self.pepperViewController;
  }
  else {
    self.pepperViewController.enableBorderlessGraphic = YES;
    self.pepperViewController.dataSource = self;
  }
  [[MyImageCache sharedCached] removeAll];
  [self.pepperViewController reload];
  [self.pepperViewController scrollToBook:bookIndex animated:NO];
}

- (IBAction)onFullscreenEffectChange:(id)sender
{
  int idx = self.fullscreenEffectSegmented.selectedSegmentIndex;
  switch (idx) {
    case 0:
      self.pepperViewController.enablePageCurlEffect = NO;
      self.pepperViewController.enablePageFlipEffect = NO;
      break;
    case 1:
      self.pepperViewController.enablePageCurlEffect = YES;
      self.pepperViewController.enablePageFlipEffect = YES;   //set to YES to allow fallback on iOS4.3
      break;
    case 2:
      self.pepperViewController.enablePageCurlEffect = NO;
      self.pepperViewController.enablePageFlipEffect = YES;
      break;
    default:
      break;
  }
}

- (IBAction)onSwitchRandomPage:(id)sender
{
  if ([self.pepperViewController.delegate isEqual:self])
    return;
  [[[UIAlertView alloc] initWithTitle:@"Warning"
                              message:@"You must set self.pepperViewController.delegate = self; to use this feature"
                             delegate:nil
                    cancelButtonTitle:@"Dismiss"
                    otherButtonTitles:nil] show];
}

- (IBAction)onSwitchScaleOnDeviceRotation:(id)sender
{
  self.pepperViewController.scaleOnDeviceRotation = self.switchScaleOnDeviceRotation.on;
}

- (IBAction)onSwitchBorderlessGraphic:(id)sender
{
  int bookIndex = [self.pepperViewController getCurrentBookIndex];
  self.pepperViewController.enableBorderlessGraphic = self.switchBorderlessGraphic.on;
  [self.pepperViewController reload];
  [self.pepperViewController scrollToBook:bookIndex animated:NO];
}

- (IBAction)onSwitchOneSideZoom:(id)sender
{
  self.pepperViewController.enableOneSideZoom = self.switchOneSideZoom.on;
}

- (IBAction)onBtnClose:(id)sender
{
  if ([self.pepperViewController isBusy])
    return;
  
  if (self.pepperViewController.isBookView)
    return;
  
  if ([self.pepperViewController isPepperView]) {
    [self.pepperViewController closeCurrentBook:YES];
    return;
  }
  
  if (self.pepperViewController.isDetailView) {
    [self.pepperViewController closeCurrentPage:YES];
    return;
  }
}

#pragma mark - Helpers

- (void)showHideMenuBarWithAlpha:(float)alpha
{
  //Show our menu together with the books
  self.menuView.alpha = alpha;
  self.speedView.alpha = 1.0 - alpha;
  self.lblSpeed.text = [NSString stringWithFormat:@"%.1fx", self.pepperViewController.animationSlowmoFactor];
  self.menuView.userInteractionEnabled = (alpha != 0);
}

- (void)showHideMenuBar:(BOOL)isShow
{
  [UIView animateWithDuration:0.3 animations:^{
    [self showHideMenuBarWithAlpha:isShow ? 1.0 : 0];
  }];
}

- (void)showHideCloseButton:(BOOL)isShow
{
  [UIView animateWithDuration:0.3 animations:^{
    self.btnClose.alpha = isShow ? 1 : 0;
  }];
  
  self.btnClose.userInteractionEnabled = isShow;
  [self.view bringSubviewToFront:self.btnClose];
}


#pragma mark - Data model
#pragma mark Non-functional in free-to-try version

- (void)initializeBookData
{
  //You can supply your own data model
  //For demo purpose, a very basic Book & Page model is supplied
  //and they are being initialized with random data here
  
  //Dummy image list. Use with permission from Flickr user
  NSArray *imageArray = [NSArray arrayWithObjects:
                         @"http://farm5.staticflickr.com/4013/4403864606_1ef5903b40_b.jpg",
                         @"http://farm3.staticflickr.com/2772/4409418974_df2bc0e6a8_b.jpg",
                         @"http://farm5.staticflickr.com/4043/4411334362_652660cd36_b.jpg",
                         @"http://farm3.staticflickr.com/2787/4410850119_0088b812b6_b.jpg",
                         @"http://farm5.staticflickr.com/4013/4413884482_cd8b7f29fb_b.jpg",
                         @"http://farm8.staticflickr.com/7217/7188226254_809e5b218b_b.jpg",
                         @"http://farm5.staticflickr.com/4030/4411581280_8ef29563d8_z.jpg?zz=1",
                         @"http://farm8.staticflickr.com/7223/7188230154_13db066420_b.jpg",
                         nil];
  int imageCount = imageArray.count;
  
  int randomBookID = arc4random() % 123456;
  int randomPageID = arc4random() % 123456;
  
  self.bookDataArray = [[NSMutableArray alloc] init];
  for (int i=0; i<DEMO_NUM_BOOKS; i++) {
    Book *myBook = [[Book alloc] init];
    myBook.bookID = randomBookID;
    myBook.pages = [[NSMutableArray alloc] init];
    randomBookID += arc4random() % 123456;
    
    int randomNumPages = DEMO_NUM_PAGES;
    for (int j=0; j<randomNumPages; j++) {
      Page *myPage = [[Page alloc] init];
      myPage.pageID = randomPageID;
      myPage.halfsizeURL = [imageArray objectAtIndex:(i+j) % imageCount];
      myPage.fullsizeURL = myPage.halfsizeURL;
      randomPageID += arc4random() % 123456;
      
      [myBook.pages addObject:myPage];
    }
    
    [self.bookDataArray addObject:myBook];
  }
}

- (void)addPageToBookIndex:(int)bookIndex
{
  //Dummy image list. Use with permission from Flickr user
  NSArray *imageArray = [NSArray arrayWithObjects:
                         @"http://farm5.staticflickr.com/4013/4403864606_1ef5903b40_b.jpg",
                         @"http://farm3.staticflickr.com/2772/4409418974_df2bc0e6a8_b.jpg",
                         @"http://farm5.staticflickr.com/4043/4411334362_652660cd36_b.jpg",
                         @"http://farm3.staticflickr.com/2787/4410850119_0088b812b6_b.jpg",
                         @"http://farm5.staticflickr.com/4013/4413884482_cd8b7f29fb_b.jpg",
                         @"http://farm8.staticflickr.com/7217/7188226254_809e5b218b_b.jpg",
                         @"http://farm5.staticflickr.com/4030/4411581280_8ef29563d8_z.jpg?zz=1",
                         @"http://farm8.staticflickr.com/7223/7188230154_13db066420_b.jpg",
                         nil];
  int imageCount = imageArray.count;
  
  Page *newPage = [[Page alloc] init];
  newPage.pageID = arc4random() % 123456;
  newPage.halfsizeURL = [imageArray objectAtIndex:(arc4random() % imageCount)];
  newPage.fullsizeURL = newPage.halfsizeURL;
  
  Book *theBook = [self.bookDataArray objectAtIndex:bookIndex];
  [theBook.pages addObject:newPage];
  
  NSLog(@"Add page to bookIndex: %d - total: %d", bookIndex, theBook.pages.count);
}

/*
 * This is used to load more dummy pages as user is flipping through the book
 * For implementing infinite pages
 */
- (void)loadMorePageForBookIndex:(int)bookIndex currentPageIndex:(int)pageIndex
{
  int numBufferPages = 12;      //minimum 10, more buffer is better
  
  Book *theBook = [self.bookDataArray objectAtIndex:bookIndex];
  if (pageIndex <= (int)theBook.pages.count - numBufferPages)
    return;
  
  //Still make sure the number of pages is even
  int lastPage = pageIndex + numBufferPages;
  if (lastPage % 2 != 0)
    lastPage++;
  
  for (int i=theBook.pages.count; i<lastPage; i++)
    [self addPageToBookIndex:bookIndex];
}


#pragma mark - PPScrollListViewControllerDataSource
#pragma mark Non-functional in free-to-try version

- (int)ppPepperViewController:(PPPepperViewController*)scrollList numberOfBooks:(int)dummy;
{
  return self.bookDataArray.count;
}

- (int)ppPepperViewController:(PPPepperViewController*)scrollList numberOfPagesForBookIndex:(int)bookIndex
{
  if (bookIndex < 0 || bookIndex >= self.bookDataArray.count)
    return 0;
  Book *theBook = [self.bookDataArray objectAtIndex:bookIndex];
  return theBook.pages.count;
}

- (int)ppPepperViewController:(PPPepperViewController*)scrollList numberOfDetailPagesForBookIndex:(int)bookIndex
{
  if (bookIndex < 0 || bookIndex >= self.bookDataArray.count)
    return 0;
  Book *theBook = [self.bookDataArray objectAtIndex:bookIndex];
  return theBook.pages.count;
}

- (UIView*)ppPepperViewController:(PPPepperViewController*)scrollList viewForBookIndex:(int)bookIndex withFrame:(CGRect)frame reusableView:(UIView*)contentView
{
  Book *theBook = [self.bookDataArray objectAtIndex:bookIndex];
  
  MyBookOrPageView *view = nil;
  if (contentView == nil || ![contentView isKindOfClass:[MyBookOrPageView class]])
    view = [[MyBookOrPageView alloc] initWithFrame:frame];
  else
    view = (MyBookOrPageView*)contentView;

  [view configureWithBookModel:theBook];
  return view;
}

- (UIView*)ppPepperViewController:(PPPepperViewController*)scrollList thumbnailViewForPageIndex:(int)pageIndex inBookIndex:(int)bookIndex withFrame:(CGRect)frame reusableView:(UIView*)contentView
{
  //Return nil for the last page if number of actual page data is odd
  Book *theBook = [self.bookDataArray objectAtIndex:bookIndex];
  int numPages = [theBook.pages count];
  if (pageIndex >= numPages)
    return nil;
  
  Page *thePage = [theBook.pages objectAtIndex:pageIndex];

  MyBookOrPageView *view = nil;
  if (contentView == nil || ![contentView isKindOfClass:[MyBookOrPageView class]])
    view = [[MyBookOrPageView alloc] initWithFrame:frame];
  else
    view = (MyBookOrPageView*)contentView;
  
  [view configureWithPageModel:thePage];
  return view;
}

- (UIView*)ppPepperViewController:(PPPepperViewController*)scrollList detailViewForPageIndex:(int)pageIndex inBookIndex:(int)bookIndex withFrame:(CGRect)frame reusableView:(UIView*)contentView
{
  //Return nil for the last page if number of actual page data is odd
  Book *theBook = [self.bookDataArray objectAtIndex:bookIndex];
  int numPages = [theBook.pages count];
  if (pageIndex >= numPages)
    return nil;
  
  Page *thePage = [theBook.pages objectAtIndex:pageIndex];
  
  MyPageViewDetail *view = nil;
  if (contentView == nil || ![contentView isKindOfClass:[MyPageViewDetail class]])
    view = [[MyPageViewDetail alloc] initWithFrame:frame];
  else
    view = (MyPageViewDetail*)contentView;
  
  [view configureWithPageModel:thePage];
  return view;
}




#pragma mark - PPScrollListViewControllerDelegate

/*
 * This is called when the book list is being scrolled
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didScrollWithBookIndex:(float)bookIndex
{
  //Commented out for performance reason
  //NSLog(@"%@", [NSString stringWithFormat:@"didScrollWithBookIndex:%.2f", bookIndex]);
}

/*
 * This is called after the fullscreen list has finish snapping to a page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didSnapToBookIndex:(int)bookIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didSnapToBookIndex:%d", bookIndex]);
}

/*
 * This is called when a book is tapped on
 * The book will open automatically by the library if AUTO_OPEN_BOOK is enabled (default)
 * Otherwise you need to call [pepperViewController openCurrentBookAtPageIndex:0]; yourself
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didTapOnBookIndex:(int)bookIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didTapOnBookIndex:%d", bookIndex]);
  
  //You can implement your own logic here to prompt user to login before viewinh this content if needed
  //You can implement your own logic here to get remembered last opened page for this book
  
  //Open random page for demo purpose
  Book *theBook = [self.bookDataArray objectAtIndex:bookIndex];
  int pageCount = theBook.pages.count - 1;
  int randomPage = rand() % pageCount;
  int pageIndex = self.switchRandomPage.on ? randomPage : 0;
  if (self.switchRandomPage.on)
    NSLog(@"Open current book at random page: %d", randomPage);
  
  //This is mandatory in version 1.3.0 and above
  [scrollList openCurrentBookAtPageIndex:pageIndex];
  
  //Hide menu bar, show Close button
  [self showHideMenuBar:NO];
  [self showHideCloseButton:YES];
}

/*
 * This is called just before & after the book opens & closes
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList willOpenBookIndex:(int)bookIndex andDuration:(float)duration
{
  NSLog(@"%@", [NSString stringWithFormat:@"willOpenBookIndex:%d duration:%.2f", bookIndex, duration]);
  
  //Hide our menu together with the books
  [self showHideMenuBar:NO];
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList didOpenBookIndex:(int)bookIndex atPageIndex:(int)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didOpenBookIndex:%d atPageIndex:%d", bookIndex, pageIndex]);
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList didCloseBookIndex:(int)bookIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didCloseBookIndex:%d", bookIndex]);
  
  //Show menu bar, hide Close button
  [self showHideMenuBar:YES];
  [self showHideCloseButton:NO];
}

/*
 * When the book is being closed, the library will calculate the necessary alpha value to reveal the initial menu bar
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList closingBookWithAlpha:(float)alpha
{
  //Commented out for performance reason
  //NSLog(@"%@", [NSString stringWithFormat:@"closingBookWithAlpha:%.2f", alpha]);
  
  [self showHideMenuBarWithAlpha:alpha];
}

/*
 * This is called when a page is tapped on
 * The book will open automatically by the library if AUTO_OPEN_PAGE is enabled (default)
 * Otherwise you need to call [pepperViewController openPageIndex:xxx]; yourself
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didTapOnPageIndex:(int)pageIndex
{
  //This is mandatory in version 1.3.0 and above
  [scrollList openPageIndex:pageIndex];
  
  NSLog(@"%@", [NSString stringWithFormat:@"didTapOnPageIndex:%d", pageIndex]);
}

/*
 * This is called when the 3D view is being flipped
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didFlippedWithIndex:(float)index
{ 
  //Commented out for performance reason
  //NSLog(@"%@", [NSString stringWithFormat:@"didFlippedWithIndex:%.2f", index]);
  
  //Built-in demo content
  if (self.pepperViewController.dataSource != self)
    return;
  
  //Add new pages when there is a change of (integer) page
  static int previousIndex = -1;
  if (previousIndex < 0)
    previousIndex = index;
  if (fabsf(index-previousIndex) >= 1) {
    previousIndex = index;
    [self loadMorePageForBookIndex:[self.pepperViewController getCurrentBookIndex] currentPageIndex:index];
  }
}

/*
 * This is called after the flipping finish snapping to a page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didFinishFlippingWithIndex:(float)index
{
  NSLog(@"%@", [NSString stringWithFormat:@"didFinishFlippingWithIndex:%.2f", index]);
  
  //Built-in demo content
  if (self.pepperViewController.dataSource != self)
    return;
  
  //Infinite book
  //It's better to be implemented here, but fast scrolling is causing problem
  //[self loadMorePageForBookIndex:[self.pepperViewController getCurrentBookIndex] currentPageIndex:pageIndex];
}

/*
 * This is called when the fullscreen list is being scrolled
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didScrollWithPageIndex:(float)pageIndex
{
  //Commented out for performance reason
  //NSLog(@"%@", [NSString stringWithFormat:@"didScrollWithPageIndex:%.2f", pageIndex]);
}

/*
 * This is called after the fullscreen list has finish snapping to a page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didSnapToPageIndex:(int)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didSnapToPageIndex:%d", pageIndex]);
}

/*
 * This is called during & after a fullscreen page is zoom
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didZoomWithPageIndex:(int)pageIndex zoomScale:(float)zoomScale
{
  //Commented out for performance reason
  //NSLog(@"%@", [NSString stringWithFormat:@"didZoomWithPageIndex:%d zoomScale:%.2f", pageIndex, zoomScale]);
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList didEndZoomingWithPageIndex:(int)pageIndex zoomScale:(float)zoomScale
{
  NSLog(@"%@", [NSString stringWithFormat:@"didEndZoomingWithPageIndex:%d zoomScale:%.2f", pageIndex, zoomScale]);
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList willOpenPageIndex:(int)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"willOpenPageIndex:%d", pageIndex]);  
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList didOpenPageIndex:(int)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didOpenPageIndex:%d", pageIndex]);  
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList didClosePageIndex:(int)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didClosePageIndex:%d", pageIndex]);
}

/*
 * This is called when a fullscreen page is tapped
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didTapOnFullscreenPageIndex:(int)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didTapOnFullscreenPageIndex:%d", pageIndex]);
}


@end
