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

	brushShapeLayer = [[BrushShapeLayer alloc] init];
	brushShapeLayer.frame = CGRectMake(0, 0, ([self layer].frame.size.width-2*HPADDING)/([data.dimensions count]-1), [self layer].frame.size.height);
	[[self layer] addSublayer:brushShapeLayer];

	brushLayer = [[ParCoordsBrushLayer alloc] initWithDataSet:data];
	brushLayer.frame = [self layer].frame;
	[[self layer] addSublayer:brushLayer];
	
	axisHighlight = [CALayer layer];
	axisHighlight.hidden = YES;
	axisHighlight.backgroundColor = CGColorCreateGenericRGB(0.000, 0.251, 0.502, 1.000);
	[[self layer] addSublayer:axisHighlight];

	axisHighlight2 = [CALayer layer];
	axisHighlight2.hidden = YES;
	axisHighlight2.backgroundColor = CGColorCreateGenericRGB(0.000, 0.251, 0.502, 1.000);
	[[self layer] addSublayer:axisHighlight2];
		
	
	[NSCursor hide];
}

#pragma mark -

- (void)touchesBeganWithEvent:(NSEvent *)event {
	[self touchesMovedWithEvent:event];
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
	NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseMoved inView:self];
	for (NSTouch *t in touches) {
		float x = MIN(MAX(t.normalizedPosition.x*1.2-.1, 0), 1);
		float y = MIN(MAX(t.normalizedPosition.y*1.2-.1, 0), 1);
		TouchInfo *info = [touchData objectForKey:t.identity];
		if (info != nil) {
			info.x = x;
			info.y = y;
		} else {
			info = [[[TouchInfo alloc] initWithInitialX:x Y:y] autorelease];
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
	int highlightedAxis2 = -1;
	int y = 0;
	int height = [self frame].size.height-2*VPADDING;
	int y2 = 0;
	int height2 = height;
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

		case 4:
			{
				NSArray *touches = [[touchData allValues] sortedArrayUsingSelector:@selector(compareX:)];
				TouchInfo *t1 = [touches objectAtIndex:0];
				TouchInfo *t2 = [touches objectAtIndex:1];
				TouchInfo *t3 = [touches objectAtIndex:2];
				TouchInfo *t4 = [touches objectAtIndex:3];
				int axis1 = (int)((t1.x+t2.x)/2*[data.dimensions count]);
				if (activeAxis >= 0)
					highlightedAxis = activeAxis;
				else
					highlightedAxis = (int)((t1.x+t2.x)/2*[data.dimensions count]);
				float minY1 = MIN(t1.y, t2.y);
				float maxY1 = MAX(t1.y, t2.y);
				y = (int)(minY1*height);
				height = (int)(height*(maxY1-minY1));

				highlightedAxis2 = (int)((t3.x+t4.x)/2*[data.dimensions count]);
				if (highlightedAxis2 == highlightedAxis)
					highlightedAxis2 = highlightedAxis+1;
				float minY2 = MIN(t3.y, t4.y);
				float maxY2 = MAX(t3.y, t4.y);
				y2 = (int)(minY2*height2);
				height2 = (int)(height2*(maxY2-minY2));
				[data brushByDimension1:highlightedAxis dimension2:highlightedAxis2 from1:minY1 to1:maxY1 from2:minY2 to2:maxY2];
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

		if ([touchData count] == 4) {
			if (highlightedAxis2 == highlightedAxis+1) {
				[brushShapeLayer setPointsAtY1:VPADDING+y Y2:VPADDING+y+height Y3:VPADDING+y2+height2 Y4:VPADDING+y2];
				brushShapeLayer.frame = CGRectMake(HPADDING+highlightedAxis*(frame.size.width-2*HPADDING)/([data.dimensions count]-1),
												   0, brushShapeLayer.frame.size.width, brushShapeLayer.frame.size.height);
				[brushShapeLayer setNeedsDisplay];
				brushShapeLayer.hidden = NO;
			} else {
				brushShapeLayer.hidden = YES;
			}

			axisHighlight2.frame = CGRectMake(HPADDING+highlightedAxis2*(frame.size.width-2*HPADDING)/([data.dimensions count]-1)-1,
											  VPADDING+y2-1, 3, height2+2);
			axisHighlight2.hidden = NO;
		} else {
			brushShapeLayer.hidden = YES;
			axisHighlight2.hidden = YES;
		}

		if ([touchData count] > 1)
			[CATransaction commit];
		
		axisHighlight.hidden = NO;
	} else {
		axisHighlight.hidden = YES;
		axisHighlight2.hidden = YES;
	}

	activeAxis = highlightedAxis;
	previousCount = [touchData count];
}


#pragma mark -

- (BOOL)isOpaque {
	return YES;
}


@end
