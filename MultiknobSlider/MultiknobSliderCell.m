//
//  MultiknobSliderCell.m
//  MultiknobSlider
//
//  Created by Anthony Magee on 8/30/12.
//  Copyright (c) 2012
//

#import "MultiknobSliderCell.h"
#import "MultiknobSlider.h"
#import "KnobArray.h"
#import "MultiknobTableView.h"

@interface MultiknobSliderCell ()
- (NSRect)rectForKnobAtValue:(double)value inFrame:(NSRect)cellFrame isActive:(BOOL)alt;
- (double)valueOfSliderAtPoint:(NSPoint)point inFrame:(NSRect)cellFrame;
@end

@implementation MultiknobSliderCell

- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)drawKnob:(NSRect)knobRect withTint:(NSColor*)tint isActive:(BOOL)active {
    if (active) {
        NSBezierPath* circle = [NSBezierPath bezierPathWithOvalInRect:knobRect];
        NSGradient* circleGradient = [[NSGradient alloc] initWithStartingColor:[tint highlightWithLevel:.8] endingColor:tint];
        [circleGradient drawInBezierPath:circle relativeCenterPosition:(NSPoint){0, 1}];
        
        [[tint highlightWithLevel:.4] setStroke];
        [circle stroke];
        
    } else {
        NSGradient* circleGradient = [[NSGradient alloc] initWithStartingColor:[tint shadowWithLevel:.4] endingColor:tint];
        [circleGradient drawInBezierPath:[NSBezierPath bezierPathWithOvalInRect:knobRect] relativeCenterPosition:(NSPoint){0, -1}];
    }
}

- (void)drawKnobShadow:(NSRect)knobRect isActive:(BOOL)active {
    if (active) {
        NSGradient* circleGradient = [[NSGradient alloc] initWithStartingColor:[[NSColor shadowColor] colorWithAlphaComponent:.8] endingColor:[[NSColor shadowColor] colorWithAlphaComponent:.1]];
        [circleGradient drawInBezierPath:[NSBezierPath bezierPathWithOvalInRect:NSOffsetRect(NSInsetRect(knobRect, -1, -1), 2, -1)] relativeCenterPosition:NSZeroPoint];
    
    } else {
        NSGradient* circleGradient = [[NSGradient alloc] initWithStartingColor:[[NSColor shadowColor] colorWithAlphaComponent:.9] endingColor:[[NSColor shadowColor] colorWithAlphaComponent:.2]];
        [circleGradient drawInBezierPath:[NSBezierPath bezierPathWithOvalInRect:NSOffsetRect(knobRect, 1, 0)] relativeCenterPosition:NSZeroPoint];
    }
}

