//
//  KnobArray.h
//  MultiknobSlider
//
//  Created by Anthony Magee on 9/4/12.
//  Copyright (c) 2012
//

#import <Foundation/Foundation.h>
#import "MultiknobSliderCell.h"

@interface KnobArray : NSObject <MultiknobSliderDataSource>

@property (assign) BOOL grouped;
@property (strong) NSMutableArray* relatives;
@property (strong) NSView* groupView;



- (BOOL)validKnobIndex:(NSUInteger)knobIndex;
- (NSUInteger)count;

- (void)setKnobValue:(double)value forKnobIndex:(NSUInteger)knobIndex;
- (double)knobValueForIndex:(NSUInteger)knobIndex;

- (void)setKnobTint:(NSColor*)color forKnowIndex:(NSUInteger)knobIndex;
- (NSColor*)knobTintForIndex:(NSUInteger)knobIndex;

- (void)addKnobWithInitialValue:(double)initialValue;
- (void)addKnobWithInitialValue:(double)initialValue withTint:(NSColor*)tint;

- (void)insertKnobWithInitialValue:(double)initialValue atIndex:(NSUInteger)insertIndex;
- (void)insertKnobWithInitialValue:(double)initialValue withTint:(NSColor*)tint atIndex:(NSUInteger)insertIndex;

- (void)removeKnobAtIndex:(NSUInteger)knobIndex;

@end
