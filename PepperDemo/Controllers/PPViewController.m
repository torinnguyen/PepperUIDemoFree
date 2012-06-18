//
//  PPViewController.m
//
//  Created by Torin Nguyen on 2/6/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#include <stdlib.h>   //simply for random number function

#import "PPViewController.h"
#import "PPPepperViewController.h"

@interface PPViewController () <PPScrollListViewControllerDelegate>
@property (nonatomic, strong) IBOutlet UIView * menuView;
@property (nonatomic, strong) IBOutlet UIView * speedView;
@property (nonatomic, strong) IBOutlet UISegmentedControl * speedSegmented;
@property (nonatomic, strong) IBOutlet UISwitch * switchRandomPage;
@property (nonatomic, strong) IBOutlet UISwitch * switchScaleOnDeviceRotation;
@property (nonatomic, strong) IBOutlet UILabel * lblSpeed;

@property (nonatomic, strong) PPPepperViewController * pepperViewController;
@property (nonatomic, strong) NSMutableArray *bookDataArray;
@end

@implementation PPViewController
@synthesize menuView;
@synthesize speedView;
@synthesize speedSegmented;
@synthesize switchRandomPage;
@synthesize switchScaleOnDeviceRotation;
@synthesize lblSpeed;

@synthesize pepperViewController;
@synthesize bookDataArray;

- (void)viewDidLoad
{
  [super viewDidLoad];

  //Basic setup
  self.pepperViewController = [[PPPepperViewController alloc] init];  
  self.pepperViewController.view.frame = self.view.bounds;
  [self.view addSubview:self.pepperViewController.view];
  [self.pepperViewController reload];

  //Supply it with your own data/model
  self.pepperViewController.delegate = self;        //we are simply printing out all delegate events in this demo
  //self.pepperViewController.dataSource = self;    //not available in free-to-try version
  
  //Optional
  [self onSpeedChange:self.speedSegmented];
  [self onSwitchRandomPage:self.switchRandomPage];
  [self onSwitchScaleOnDeviceRotation:self.switchScaleOnDeviceRotation];
  
  //Bring our top level menu to highest z-index
  [self.view bringSubviewToFront:self.menuView];
  [self.view bringSubviewToFront:self.speedView];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.pepperViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.pepperViewController viewDidAppear:animated];
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
  [self.pepperViewController willRotateToInterfaceOrientation:toInterfaceOrientation
                                                     duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                         duration:(NSTimeInterval)duration {
  [self.pepperViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                                              duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
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



#pragma mark -
#pragma mark - PPScrollListViewControllerDelegate

/*
 * This is called when the book list is being scrolled
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didScrollWithBookIndex:(float)bookIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didScrollWithBookIndex:%.2f", bookIndex]);
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
  int randomPage = rand() % DEMO_NUM_PAGES;
  int pageIndex = self.switchRandomPage.on ? randomPage : 0;
  if (self.switchRandomPage.on)
    NSLog(@"Open current book at random page: %d", randomPage);
  
  //This is needed when AUTO_OPEN_BOOK is disabled (default)
  [scrollList openCurrentBookAtPageIndex:pageIndex];
}

/*
 * This is called just before & after the book opens & closes
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList willOpenBookIndex:(int)bookIndex andDuration:(float)duration
{
  NSLog(@"%@", [NSString stringWithFormat:@"willOpenBookIndex:%d duration:%.2f", bookIndex, duration]);
  
  //Hide our menu together with the books
  self.menuView.userInteractionEnabled = NO;
  [UIView animateWithDuration:duration animations:^{
    self.menuView.alpha = 0;
    self.speedView.alpha = 1;
  }];
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList didOpenBookIndex:(int)bookIndex atPageIndex:(int)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didOpenBookIndex:%d atPageIndex:%d", bookIndex, pageIndex]);
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList didCloseBookIndex:(int)bookIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didCloseBookIndex:%d", bookIndex]); 
}

/*
 * When the book is being closed, the library will calculate the necessary alpha value to reveal the initial menu bar
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList closingBookWithAlpha:(float)alpha
{
  NSLog(@"%@", [NSString stringWithFormat:@"closingBookWithAlpha:%.2f", alpha]);
  
  //Show our menu together with the books
  self.menuView.alpha = alpha;
  self.speedView.alpha = 1.0 - alpha;
  self.lblSpeed.text = [NSString stringWithFormat:@"%.1fx", self.pepperViewController.animationSlowmoFactor];
  self.menuView.userInteractionEnabled = (alpha != 0);
}

/*
 * This is called when a page is tapped on
 * The book will open automatically by the library if AUTO_OPEN_PAGE is enabled (default)
 * Otherwise you need to call [pepperViewController openPageIndex:xxx]; yourself
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didTapOnPageIndex:(int)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didTapOnPageIndex:%d", pageIndex]);
}

/*
 * This is called when the 3D view is being flipped
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didFlippedWithIndex:(float)index
{
  NSLog(@"%@", [NSString stringWithFormat:@"didFlippedWithIndex:%.2f", index]);
}

/*
 * This is called after the flipping finish snapping to a page
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didFinishFlippingWithIndex:(float)index
{
  NSLog(@"%@", [NSString stringWithFormat:@"didFinishFlippingWithIndex:%.2f", index]);
}

/*
 * This is called when the fullscreen list is being scrolled
 */
- (void)ppPepperViewController:(PPPepperViewController*)scrollList didScrollWithPageIndex:(float)pageIndex
{
  NSLog(@"%@", [NSString stringWithFormat:@"didScrollWithPageIndex:%.2f", pageIndex]);
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
  NSLog(@"%@", [NSString stringWithFormat:@"didZoomWithPageIndex:%d zoomScale:%.2f", pageIndex, zoomScale]);
}

- (void)ppPepperViewController:(PPPepperViewController*)scrollList didEndZoomingWithPageIndex:(int)pageIndex zoomScale:(float)zoomScale
{
  NSLog(@"%@", [NSString stringWithFormat:@"didEndZoomingWithPageIndex:%d zoomScale:%.2f", pageIndex, zoomScale]);
}

@end
