//
//  MyImageCache.m
//
//  Created by Torin Nguyen on 14/6/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#import "MyImageCache.h"

@interface MyImageCache()
@property (nonatomic, strong) NSMutableDictionary *cacheDict;
@property (nonatomic, strong) NSMutableArray *cacheKeyArray;
@end

@implementation MyImageCache
@synthesize cacheDict;
@synthesize cacheKeyArray;

+ (MyImageCache*)sharedCached
{
  static MyImageCache *_sharedCache = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedCache = [[self alloc] init];
  });
  
  return _sharedCache;
}

- (id)init
{
  self = [super init];
  if (!self)
    return nil;
  
  self.cacheKeyArray = [[NSMutableArray alloc] init];
  self.cacheDict = [[NSMutableDictionary alloc] init];
  return self;
}

- (UIImage*)imageForKey:(NSString*)key
{
  if (key == nil)
    return nil;
  
  //No cache
  id obj = [self.cacheDict objectForKey:key];
  if (obj == nil)
    return nil;
  
  //Assertion
  if ([obj isKindOfClass:[UIImage class]])
    return obj;
  
  //Invalid type of object, remove it
  [self.cacheDict removeObjectForKey:key];
  return nil;
}

- (void)addImage:(UIImage*)image ForKey:(NSString*)key
{
  if (image == nil || key == nil)
    return;
  
  //Delete oldest cache
  if (self.cacheKeyArray.count > 10)
    [self removeImageForKey:[self.cacheKeyArray objectAtIndex:0]];
  
  //Add new cache object
  [self.cacheKeyArray addObject:key];
  [self.cacheDict setObject:image forKey:key];
}

- (void)removeImageForKey:(NSString*)key
{
  if (key == nil)
    return;
  
  [self.cacheKeyArray removeObject:key];
  [self.cacheDict removeObjectForKey:key];
}

- (void)removeAll
{
  while (self.cacheKeyArray.count > 0)
    [self removeImageForKey:[self.cacheKeyArray objectAtIndex:0]];
}

@end
