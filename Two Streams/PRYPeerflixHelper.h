//
//  PRYPeerflixHelper.h
//  Two Streams
//
//  Created by Adnan Abdulhussein on 17/06/2014.
//  Copyright (c) 2014 Adnan Abdulhussein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRYPeerflixHelper : NSObject

@property NSString *magnetLink;
@property long fileIndex;

- (id)initWithMagnetLink:(NSString *)magnetLink;
- (void)getFileListWithHandlerOnComplete:(void (^) (NSArray *fileList))completeBlock;
- (void)launchStreamWithHandlersOnUpdate:(void (^) (NSDictionary *info))updateBlock onComplete:(void (^) ())completeBlock;

@end
