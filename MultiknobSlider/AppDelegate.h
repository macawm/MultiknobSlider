//
//  AppDelegate.h
//  MultiknobSlider
//
//  Created by Anthony Magee on 8/30/12.
//  Copyright (c) 2012
//

#import <Cocoa/Cocoa.h>

@class KnobArray;
@class MultiknobSlider;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) NSMutableArray* sliderArray;

@end
