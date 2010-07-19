//
//  ParCoordsBackgroundLayer.m
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

#import "ParCoordsBackgroundLayer.h"

const int HPADDING = 20;
const int TOPPADDING = 45;
const int BOTTOMPADDING = 45;

@implementation ParCoordsBackgroundLayer

- (id)initWithDataSet:(DataSet *)d {
	if ((self = [super init])) {
		dataSet = d;
		self.backgroundColor = CGColorGetConstantColor(kCGColorWhite);
		self.opaque = YES;
		[self setNeedsDisplay];
		[self setNeedsDisplayOnBoundsChange:YES];
		self.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	}
	return self;
}

- (void)drawInContext:(CGContextRef)context {
	[super drawInContext:context];
	
	CGContextSetGrayFillColor(context, 1, 1);
	CGContextFillRect(context, self.bounds);
	
	int stepX = (self.frame.size.width-2*HPADDING)/([dataSet.dimensions count]-1);
	float height = self.frame.size.height-(BOTTOMPADDING+TOPPADDING);
	int x = HPADDING;
	for (int i = 0; i < [dataSet.dimensions count]; i++) {
		CGContextMoveToPoint(context, x, BOTTOMPADDING);
		CGContextAddLineToPoint(context, x, height+BOTTOMPADDING);
		x += stepX;
	}
	
	CGContextSetGrayStrokeColor(context, 0.9, 1);
	CGContextDrawPath(context, kCGPathStroke);
	
	for (int i = 0; i < [dataSet numValues]; i++) {
		x = HPADDING;
		DataDimension *dim = [dataSet.dimensions objectAtIndex:0];
		CGContextMoveToPoint(context, x, BOTTOMPADDING+(int)(height*dim.values[i]));
		for (int j = 1; j < [dataSet.dimensions count]; j++) {
			x += stepX;
			dim = [dataSet.dimensions objectAtIndex:j];
			CGContextAddLineToPoint(context, x, BOTTOMPADDING+(int)(height*dim.values[i]));
		}
	}
	CGContextSetGrayStrokeColor(context, 0.9, 1);
	CGContextDrawPath(context, kCGPathStroke);
	
	// axis labels
	CGContextSetGrayFillColor(context, 0, 1);
	CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
	x = HPADDING;
	for (DataDimension *dim in dataSet.dimensions) {
		[self centerText:dim.name atX:x atY:10 inContext:context];
		x += stepX;
	}
	
	// min and max
	CGContextSetGrayFillColor(context, 0.5, 1);
	CGContextSelectFont(context, "Helvetica", 14, kCGEncodingMacRoman);
	char buffer[10];
	x = HPADDING;
	for (DataDimension *dim in dataSet.dimensions) {
		float min = dim.inverted?dim.max:dim.min;
		if (min == roundf(min))
			sprintf(buffer, "%d", (int)min);
		else
			sprintf(buffer, "%.1f", min);
		[self centerText:buffer atX:x atY:30 inContext:context];
		float max = dim.inverted?dim.min:dim.max;
		if (max == roundf(max))
			sprintf(buffer, "%d", (int)max);
		else
			sprintf(buffer, "%.1f", max);
		[self centerText:buffer atX:x atY:self.frame.size.height-40 inContext:context];

		x += stepX;
	}
	
	// arrows
	CGContextSetGrayStrokeColor(context, 0, 1);
	CGContextSetGrayFillColor(context, 0, 1);
	x = HPADDING;
	for (DataDimension *dim in dataSet.dimensions) {
		CGContextMoveToPoint(context, x, self.frame.size.height-23);
		CGContextAddLineToPoint(context, x, self.frame.size.height-5);
		CGContextStrokePath(context);

		if (dim.inverted == NO) {
			CGContextMoveToPoint(context, x, self.frame.size.height-5);
			CGContextAddLineToPoint(context, x+5, self.frame.size.height-15);
			CGContextAddLineToPoint(context, x-5, self.frame.size.height-15);
			CGContextFillPath(context);
		} else {
			CGContextMoveToPoint(context, x, self.frame.size.height-23);
			CGContextAddLineToPoint(context, x+5, self.frame.size.height-13);
			CGContextAddLineToPoint(context, x-5, self.frame.size.height-13);
			CGContextFillPath(context);
		}
		x += stepX;
	}
}

- (void)centerText:(char *)text atX:(float)x atY:(float)y inContext:(CGContextRef)context {
	CGContextSetTextDrawingMode(context, kCGTextInvisible);
	CGContextShowTextAtPoint(context, x, y, text, strlen(text));
	CGPoint endPos = CGContextGetTextPosition(context);
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextShowTextAtPoint(context, x-(endPos.x-x)/2, y, text, strlen(text));
}


@end
