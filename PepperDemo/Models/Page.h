
#import <Foundation/Foundation.h>

@interface Page : NSObject

@property (nonatomic, assign) int pageID;
@property (nonatomic, strong) NSString * fullsizeURL;
@property (nonatomic, strong) NSString * halfsizeURL;

@end
