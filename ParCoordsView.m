//
//  ParCoordsView.m
//  ParVisMT
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParCoordsView.h"

const CGFloat highlightColor[] = {0, 0, .8, 1};

@implementation ParCoordsView

- (void)awakeFromNib {
	[self setAcceptsTouchEvents:YES];
	[self setWantsRestingTouches:YES];
	
	data = [[DataSet alloc] init];
	
	activeAxis = -1;
	previousCount = 0;
	
	touchData = [[NSMutableDictionary alloc] init];
	
	[[self layer] setBackgroundColor:CGColorGetConstantColor(kCGColorWhite)];
	
	background = [[ParCoordsBackgroundLayer alloc] initWithDataSet:data];
	background.frame = [self layer].frame;
	[[self layer] addSublayer:background];

	brushLayer = [[ParCoordsBrushLayer alloc] initWithDataSet:data];
	brushLayer.frame = [self layer].frame;
	[[self layer] addSublayer:brushLayer];
	
	axisHighlight = [CALayer layer];
	axisHighlight.hidden = YES;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	axisHighlight.backgroundColor = CGColorCreate(space, highlightColor);
	CGColorSpaceRelease(space);
	[[self layer] addSublayer:axisHighlight];
}

#pragma mark -

- (void)touchesBeganWithEvent:(NSEvent *)event {
	[self touchesMovedWithEvent:event];
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
	NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseMoved inView:self];
	for (NSTouch *t in touches) {
		TouchInfo *info = [touchData objectForKey:t.identity];
		if (info != nil) {
			info.x = t.normalizedPosition.x;
			info.y = t.normalizedPosition.y;
		} else {
			info = [[[TouchInfo alloc] initWithInitialX:t.normalizedPosition.x Y:t.normalizedPosition.y] autorelease];
			[touchData setObject:info forKey:t.identity];
		}
	}
	
	[self handleTouches];
}	

- (void)touchesEndedWithEvent:(NSEvent *)event {
	NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseEnded inView:self];
	for (NSTouch *t in touches) {
		[touchData removeObjectForKey:t.identity];
	}
	[self handleTouches];
}

- (void)handleTouches {
	int highlightedAxis = -1;
	int y = 0;
	int height = [self frame].size.height-2*VPADDING;
	switch([touchData count]) {
		case 1:
			{
				TouchInfo *t = [[touchData allValues] objectAtIndex:0];
				highlightedAxis = (int)(t.x*[data.dimensions count]);
			}
			break;

		case 2:
			{
				NSArray *touches = [touchData allValues];
				TouchInfo *t1 = [touches objectAtIndex:0];
				TouchInfo *t2 = [touches objectAtIndex:1];
				if (activeAxis >= 0)
					highlightedAxis = activeAxis;
				else
					highlightedAxis = (int)((t1.x+t2.x)/2*[data.dimensions count]);
				float minY = MIN(t1.y, t2.y);
				float maxY = MAX(t1.y, t2.y);
				y = (int)(minY*height);
				height = (int)(height*(maxY-minY));
				[data brushByDimension:highlightedAxis from:minY to:maxY];
				[brushLayer setNeedsDisplay];
			}
			break;

		default:
			break;
	}

	if (previousCount > 1 && [touchData count] < 2) {
		[data resetBrush];
		[brushLayer setNeedsDisplay];
	}
	
	if (highlightedAxis >= 0) {
		NSRect frame = [self frame];
		if ([touchData count] > 1) {
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithInt:0] forKey:kCATransactionAnimationDuration];
		}
		
		axisHighlight.frame = CGRectMake(HPADDING+highlightedAxis*(frame.size.width-2*HPADDING)/([data.dimensions count]-1)-1,
										 VPADDING+y-1, 3, height+2);
		if ([touchData count] > 1)
			[CATransaction commit];
		
		axisHighlight.hidden = NO;
	} else
		axisHighlight.hidden = YES;

	activeAxis = highlightedAxis;
	previousCount = [touchData count];
}


#pragma mark -

- (BOOL)isOpaque {
	return YES;
}


@end
