
#import "Book.h"

@implementation Book

@synthesize bookID;
@synthesize coverURL;
@synthesize totalPages;
@synthesize pages;

- (int)getTotalPages {
  return [self.pages count];
}

@end
