//
//  PRYStreamViewController.h
//  Two Streams
//
//  Created by Adnan Abdulhussein on 05/07/2014.
//  Copyright (c) 2014 Adnan Abdulhussein. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PRYPeerflixHelper.h"

@interface PRYStreamViewController : NSViewController

@property (weak) IBOutlet NSTextField *fileNameLabel;
@property (weak) IBOutlet NSTextField *downloadRateLabel;
@property (weak) IBOutlet NSTextField *peersLabel;
@property (weak) IBOutlet NSTextField *downloadedLabel;
@property (weak) IBOutlet NSTextField *uploadedLabel;
@property (weak) IBOutlet NSTextField *fileSizeLabel;

@property (strong) PRYPeerflixHelper *peerflixHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(PRYPeerflixHelper *)model fileName:(NSString *)fileName;

@end
