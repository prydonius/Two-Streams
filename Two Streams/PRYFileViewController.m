//
//  PRYFileViewController.m
//  Two Streams
//
//  Created by Adnan Abdulhussein on 05/07/2014.
//  Copyright (c) 2014 Adnan Abdulhussein. All rights reserved.
//

#import "PRYFileViewController.h"

@interface PRYFileViewController ()

@end

@implementation PRYFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id <PRYFileViewControllerDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _delegate = delegate;
        _populated = false;
        _list = @[];
    }
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_list count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [_list objectAtIndex:row];
}

- (void)populateListFromMagnetLink:(NSString *)link
{
    _peerflixHelper = [[PRYPeerflixHelper alloc] initWithMagnetLink:link];
    [_peerflixHelper getFileListWithHandlerOnComplete:^(NSArray *fileList) {
        _list = fileList;
        [_tableView reloadData];
        _populated = true;
    }];
}

- (IBAction)tableViewAction:(id)sender
{
    if (self.populated)
    {
        [self.streamButton setEnabled:true];
    }
}

- (IBAction)startStream:(id)sender
{
    _peerflixHelper.fileIndex = [_tableView selectedRow];
    [_delegate startStreamWithModel:_peerflixHelper fileName:[_list objectAtIndex:[_tableView selectedRow]]];
}

@end
