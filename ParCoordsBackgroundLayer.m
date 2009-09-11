//
//  ParCoordsBackgroundLayer.m
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParCoordsBackgroundLayer.h"

const int HPADDING = 20;
const int TOPPADDING = 20;
const int BOTTOMPADDING = 40;

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
}

@end
