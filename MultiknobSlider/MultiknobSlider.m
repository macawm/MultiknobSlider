//
//  MultiknobSlider.m
//  MultiknobSlider
//
//  Created by Anthony Magee on 8/30/12.
//  Copyright (c) 2012
//

#import "MultiknobSlider.h"
#import "MultiknobSliderCell.h"

@implementation MultiknobSlider

#pragma mark - Superclass Methods
+ (Class)cellClass {
    return [MultiknobSliderCell class];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [MultiknobSlider setCellClass:[MultiknobSliderCell class]];
        
        MultiknobSliderCell* cell = [[MultiknobSliderCell alloc] init];
        [cell setControlView:self];
        [cell setContinuous:YES];
        self.cell = cell;
        
        self.minValue = 0.;
        self.maxValue = 100.;
        self.incrementValue = 0.;
        self.defaultKnobSize = floor(frame.size.height * 0.6);
        self.alternateKnobSize = floor(0.8 * _defaultKnobSize);
        self.drawTickMarks = NO;
        self.numberOfTickMarks = 0;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"initWithCoder:");
    }
    return self;
}

- (void)awakeFromNib {
    // TODO: figure out what to do here
    [MultiknobSlider setCellClass:[MultiknobSliderCell class]];
}

- (void)drawRect:(NSRect)dirtyRect {    
    // draw ticks
    if (_drawTickMarks && _numberOfTickMarks > 0) {
        double tickSize = 6;
        NSRect tickRect = (NSRect) {0.5 * (_defaultKnobSize - tickSize), 0.5 * (NSHeight(self.bounds) - tickSize), tickSize, tickSize};
        double tickXOffset = (NSWidth(self.bounds) - _defaultKnobSize) / _numberOfTickMarks;
        
        NSGradient* dotGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:1 alpha:1] endingColor:[NSColor colorWithCalibratedWhite:.45 alpha:1]];
        NSBezierPath* circle;
        do {
            circle = [NSBezierPath bezierPathWithOvalInRect:tickRect];
            [dotGradient drawInBezierPath:circle relativeCenterPosition:(NSPoint){0,2}];//relativeCenterPosition:(NSPoint) {tickRect.origin.x + 0.5 * tickSize, 0.5 * NSHeight(self.bounds)}];
            
            tickRect.origin.x += tickXOffset;
        } while (NSMinX(tickRect) < NSWidth(self.bounds));
    }
    
    [self.cell drawWithFrame:self.bounds inView:self];
}

#pragma mark - Accessor overrides
// These are overridden to set the cell's values simultaneously or to provide checking for invalid values

- (void)setIncrementValue:(double)incrementValue {
    if (_incrementValue != incrementValue) {
        _incrementValue = incrementValue;
        if (incrementValue < 0.)
            _incrementValue = 0;
        [(MultiknobSliderCell*)self.cell setIncrementValue:_incrementValue];
    }
}

- (void)setMinValue:(double)minValue {
    if (_minValue != minValue) {
        _minValue = minValue;
        [(MultiknobSliderCell*)self.cell setMinValue:minValue];
    }
}

- (void)setMaxValue:(double)maxValue {
    if (_maxValue != maxValue) {
        _maxValue = maxValue;
        [(MultiknobSliderCell*)self.cell setMaxValue:maxValue];
    }
}

- (void)setDefaultKnobSize:(double)defaultKnobSize {
    if (_defaultKnobSize != defaultKnobSize) {
        _defaultKnobSize = defaultKnobSize;
        [(MultiknobSliderCell*)self.cell setDefaultKnobSize:defaultKnobSize];
    }
}

- (void)setAlternateKnobSize:(double)alternateKnobSize {
    if (_alternateKnobSize != alternateKnobSize) {
        _alternateKnobSize = alternateKnobSize;
        [(MultiknobSliderCell*)self.cell setAlternateKnobSize:alternateKnobSize];
    }
}

- (void)setDrawTickMarks:(BOOL)drawTickMarks {
    if (_drawTickMarks != drawTickMarks) {
        _drawTickMarks = drawTickMarks;
        [(MultiknobSliderCell*)self.cell setDrawTickMarks:drawTickMarks];
    }
}

- (void)setNumberOfTickMarks:(NSUInteger)numberOfTickMarks {
    if (_numberOfTickMarks != numberOfTickMarks) {
        _numberOfTickMarks = numberOfTickMarks;
        [(MultiknobSliderCell*)self.cell setNumberOfTickMarks:numberOfTickMarks];
    }
}

@end
