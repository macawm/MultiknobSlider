//
//  MultiknobTableCellView.h
//  MultiknobSlider
//
//  Created by Anthony Magee on 9/4/12.
//  Copyright (c) 2012
//

#import <Cocoa/Cocoa.h>

@class MultiknobSlider;

@interface MultiknobTableCellView : NSTableCellView

@property (weak) IBOutlet MultiknobSlider* slider;

@end
