//
//  PRYAppDelegate.h
//  Two Streams
//
//  Created by Adnan Abdulhussein on 16/06/2014.
//  Copyright (c) 2014 Adnan Abdulhussein. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PRYFileViewController.h"
#import "PRYStreamViewController.h"

@interface PRYAppDelegate : NSObject <NSApplicationDelegate, PRYFileViewControllerDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) PRYFileViewController *fileViewController;
@property (strong) PRYStreamViewController *streamViewController;

@end
