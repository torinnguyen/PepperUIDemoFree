//
// Book.h
//
// This is just a dummy data model for a Book for demo purpose
// You should replace it with your own data model
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, assign) int bookID;
@property (nonatomic, strong) NSString * coverURL;
@property (nonatomic, retain) NSMutableArray * pages;
@property (nonatomic, assign, readonly) int totalPages;

@end

