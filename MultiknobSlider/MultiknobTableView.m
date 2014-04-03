//
//  MultiknobTableView.m
//  MultiknobSlider
//
//  Created by Anthony Magee on 9/5/12.
//  Copyright (c) 2012
//

#import "MultiknobTableView.h"

@implementation MultiknobTableView

- (void)setGroupNeedsDisplay:(BOOL)needsDisplay {
    if (needsDisplay) {
        [self enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row) {
            [rowView setNeedsDisplay:YES];
        }];
    }
}

@end
