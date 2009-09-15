//
//  ParCoordsBackgroundLayer.m
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParCoordsBackgroundLayer.h"

const int HPADDING = 20;
const int TOPPADDING = 45;
const int BOTTOMPADDING = 45;

char *labels[] = {"MPG", "Cylinders", "Horsepower", "Weight", "Acceleration", "Year"};

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
		CGContextMoveToPoint(context, x, BOTTOMPADDING+(int)(height*(dim.values[i]-dim.min)/(dim.max-dim.min)));
		for (int j = 1; j < [dataSet.dimensions count]; j++) {
			x += stepX;
			dim = [dataSet.dimensions objectAtIndex:j];
			CGContextAddLineToPoint(context, x, BOTTOMPADDING+(int)(height*(dim.values[i]-dim.min)/(dim.max-dim.min)));
		}
	}
	CGContextSetGrayStrokeColor(context, 0.9, 1);
	CGContextDrawPath(context, kCGPathStroke);
	
	// axis labels
	CGContextSetGrayFillColor(context, 0, 1);
	CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
	x = HPADDING;
	for (int i = 0; i < [dataSet.dimensions count]; i++) {
		[self centerText:labels[i] atX:x atY:10 inContext:context];
		x += stepX;
	}
	
	// min and max
	CGContextSetGrayFillColor(context, 0.5, 1);
	CGContextSelectFont(context, "Helvetica", 14, kCGEncodingMacRoman);
	char buffer[10];
	x = HPADDING;
	for (DataDimension *dim in dataSet.dimensions) {
		if (dim.min == roundf(dim.min))
			sprintf(buffer, "%d", (int)dim.min);
		else
			sprintf(buffer, "%.1f", dim.min);
		[self centerText:buffer atX:x atY:30 inContext:context];
		if (dim.max == roundf(dim.max))
			sprintf(buffer, "%d", (int)dim.max);
		else
			sprintf(buffer, "%.1f", dim.max);
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
		
		CGContextMoveToPoint(context, x, self.frame.size.height-5);
		CGContextAddLineToPoint(context, x+5, self.frame.size.height-15);
		CGContextAddLineToPoint(context, x-5, self.frame.size.height-15);
		CGContextFillPath(context);
		
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
