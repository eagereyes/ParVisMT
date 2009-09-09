//
//  ParCoordsView.m
//  ParVisMT
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParCoordsView.h"


@implementation ParCoordsView

- (void)awakeFromNib {
	data = [[DataSet alloc] init];
	
	[[self layer] setBackgroundColor:CGColorGetConstantColor(kCGColorWhite)];
	
	background = [[ParCoordsBackgroundLayer alloc] initWithDataSet:data];
	background.frame = [self layer].frame;
	[[self layer] addSublayer:background];
}

#pragma mark -

- (BOOL)acceptsTouchEvents {
	return YES;
}

- (void)touchesBeganWithEvent:(NSEvent *)event {
	NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseBegan inView:self];
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
	NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseMoved inView:self];
	
}

- (void)touchesEndedWithEvent:(NSEvent *)event {
	NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseEnded inView:self];
	
}

#pragma mark -

- (BOOL)isOpaque {
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

@end
