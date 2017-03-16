//
//  MergeFiles.h
//  Media
//
//  Created by tuios on 3/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//
@protocol MergeFilesDelegate <NSObject>
@optional
- (void)didFinishMerge:(NSString *)name fromPath:(NSString *)fromPath toLocation:(NSURL *)toLocation;
@end
#import <Foundation/Foundation.h>
@interface MergeFiles: NSObject
@property (nonatomic, weak) id <MergeFilesDelegate> delegate;
- (void)mergeFile:(NSString *)atPath andOutput:(NSString *)output withBaseURL:(NSString *)baseURL;
@end
