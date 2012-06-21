//
//  MyBookOrPageView.m
//
//  Created by Torin Nguyen on 26/4/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#import "MyBookOrPageView.h"

@interface MyBookOrPageView()
@property (nonatomic, strong) id theModel;
@end

@implementation MyBookOrPageView

@synthesize theModel;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

//
// Populate various UI elements with a Book model data
//
- (void)configureWithBookModel:(Book*)bookModel
{
  self.theModel = bookModel;
  self.imageView.image = nil;
  
  if (bookModel.coverURL != nil) {
    [self fetchImageWithUrl:bookModel.coverURL];
    return;
  }
  
  Page *firstPage = [bookModel.pages objectAtIndex:0];
  [self fetchImageWithUrl:firstPage.halfsizeURL];
}

//
// Populate various UI elements with a Page model  data
//
- (void)configureWithPageModel:(Page*)pageModel
{
  self.theModel = pageModel;
  self.imageView.image = nil;
  [self fetchImageWithUrl:pageModel.halfsizeURL];
}

//
// To be called when large thumbnail is done loading
//
- (void)refresh
{
  if ([self.theModel isKindOfClass:[Book class]])
    [self configureWithBookModel:(Book*)theModel];
  
  if ([self.theModel isKindOfClass:[Page class]])
    [self configureWithPageModel:(Page*)theModel];
}

@end
