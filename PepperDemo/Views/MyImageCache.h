//
//  MyImageCache.h
//
//  Created by Torin Nguyen on 14/6/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//
//
//  This is a very simple image caching cache for demo purpose.
//  It is not production-grade cache library.
//  Please use SDImageCahe library or equivalent in your production code.
//

#import <UIKit/UIKit.h>

@interface MyImageCache : NSObject

+ (MyImageCache*)sharedCached;

- (UIImage*)imageForKey:(NSString*)key;
- (void)addImage:(UIImage*)image ForKey:(NSString*)key;
- (void)removeImageForKey:(NSString*)key;
- (void)removeAll;

@end