- (void)drawConnectorFromPoint:(NSPoint)start toPoint:(NSPoint)end withTint:(NSColor*)tint isActive:(BOOL)active {
    [tint setStroke];
    NSBezierPath* path = [NSBezierPath bezierPath];
    if (active) {
        [path setLineWidth:6];
        
    } else {
        [path setLineWidth:4];
    }
    [path moveToPoint:start];
    [path lineToPoint:end];
    [path stroke];
    
    
    // draw highlights
    if (active) {
        [path setLineWidth:4];
        [[NSColor colorWithCalibratedWhite:1 alpha:.4] setStroke];
        
    } else {
        [path setLineWidth:2];
        [[NSColor colorWithCalibratedWhite:1 alpha:.3] setStroke];
    }
    [path stroke];
    
    if (active) {
        [[NSColor colorWithCalibratedWhite:1 alpha:.6] setStroke];
        [path setLineWidth:1.5];
        [path stroke];
    }
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    MultiknobSlider* slider = (MultiknobSlider*)controlView;
    KnobArray* knobArray = slider.knobs;
    KnobArray* prevKnobArray = [knobArray getPreviousDataSource];
    KnobArray* nextKnobArray = [knobArray getNextDataSource];
    
    if (knobArray) {
        if (! [knobArray conformsToProtocol:@protocol(MultiknobSliderDataSource)])
            [NSException raise:@"Delegate does not conform to protocol" format:@"Ensure that %@ conforms to MultiknobSliderDataSource", [knobArray class]];
        
        // first draw the inactive knobs
        NSRect knobRect;
        NSUInteger activeIndex = [knobArray activeKnobIndex];
        
        for (int knobIndex = 0; knobIndex < [knobArray numberOfKnobs]; knobIndex++) {
            if (knobIndex != activeIndex) {
                knobRect = [self rectForKnobAtValue:[knobArray valueOfKnobAtIndex:knobIndex] inFrame:cellFrame isActive:YES]; // yes is a lie here to get the full size, not the alternate size
                
                // draw circle shadow
                [self drawKnobShadow:knobRect isActive:NO];
                
                NSPoint currPoint = NSMakePoint(NSMidX(knobRect), NSMidY(knobRect));
                // draw prev line
                if (prevKnobArray) {
                    NSRect prevRect = [self rectForKnobAtValue:[prevKnobArray valueOfKnobAtIndex:knobIndex] inFrame:cellFrame isActive:YES]; // yes is a lie here to get the full size, not the alternate size
                    prevRect.origin.y += cellFrame.size.height;
                    NSPoint prevPoint = NSMakePoint(NSMidX(prevRect), NSMidY(prevRect));
                    
                    // draw line
                    [self drawConnectorFromPoint:prevPoint toPoint:currPoint withTint:[knobArray tintOfKnobAtIndex:knobIndex] isActive:NO];
                }
                
                // draw next line
                if (nextKnobArray) {
                    NSRect nextRect = [self rectForKnobAtValue:[nextKnobArray valueOfKnobAtIndex:knobIndex] inFrame:cellFrame isActive:YES]; // yes is a lie here to get the full size, not the alternate size
                    nextRect.origin.y -= cellFrame.size.height;
                    NSPoint nextPoint = NSMakePoint(NSMidX(nextRect), NSMidY(nextRect));
                    
                    // draw line
                    [self drawConnectorFromPoint:currPoint toPoint:nextPoint withTint:[knobArray tintOfKnobAtIndex:knobIndex] isActive:NO];
                }
                
                // draw circle
                [self drawKnob:knobRect withTint:[knobArray tintOfKnobAtIndex:knobIndex] isActive:NO];
            }
        }
        
        // now draw the active knob larger and more distinct
        knobRect = [self rectForKnobAtValue:[knobArray valueOfKnobAtIndex:activeIndex] inFrame:cellFrame isActive:NO];
        // draw circle shadow
        [self drawKnobShadow:knobRect isActive:YES];
        
        NSPoint currPoint = NSMakePoint(NSMidX(knobRect), NSMidY(knobRect));
        // draw prev line
        if (prevKnobArray) {
            NSRect prevRect = [self rectForKnobAtValue:[prevKnobArray valueOfKnobAtIndex:activeIndex] inFrame:cellFrame isActive:YES];
            prevRect.origin.y += cellFrame.size.height;
            NSPoint prevPoint = NSMakePoint(NSMidX(prevRect), NSMidY(prevRect));
            
            // draw line
            [self drawConnectorFromPoint:prevPoint toPoint:currPoint withTint:[knobArray tintOfKnobAtIndex:activeIndex] isActive:YES];
        }
        
        // draw next line
        if (nextKnobArray) {
            NSRect nextRect = [self rectForKnobAtValue:[nextKnobArray valueOfKnobAtIndex:activeIndex] inFrame:cellFrame isActive:YES];
            nextRect.origin.y -= cellFrame.size.height;
            NSPoint nextPoint = NSMakePoint(NSMidX(nextRect), NSMidY(nextRect));
            
            // draw line
            [self drawConnectorFromPoint:currPoint toPoint:nextPoint withTint:[knobArray tintOfKnobAtIndex:activeIndex] isActive:YES];
        }
        
        // draw circle
        [self drawKnob:knobRect withTint:[knobArray tintOfKnobAtIndex:activeIndex] isActive:YES];
    }
}

- (NSRect)rectForKnobAtValue:(double)value inFrame:(NSRect)cellFrame isActive:(BOOL)alt {
    double range = self.maxValue - self.minValue;
    NSRect rect;
    
    if (alt) {
        double knobOffset = 0.5 * (_defaultKnobSize - _alternateKnobSize);
        rect.origin.y = 0.5 * (cellFrame.size.height - _alternateKnobSize);
        rect.origin.x = (cellFrame.size.width - _defaultKnobSize - 2) * (value - _minValue) / range + 1;
        rect.origin.x += knobOffset;
        rect.size.width = rect.size.height = _alternateKnobSize;
        
    } else {
        rect.origin.y = 0.5 * (cellFrame.size.height - _defaultKnobSize);
        rect.origin.x = (cellFrame.size.width - _defaultKnobSize - 2) * (value - _minValue) / range + 1;
        // the -2 and +1 make the drawing of the stroke stay in the bounds
        
        rect.size.width = rect.size.height = _defaultKnobSize;
    }
    
    return rect;
}

