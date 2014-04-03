//
//  MultiknobSliderCell.h
//  MultiknobSlider
//
//  Created by Anthony Magee on 8/30/12.
//  Copyright (c) 2012
//

#import <Cocoa/Cocoa.h>

@protocol MultiknobSliderDataSource <NSObject>
- (NSUInteger)numberOfKnobs;
- (NSUInteger)activeKnobIndex;
- (void)setActiveKnobIndex:(NSUInteger)knobIndex;

- (double)valueOfKnobAtIndex:(NSUInteger)knobIndex;
- (void)setValueOfKnobAtIndex:(NSUInteger)knobIndex toValue:(double)value;
- (NSColor*)tintOfKnobAtIndex:(NSUInteger)knobIndex;
- (void)setTintOfKnobAtIndex:(NSUInteger)knobIndex toTint:(NSColor*)color;

- (BOOL)isGrouped;
- (void)updateGroup;
- (id)getPreviousDataSource;
- (id)getNextDataSource;
@end


@protocol MultiknobSliderGroupDelegate <NSObject>
- (void)setGroupNeedsDisplay:(BOOL)needsDisplay;
@end


@interface MultiknobSliderCell : NSActionCell

@property () double incrementValue;
@property () double maxValue;
@property () double minValue;
@property () double defaultKnobSize;
@property () double alternateKnobSize;
@property () BOOL drawTickMarks;
@property () NSUInteger numberOfTickMarks;

- (void)drawKnob:(NSRect)knobRect withTint:(NSColor*)tint isActive:(BOOL)active;
- (void)drawKnobShadow:(NSRect)knobRect isActive:(BOOL)active;
- (void)drawConnectorFromPoint:(NSPoint)start toPoint:(NSPoint)end withTint:(NSColor*)tint isActive:(BOOL)active;

@end
