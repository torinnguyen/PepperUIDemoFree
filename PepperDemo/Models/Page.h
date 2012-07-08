//
// Page.h
//
// This is just a dummy data model for a Page within a Book for demo purpose
// You should replace it with your own data model
//

#import <Foundation/Foundation.h>

@interface Page : NSObject

@property (nonatomic, assign) int pageID;
@property (nonatomic, strong) NSString * fullsizeURL;
@property (nonatomic, strong) NSString * halfsizeURL;

@end
