//
//  PRYFileViewController.h
//  Two Streams
//
//  Created by Adnan Abdulhussein on 05/07/2014.
//  Copyright (c) 2014 Adnan Abdulhussein. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PRYPeerflixHelper.h"

@protocol PRYFileViewControllerDelegate <NSObject>

- (void)startStreamWithModel:(PRYPeerflixHelper *)peerflixHelper fileName:(NSString *)fileName;

@end

@interface PRYFileViewController : NSViewController <NSTableViewDataSource>

@property (nonatomic, weak) id <PRYFileViewControllerDelegate> delegate;
@property IBOutlet NSTableView *tableView;
@property NSArray *list;
@property (strong) PRYPeerflixHelper *peerflixHelper;
@property (weak) IBOutlet NSButton *streamButton;
@property BOOL populated;

- (void)populateListFromMagnetLink:(NSString *)link;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id <PRYFileViewControllerDelegate>)delegate;
- (IBAction)startStream:(id)sender;

@end
