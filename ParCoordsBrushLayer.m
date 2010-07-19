//
//  ParCoordsBrushLayer.m
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

#import "ParCoordsBrushLayer.h"

@implementation ParCoordsBrushLayer

- (id)initWithDataSet:(DataSet *)d {
	if ((self = [super init])) {
		dataSet = d;
		numPoints = 0;
		movingAxisX = -1;
		coords = malloc(4 * sizeof(int));
		self.backgroundColor = CGColorGetConstantColor(kCGColorClear);
		[self setNeedsDisplay];
		[self setNeedsDisplayOnBoundsChange:YES];
		self.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	}
	return self;
}

- (void)clearBrushShape {
	numPoints = 0;
	movingAxisX = -1;
}

- (void)setPointsAtX:(int)x width:(int)w Y1:(int)y1 Y2:(int)y2 Y3:(int)y3 Y4:(int)y4 {
	numPoints = 4;
	coords[0] = y1;
	coords[1] = y2;
	coords[2] = y3;
	coords[3] = y4;
	leftX = x;
	width = w;
}

- (void)setPointsAtX:(int)x width:(int)w Y1:(int)y1 Y2:(int)y2 Y3:(int)y3 {
	numPoints = 3;
	coords[0] = y1;
	coords[1] = y2;
	coords[2] = y3;
	leftX = x;
	width = w;
}

- (void)setRearrangeAxisFrom:(int)fromX to:(int)newX {
	numPoints = 3;
	movingAxisX = fromX;
	leftX = newX;
}

- (void)drawInContext:(CGContextRef)context {
	[super drawInContext:context];

	float height = self.frame.size.height-(TOPPADDING+BOTTOMPADDING);

	if (numPoints == 4) {
		CGContextMoveToPoint(context, leftX, coords[0]);
		CGContextAddLineToPoint(context, leftX, coords[1]);
		CGContextAddLineToPoint(context, leftX+width, coords[2]);
		CGContextAddLineToPoint(context, leftX+width, coords[3]);
	} else if (numPoints == 3) {
		if (movingAxisX < 0) {
			int topY = MAX(coords[1], coords[2]);
			int bottomY = MIN(coords[1], coords[2]);
			double startAngle = atan((double)(topY-coords[0])/width);
			double endAngle = atan((double)(bottomY-coords[0])/width);
			CGContextMoveToPoint(context, leftX+width*.1, BOTTOMPADDING+height/2);
			CGContextAddArc(context, leftX+width*.1, BOTTOMPADDING+height/2, width*.8, startAngle, endAngle, 1);
			CGContextAddLineToPoint(context, leftX+width*.1, BOTTOMPADDING+height/2);
		} else {
			CGContextMoveToPoint(context, movingAxisX, BOTTOMPADDING+height/2);
			CGContextAddLineToPoint(context, leftX, BOTTOMPADDING+height/2);
		}
	}
	
	CGContextSetRGBFillColor(context, 0, 0.251, 0.502, .5);
	CGContextFillPath(context);
	
	int stepX = (self.frame.size.width-2*HPADDING)/([dataSet.dimensions count]-1);

	CGMutablePathRef path = CGPathCreateMutable();
	for (int i = 0; i < [dataSet numValues]; i++) {
		if (dataSet.brushed[i]) {
			int x = HPADDING;
			DataDimension *dim = [dataSet.dimensions objectAtIndex:0];
			CGPathMoveToPoint(path, NULL, x, BOTTOMPADDING+(int)(height*dim.values[i]));
			for (int j = 1; j < [dataSet.dimensions count]; j++) {
				x += stepX;
				dim = [dataSet.dimensions objectAtIndex:j];
				CGPathAddLineToPoint(path, NULL, x, BOTTOMPADDING+(int)(height*dim.values[i]));
			}
		}
	}

	CGContextSetGrayStrokeColor(context, 0, 1);
	CGContextAddPath(context, path);
	CGPathRelease(path);
	CGContextStrokePath(context);
}

@end
