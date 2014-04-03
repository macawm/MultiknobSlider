//
//  MultiknobSlider.h
//  MultiknobSlider
//
//  Created by Anthony Magee on 8/30/12.
//  Copyright (c) 2012
//

#import <Cocoa/Cocoa.h>

@interface MultiknobSlider : NSControl

@property (strong) id knobs;

@property (nonatomic) double maxValue;
@property (nonatomic) double minValue;
@property (nonatomic) double incrementValue;
@property (nonatomic) double defaultKnobSize;
@property (nonatomic) double alternateKnobSize;
@property (nonatomic) BOOL drawTickMarks;
@property (nonatomic) NSUInteger numberOfTickMarks;

@end


