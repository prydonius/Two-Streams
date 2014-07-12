//
//  PRYPeerflixHelper.m
//  Two Streams
//
//  Created by Adnan Abdulhussein on 17/06/2014.
//  Copyright (c) 2014 Adnan Abdulhussein. All rights reserved.
//

#import "PRYPeerflixHelper.h"
#import "AMR_ANSIEscapeHelper.h"

@implementation PRYPeerflixHelper

@synthesize fileIndex;

- (id)initWithMagnetLink:(NSString *)magnetLink
{
    self = [super init];
    if (self)
    {
        self.magnetLink = magnetLink;
    }
    return self;
}

- (void)getFileListWithHandlerOnComplete:(void (^) (NSArray *fileList))completeBlock
{
    [self launchPeerflixCommand:@[@"-l"] onUpdate:nil onComplete:^(NSNotification *notification, NSPipe *pipe) {
        // Get command output
        NSData *output = [[pipe fileHandleForReading] availableData];
        NSString *outStr = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
        outStr = [self removeANSIColourCodesFromString:outStr];
        
        // Get list of files
        NSMutableArray *array = [[outStr componentsSeparatedByString:@"\n"] mutableCopy];
        // Remove empty string at the end
        [array removeLastObject];
        for (int i = 0; i < [array count]; i++)
        {
            [array setObject:[[array objectAtIndex:i] componentsSeparatedByString:@": "][1] atIndexedSubscript:i];
        }
        
        completeBlock(array);
    }];
}

- (void)launchStreamWithHandlersOnUpdate:(void (^) (NSDictionary *info))updateBlock onComplete:(void (^) ())completeBlock
{
    NSArray *args = @[@"-i", [NSString stringWithFormat:@"%ld", fileIndex], @"--vlc"];
    [self launchPeerflixCommand:args onUpdate:^(NSNotification *notification, NSPipe *pipe) {
        // Get command output
        NSData *output = [[pipe fileHandleForReading] availableData];
        NSString *outStr = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
        outStr = [self removeANSIColourCodesFromString:outStr];
        
        // Extract useful data and callback
        NSError *error;
        NSString *regex = @"streaming\\ .*\\((.*)\\)\\ -\\ (.*/s)\\ from\\ (.*)\\ peers.*downloaded\\ (.*)\\ and\\ uploaded\\ (.*)\\ in\\ ";
        NSRegularExpression* exp = [NSRegularExpression regularExpressionWithPattern:regex
                                                                             options:NSRegularExpressionDotMatchesLineSeparators
                                                                               error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSTextCheckingResult* result = [exp firstMatchInString:outStr options:0 range:NSMakeRange(0, [outStr length]) ];
            
            if (result) {
                // 0 is the WHOLE string
                updateBlock(@{@"fileSize":     [outStr substringWithRange:[result rangeAtIndex:1]],
                              @"downloadRate": [outStr substringWithRange:[result rangeAtIndex:2]],
                              @"peers":        [outStr substringWithRange:[result rangeAtIndex:3]],
                              @"downloaded":   [outStr substringWithRange:[result rangeAtIndex:4]],
                              @"uploaded":     [outStr substringWithRange:[result rangeAtIndex:5]]
                            });
            }
        }
    } onComplete:^(NSNotification *notification, NSPipe *pipe) {
        completeBlock();
    }];
}

- (void)launchPeerflixCommand:(NSArray *)args onUpdate:(void (^)(NSNotification *notification, NSPipe *pipe))updateBlock onComplete:(void (^) (NSNotification *notification, NSPipe *pipe))completeBlock
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    // Set launch path to node executable
    NSString *execPath = [resourcePath stringByAppendingPathComponent:@"Vendor/node/bin/node"];
    NSTask *task = [NSTask new];
    [task setLaunchPath: execPath];
    
    // Setup arguments
    NSMutableArray *taskArgs = [@[
        [resourcePath stringByAppendingPathComponent:@"Vendor/peerflix/app.js"],
        self.magnetLink
    ] mutableCopy];
    [task setArguments:[taskArgs arrayByAddingObjectsFromArray:args]];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    [task launch];
    
    // Observe output and call callbacks
    if (updateBlock != nil) {
        [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:[pipe fileHandleForReading] queue:nil usingBlock:^(NSNotification *notification) {
            updateBlock(notification, pipe);
            [[pipe fileHandleForReading] waitForDataInBackgroundAndNotify];
        }];
    }
    
    if (completeBlock != nil) {
        [[NSNotificationCenter defaultCenter] addObserverForName:NSTaskDidTerminateNotification object:task queue:nil usingBlock:^(NSNotification *note) {
            completeBlock(note, pipe);
        }];
    }
    
    [[pipe fileHandleForReading] waitForDataInBackgroundAndNotify];
}

- (NSString *)removeANSIColourCodesFromString:(NSString *)string
{
    AMR_ANSIEscapeHelper *ansiEscapeHelper = [AMR_ANSIEscapeHelper new];
    NSAttributedString *attrStr = [ansiEscapeHelper attributedStringWithANSIEscapedString:string];
    return [attrStr string];
}

@end
