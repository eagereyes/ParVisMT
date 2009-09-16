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
	axisHighlight.backgroundColor = CGColorCreateGenericRGB(0.000, 0.251, 0.502, .7);
	[[self layer] addSublayer:axisHighlight];

	axisHighlight2 = [CALayer layer];
	axisHighlight2.hidden = YES;
	axisHighlight2.backgroundColor = CGColorCreateGenericRGB(0.000, 0.251, 0.502, .7);
	[[self layer] addSublayer:axisHighlight2];
	
	tpLayer = [[TrackPadLayer alloc] initWithFrame:CGRectMake(self.frame.size.width-410, 10, 410, 300) touchData:touchData numDimensions:[data.dimensions count]];
	[[self layer] addSublayer:tpLayer];
	tpLayer.hidden = YES;
	
	collectingEvents = NO;
		
	[NSCursor hide];
}

#pragma mark -

- (void)touchesBeganWithEvent:(NSEvent *)event {
	[self collectAndProcessTouches:NSTouchPhaseBegan inEvent:event];
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
	[self collectAndProcessTouches:NSTouchPhaseMoved inEvent:event];
}

- (void)collectAndProcessTouches:(NSTouchPhase)phase inEvent:(NSEvent *)event {
	NSSet *touches = [event touchesMatchingPhase:phase inView:self];
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

//	NSTouch *t = [touches anyObject];
//	NSLog(@"(%lf, %lf) pt = (%lf, %lf) in", t.deviceSize.width, t.deviceSize.height, t.deviceSize.width/72, t.deviceSize.height/72);
	
	if (collectingEvents == NO) {
		[self performSelector:@selector(handleTouches) withObject:nil afterDelay:0];
		collectingEvents = YES;
	}
}	

- (void)touchesEndedWithEvent:(NSEvent *)event {
	NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseEnded inView:self];
	for (NSTouch *t in touches) {
		[touchData removeObjectForKey:t.identity];
	}

	if (collectingEvents == NO) {
		[self performSelector:@selector(handleTouches) withObject:nil afterDelay:0];
		collectingEvents = YES;
	}
}

- (void)handleTouches {
	int highlightedAxis = -1;
	int highlightedAxis2 = -1;
	int y = 0;
	int height = [self frame].size.height-(TOPPADDING+BOTTOMPADDING);
	int y2 = 0;
	int height2 = height;
	int stepX = ([self frame].size.width-2*HPADDING)/([data.dimensions count]-1);
	NSArray *touches = [[touchData allValues] sortedArrayUsingSelector:@selector(compareX:)];
	[brushLayer clearBrushShape];
	switch([touchData count]) {
		case 1:
			{
				TouchInfo *t = [touches objectAtIndex:0];
				highlightedAxis = (int)(t.x*[data.dimensions count]);
			}
			break;

		case 2:
			{
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

		case 3:
			{
				TouchInfo *t1 = [touches objectAtIndex:0];
				TouchInfo *t2 = [touches objectAtIndex:1];
				TouchInfo *t3 = [touches objectAtIndex:2];
				if (activeAxis >= 0)
					highlightedAxis = activeAxis;
				else
					highlightedAxis = (int)(t1.x*[data.dimensions count]);
				highlightedAxis2 = highlightedAxis+1;
				[data angularBrushDimension:highlightedAxis dimension2:highlightedAxis+1 from:t1.y-MAX(t2.y, t3.y) to:t1.y-MIN(t2.y, t3.y)];
				[brushLayer setPointsAtX:HPADDING+highlightedAxis*stepX width:stepX Y1:BOTTOMPADDING+t1.y*height Y2:BOTTOMPADDING+t2.y*height Y3:BOTTOMPADDING+t3.y*height];
				[brushLayer setNeedsDisplay];
			}
			break;
			
		case 4:
			{
				TouchInfo *t1 = [touches objectAtIndex:0];
				TouchInfo *t2 = [touches objectAtIndex:1];
				TouchInfo *t3 = [touches objectAtIndex:2];
				TouchInfo *t4 = [touches objectAtIndex:3];
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
				if (highlightedAxis2 == highlightedAxis+1)
					[brushLayer setPointsAtX:HPADDING+highlightedAxis*stepX width:stepX Y1:BOTTOMPADDING+y Y2:BOTTOMPADDING+y+height Y3:BOTTOMPADDING+y2+height2 Y4:BOTTOMPADDING+y2];
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
		if ([touchData count] > 1) {
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithInt:0] forKey:kCATransactionAnimationDuration];
		}
				
		axisHighlight.frame = CGRectMake(HPADDING+highlightedAxis*stepX-1, BOTTOMPADDING+y, 3, height);

		if ([touchData count] >= 3) {
			axisHighlight2.frame = CGRectMake(HPADDING+highlightedAxis2*stepX-1, BOTTOMPADDING+y2, 3, height2);
			axisHighlight2.hidden = NO;
		} else {
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
	
	collectingEvents = NO;
	
	if (tpLayer.hidden == NO)
		[tpLayer setNeedsDisplay];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[NSCursor hide];
}

- (void)mouseDown:(NSEvent *)theEvent {
	[NSCursor hide];
}

#pragma mark -

- (BOOL)isOpaque {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
	if ([[theEvent characters] compare:@"o"] == NSOrderedSame)
		tpLayer.hidden = !tpLayer.hidden;
}

@end