+ (BOOL)prefersTrackingUntilMouseUp {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (NSSize)cellSize {
    // this sets the cell size to the exact size of the control, thus filling it completely (no insets)
    return self.controlView.bounds.size;
}

#pragma mark - Mouse Tracking
- (double)valueOfSliderAtPoint:(NSPoint)point inFrame:(NSRect)cellFrame {
    double percentVal = (point.x - 0.5 * _defaultKnobSize) / (cellFrame.size.width - _defaultKnobSize);
    double range = _maxValue - _minValue;
    double newVal = percentVal * range + _minValue;
    
    if (newVal < _minValue) newVal = _minValue;
    else if (newVal > _maxValue) newVal = _maxValue;
    
    return newVal;
}

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {
    //NSLog(@"start tracking");
    KnobArray* knobs = ((MultiknobSlider*)controlView).knobs;
    if (knobs) {
        if (! [knobs conformsToProtocol:@protocol(MultiknobSliderDataSource)])
            [NSException raise:@"Delegate does not conform to protocol" format:@"Ensure that %@ conforms to MultiknobSliderDataSource", [knobs class]];
        
        NSRect sliderFrame = controlView.frame;
        
        NSUInteger active = [knobs activeKnobIndex];
        NSRect rect = [self rectForKnobAtValue:[knobs valueOfKnobAtIndex:active] inFrame:sliderFrame isActive:NO];
        NSBezierPath* circle = [NSBezierPath bezierPathWithOvalInRect:rect];
        // check if clicked point is in "active" area
        if (! [circle containsPoint:startPoint]) {
            // if so then do nothing and just update the active knob
        
            // but if it is in the hit area of an inactive knob then change the active knob index
            NSUInteger newActiveKnobIndex = active;
            for (int i = 0; i < [knobs numberOfKnobs]; i++) {
                if (i != active) {
                    rect = [self rectForKnobAtValue:[knobs valueOfKnobAtIndex:i] inFrame:sliderFrame isActive:NO];
                
                    if ([[NSBezierPath bezierPathWithOvalInRect:rect] containsPoint:startPoint]) {
                        newActiveKnobIndex = i;
                        break; // get out of loop at first hit
                    }
                }
            }
            
            // change active knob if needed and if grouped update group properties
            if ([knobs activeKnobIndex] != newActiveKnobIndex) {
                [knobs setActiveKnobIndex:newActiveKnobIndex];
                if ([knobs isGrouped])
                    [knobs updateGroup];
                
                active = newActiveKnobIndex; // NB
            }
        }
        
        // update the point
        double newVal = [self valueOfSliderAtPoint:startPoint inFrame:sliderFrame];
        if (_incrementValue > 0) newVal = RoundToIncrement(newVal, _incrementValue);
        [knobs setValueOfKnobAtIndex:active toValue:newVal]; // make sure is active accurate
    }
        
    return [super startTrackingAt:startPoint inView:controlView];
}

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView {
    //NSLog(@"continue tracking");
    KnobArray* knobs = ((MultiknobSlider*)controlView).knobs;
    if (knobs) {
        if (! [knobs conformsToProtocol:@protocol(MultiknobSliderDataSource)])
            [NSException raise:@"Delegate does not conform to protocol" format:@"Ensure that %@ conforms to MultiknobSliderDataSource", [knobs class]];
        
        double newVal = [self valueOfSliderAtPoint:currentPoint inFrame:controlView.frame];
        if (_incrementValue > 0) newVal = RoundToIncrement(newVal, _incrementValue);
        [knobs setValueOfKnobAtIndex:[knobs activeKnobIndex] toValue:newVal];
    }
    
    return [super continueTracking:lastPoint at:currentPoint inView:controlView];
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
    //NSLog(@"stop tracking");
    KnobArray* knobs = ((MultiknobSlider*)controlView).knobs;
    if (knobs) {
        if (![knobs conformsToProtocol:@protocol(MultiknobSliderDataSource)])
            [NSException raise:@"Delegate does not conform to protocol" format:@"Ensure that %@ conforms to MultiknobSliderDataSource", [knobs class]];

        double newVal = [self valueOfSliderAtPoint:stopPoint inFrame:controlView.frame];
        if (_incrementValue > 0) newVal = RoundToIncrement(newVal, _incrementValue);
        [knobs setValueOfKnobAtIndex:[knobs activeKnobIndex] toValue:newVal];
    }
    
    return [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
}

@end
