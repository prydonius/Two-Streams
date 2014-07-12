//
//  PRYStreamViewController.m
//  Two Streams
//
//  Created by Adnan Abdulhussein on 05/07/2014.
//  Copyright (c) 2014 Adnan Abdulhussein. All rights reserved.
//

#import "PRYStreamViewController.h"

@interface PRYStreamViewController ()

@end

@implementation PRYStreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(PRYPeerflixHelper *)model fileName:(NSString *)fileName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _peerflixHelper = model;
        [_peerflixHelper launchStreamWithHandlersOnUpdate:^(NSDictionary *info) {
            [_fileNameLabel setStringValue:fileName];
            // Go through dictionary and set labels in UI
            [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [[self valueForKey:[NSString stringWithFormat:@"%@Label", key]] setStringValue:obj];
            }];
        } onComplete:^{
            [NSApp terminate:nil];
        }];
    }
    return self;
}

@end
