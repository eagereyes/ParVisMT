//
//  ParCoordsView.m
//  ParVisMT
//
//  Created by Robert Kosara on 9/9/09.
//
//  Copyright (c) 2009-2010, Robert Kosara
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ParCoordsView.h"

const CGFloat highlightColor[] = {0, 0, .8, 1};

const unsigned short kEscKeyCode = 53;

@implementation ParCoordsView

- (void)awakeFromNib {
	[self setAcceptsTouchEvents:YES];
	[self setWantsRestingTouches:YES];
    
	data = [[DataSet alloc] init];
	
	activeAxis = -1;
	previousCount = 0;
	doubleTap = NO;
	movingAxis = -1;
	
	fullScreen = NO;
	
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
	
	tpLayer = [[TrackPadBgLayer alloc] initWithFrame:CGRectMake(self.frame.size.width-410, 10, 410, 300) numDimensions:[data.dimensions count]];
	[[self layer] addSublayer:tpLayer];
	tpLayer.hidden = YES;

	fingersLayer = [[TrackPadFingersLayer alloc] initWithFrame:CGRectMake(self.frame.size.width-410, 10, 410, 300) touchData:touchData];
	[[self layer] addSublayer:fingersLayer];
	fingersLayer.hidden = YES;
	
	collectingEvents = NO;
	
	mouseVisible = NO;
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

	if ([touchData count] == 1) {
		if (doubleTap) {
			int axis = [self x2axis:((TouchInfo *)[[touchData allValues] objectAtIndex:0]).x];
			[((DataDimension *)[data.dimensions objectAtIndex:axis]) invert];
			[background setNeedsDisplay];
			[brushLayer setNeedsDisplay];
			doubleTap = NO;
		} else {
			doubleTap = YES;
			[self performSelector:@selector(doubleTapCheck) withObject:nil afterDelay:0.2];
		}
	} else if ([touchData count] == 3) {
		if (movingAxis >= 0) {
			DataDimension *dim = [data.dimensions objectAtIndex:movingAxis];
			[data.dimensions removeObjectAtIndex:movingAxis];
			int newAxis = [self x2axis:((TouchInfo *)[[touchData allValues] objectAtIndex:0]).x];
			[data.dimensions insertObject:dim atIndex:newAxis];
			[background setNeedsDisplay];
			[brushLayer setNeedsDisplay];
			axisHighlight.hidden = YES;
			movingAxis = -1;
		}
	}
	
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
				highlightedAxis = [self x2axis:t.x];
			}
			break;

		case 2:
			{
				TouchInfo *t1 = [touches objectAtIndex:0];
				TouchInfo *t2 = [touches objectAtIndex:1];
				if (activeAxis >= 0)
					highlightedAxis = activeAxis;
				else
					highlightedAxis = [self x2axis:(t1.x+t2.x)/2];
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
				int axis1 = [self x2axis:t1.x];
				int axis2 = [self x2axis:t2.x];
				int axis3 = [self x2axis:t3.x];
				if (movingAxis < 0) {
					if (axis1 == axis2 && axis2 == axis3) {
						movingAxis = axis1;
						[data resetBrush];
						[brushLayer setNeedsDisplay];
						axisHighlight.frame = CGRectMake(HPADDING+t1.x*([self frame].size.width-2*HPADDING), BOTTOMPADDING+y, 3, height);
						axisHighlight.hidden = NO;
					} else {
						if (activeAxis >= 0)
							highlightedAxis = activeAxis;
						else
							highlightedAxis = [self x2axis:t1.x];
						highlightedAxis2 = highlightedAxis+1;
						[data angularBrushDimension:highlightedAxis dimension2:highlightedAxis+1 from:t1.y-MAX(t2.y, t3.y) to:t1.y-MIN(t2.y, t3.y)];
						[brushLayer setPointsAtX:HPADDING+highlightedAxis*stepX width:stepX Y1:BOTTOMPADDING+t1.y*height Y2:BOTTOMPADDING+t2.y*height Y3:BOTTOMPADDING+t3.y*height];
						[brushLayer setNeedsDisplay];
					}
				} else {
					axisHighlight.frame = CGRectMake(HPADDING+t1.x*([self frame].size.width-2*HPADDING), BOTTOMPADDING+y, 3, height);
					axisHighlight.hidden = NO;
//					[brushLayer setRearrangeAxisFrom:HPADDING+movingAxis*stepX to:HPADDING+t1.x*([self frame].size.width-2*HPADDING)];
//					[brushLayer setNeedsDisplay];
				}
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
					highlightedAxis = [self x2axis:(t1.x+t2.x)/2];
				float minY1 = MIN(t1.y, t2.y);
				float maxY1 = MAX(t1.y, t2.y);
				y = (int)(minY1*height);
				height = (int)(height*(maxY1-minY1));

				highlightedAxis2 = [self x2axis:(t3.x+t4.x)/2 ];
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
	} else if (movingAxis < 0) {
		axisHighlight.hidden = YES;
		axisHighlight2.hidden = YES;
	}

	activeAxis = highlightedAxis;
	previousCount = [touchData count];
	
	collectingEvents = NO;
	
	if (fingersLayer.hidden == NO)
		[fingersLayer setNeedsDisplay];
}

- (int)x2axis:(float)x {
	return (int)(x*([data.dimensions count]-1)+.5);
}

- (void)doubleTapCheck {
	doubleTap = NO;
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
	if ([[theEvent characters] compare:@"o"] == NSOrderedSame) {
		tpLayer.hidden = !tpLayer.hidden;
		fingersLayer.hidden = !fingersLayer.hidden;
	} else if ([[theEvent characters] compare:@"f"] == NSOrderedSame) {
		if (!fullScreen) {
			[self enterFullScreenMode:[mainWindow screen] withOptions:nil];
			fullScreen = YES;
		} else
			[self exitFullScreenMode];
	} else if ([[theEvent characters] compare:@"m"] == NSOrderedSame) {
		if (mouseVisible)
			[NSCursor hide];
		else
			[NSCursor unhide];
		mouseVisible = !mouseVisible;
	} else if ([theEvent keyCode] == kEscKeyCode && fullScreen) {
		[self exitFullScreenMode];
	}
}

- (void)exitFullScreenMode {
	[self exitFullScreenModeWithOptions:nil];
	[mainWindow makeFirstResponder:self];
	fullScreen = NO;
}

@end
