//
//  AppDelegate.m
//  MultiknobSlider
//
//  Created by Anthony Magee on 8/30/12.
//  Copyright (c) 2012
//

#import "AppDelegate.h"
#import "KnobArray.h"
#import "MultiknobSlider.h"
#import "MultiknobSliderCell.h"
#import "MultiknobTableCellView.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _sliderArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    KnobArray* knobs1 = [[KnobArray alloc] init];
    [knobs1 setGrouped:YES];
    [knobs1 addKnobWithInitialValue:1.5 withTint:[NSColor redColor]];
    [knobs1 addKnobWithInitialValue:7.2 withTint:[NSColor greenColor]];
    
    KnobArray* knobs2 = [[KnobArray alloc] init];
    [knobs2 setGrouped:YES];
    [knobs2 addKnobWithInitialValue:4 withTint:[NSColor redColor]];
    [knobs2 addKnobWithInitialValue:8 withTint:[NSColor greenColor]];
    
    KnobArray* knobs3 = [[KnobArray alloc] init];
    [knobs3 setGrouped:YES];
    [knobs3 addKnobWithInitialValue:6 withTint:[NSColor redColor]];
    [knobs3 addKnobWithInitialValue:6.2 withTint:[NSColor greenColor]];
    
    NSArray* relatives = [NSArray arrayWithObjects:knobs1, knobs2, knobs3, nil];
    [knobs1 setRelatives:[relatives mutableCopy]];
    [knobs2 setRelatives:[relatives mutableCopy]];
    [knobs3 setRelatives:[relatives mutableCopy]];
    
    [_sliderArray addObject:knobs1];
    [_sliderArray addObject:knobs2];
    [_sliderArray addObject:knobs3];
    
    [_tableView reloadData];
}


#pragma mark - table view data source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 3;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    MultiknobTableCellView* cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    cellView.slider.incrementValue = 0.1;
    cellView.slider.minValue = 1;
    cellView.slider.maxValue = 9;
    cellView.slider.numberOfTickMarks = 8;
    cellView.slider.drawTickMarks = YES;
    cellView.slider.knobs = [_sliderArray objectAtIndex:row];
    if (cellView.slider.knobs)
        ((KnobArray*)cellView.slider.knobs).groupView = _tableView; //cellView;
    
    return cellView;
}

@end
