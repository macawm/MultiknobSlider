//
//  KnobArray.m
//  MultiknobSlider
//
//  Created by Anthony Magee on 9/4/12.
//  Copyright (c) 2012
//

#import "KnobArray.h"
#import "MultiknobTableView.h"

@interface KnobArray ()
@property (strong) NSMutableArray* values;
@property (strong) NSMutableArray* tints;
@property () NSUInteger active;
@end

@implementation KnobArray

- (id)init {
    self = [super init];
    if (self) {
        _values = [[NSMutableArray alloc] initWithCapacity:1];
        _tints = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return self;
}

- (BOOL)validKnobIndex:(NSUInteger)knobIndex {
    return knobIndex < _values.count;
}

- (NSUInteger)count {
    return _values.count;
}

- (void)setKnobValue:(double)value forKnobIndex:(NSUInteger)knobIndex {
    if ([self validKnobIndex:knobIndex])
        [_values setObject:[NSNumber numberWithDouble:value] atIndexedSubscript:knobIndex];
    
    else
        [NSException raise:@"Invalid knobIndex value" format:@"knobIndex (%ld) outside of valid range [0, %ld]", knobIndex, _values.count];
}

- (double)knobValueForIndex:(NSUInteger)knobIndex {
    double val;
    if ([self validKnobIndex:knobIndex])
        val = ((NSNumber*)[_values objectAtIndex:knobIndex]).doubleValue;
    
    else
        [NSException raise:@"Invalid knobIndex value" format:@"knobIndex (%ld) outside of valid range [0, %ld]", knobIndex, _values.count];
    
    return val;
}

- (void)setKnobTint:(NSColor *)color forKnowIndex:(NSUInteger)knobIndex {
    if ([self validKnobIndex:knobIndex])
        [_tints setObject:color atIndexedSubscript:knobIndex];
    
    else
        [NSException raise:@"Invalid knobIndex value" format:@"knobIndex (%ld) outside of valid range [0, %ld]", knobIndex, _values.count];
}

- (NSColor *)knobTintForIndex:(NSUInteger)knobIndex {
    NSColor* tint;
    if ([self validKnobIndex:knobIndex])
        tint = (NSColor*)[_tints objectAtIndex:knobIndex];
    
    else
        [NSException raise:@"Invalid knobIndex value" format:@"knobIndex (%ld) outside of valid range [0, %ld]", knobIndex, _values.count];
    
    return tint;
}

- (void)addKnobWithInitialValue:(double)initialValue {
    [self addKnobWithInitialValue:initialValue withTint:[NSColor colorWithCalibratedWhite:208/255. alpha:1]];
}

- (void)addKnobWithInitialValue:(double)initialValue withTint:(NSColor*)tint {
    [_values addObject:[NSNumber numberWithDouble:initialValue]];
    [_tints addObject:tint];
    
    // set active knob index if needed
    if ([_values count] == 1)
        _active = 0;
}

- (void)insertKnobWithInitialValue:(double)intialValue atIndex:(NSUInteger)insertIndex {
    [self insertKnobWithInitialValue:intialValue withTint:[NSColor colorWithCalibratedWhite:208/255. alpha:1] atIndex:insertIndex];
}

- (void)insertKnobWithInitialValue:(double)initialValue withTint:(NSColor*)tint atIndex:(NSUInteger)insertIndex {
    if ([self validKnobIndex:insertIndex]) {
        [_values insertObject:[NSNumber numberWithDouble:initialValue] atIndex:insertIndex];
        [_tints insertObject:tint atIndex:insertIndex];
        
        // set active knob index if needed
        if ([_values count] == 1)
            _active = 0;
        
    } else // index out of bounds, just add it to the end of the array
        [self addKnobWithInitialValue:initialValue withTint:tint];
}

- (void)removeKnobAtIndex:(NSUInteger)knobIndex {
    if ([self validKnobIndex:knobIndex]) {
        [_values removeObjectAtIndex:knobIndex];
        [_tints removeObjectAtIndex:knobIndex];
        
        // set active knob index if needed
        if ([_values count] == 0)
            _active = NSUIntegerMax;
        
    } else
        [NSException raise:@"Invalid knobIndex value" format:@"knobIndex (%ld) outside of valid range [0, %ld]", knobIndex, _values.count];
}




#pragma mark - Multiknob slider data source
- (NSUInteger)numberOfKnobs {
    return [_values count];
}

- (NSUInteger)activeKnobIndex {
    return _active;
}

- (void)setActiveKnobIndex:(NSUInteger)knobIndex {
    _active = knobIndex;
}

- (double)valueOfKnobAtIndex:(NSUInteger)knobIndex {
    return [self knobValueForIndex:knobIndex];
}

- (void)setValueOfKnobAtIndex:(NSUInteger)knobIndex toValue:(double)value {
    [self setKnobValue:value forKnobIndex:knobIndex];
    
    [_groupView setNeedsDisplay:YES];
    [((KnobArray*)[self getPreviousDataSource]).groupView setNeedsDisplay:YES];
    [((KnobArray*)[self getNextDataSource]).groupView setNeedsDisplay:YES];

}

- (NSColor*)tintOfKnobAtIndex:(NSUInteger)knobIndex {
    return [self knobTintForIndex:knobIndex];
}

- (void)setTintOfKnobAtIndex:(NSUInteger)knobIndex toTint:(NSColor *)color {
    [self setKnobTint:color forKnowIndex:knobIndex];
}

- (BOOL)isGrouped {
    return _grouped;
}

- (void)updateGroup {
    for (KnobArray* kArray in [self relatives]) {
        if (kArray != self) {
            [kArray setActiveKnobIndex:self.active];
            [(MultiknobTableView*)kArray.groupView setGroupNeedsDisplay:YES];
        }
    }
}

- (id)getPreviousDataSource {
    id prev = nil;
    
    for (int i = (int)[_relatives count] - 1; i > 0; i--) {
        if ([_relatives objectAtIndex:i] == self) {
            prev = [_relatives objectAtIndex:i - 1];
            break;
        }
    }
    
    return prev;
}

- (id)getNextDataSource {
    id next = nil;
    
    for (int i = 0; i < [_relatives count] - 1; i++) {
        if ([_relatives objectAtIndex:i] == self) {
            next = [_relatives objectAtIndex:i + 1];
            break;
        }
    }
    
    return next;
}

@end
