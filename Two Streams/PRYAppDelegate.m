//
//  PRYAppDelegate.m
//  Two Streams
//
//  Created by Adnan Abdulhussein on 16/06/2014.
//  Copyright (c) 2014 Adnan Abdulhussein. All rights reserved.
//

#import "PRYAppDelegate.h"
#import "AMR_ANSIEscapeHelper.h"

@implementation PRYAppDelegate

- (id)init
{
    self = [super init];
    
    [[NSAppleEventManager sharedAppleEventManager]
     setEventHandler:self
     andSelector:@selector(handleURLEvent:withReplyEvent:)
     forEventClass: kInternetEventClass andEventID: kAEGetURL];
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void)handleURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSString *url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    if (_fileViewController == nil) {
        _fileViewController = [[PRYFileViewController alloc] initWithNibName:@"PRYFileViewController" bundle:nil delegate:self];
    }
    [_fileViewController populateListFromMagnetLink:url];
    _window.contentView = [_fileViewController view];
}

- (void)startStreamWithModel:(PRYPeerflixHelper *)peerflixHelper fileName:(NSString *)fileName
{
    _streamViewController = [[PRYStreamViewController alloc] initWithNibName:@"PRYStreamViewController" bundle:nil model:peerflixHelper fileName:(NSString *)fileName];
    _window.contentView = [_streamViewController view];
}

@end
