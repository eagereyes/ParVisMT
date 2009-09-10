//
//  ParCoordsBackgroundLayer.m
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParCoordsBackgroundLayer.h"

const int HPADDING = 20;
const int VPADDING = 20;

@implementation ParCoordsBackgroundLayer

- (id)initWithDataSet:(DataSet *)d {
	if ((self = [super init])) {
		dataSet = d;
		self.backgroundColor = CGColorGetConstantColor(kCGColorWhite);
//		self.opaque = YES;
		[self setNeedsDisplay];
		[self setNeedsDisplayOnBoundsChange:YES];
		self.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	}
	return self;
}

- (void)drawInContext:(CGContextRef)ctx {
	[super drawInContext:ctx];
	
	int stepX = (self.frame.size.width-2*HPADDING)/([dataSet.dimensions count]-1);
	int x = HPADDING;
	for (int i = 0; i < [dataSet.dimensions count]; i++) {
		CGContextMoveToPoint(ctx, x, VPADDING);
		CGContextAddLineToPoint(ctx, x, self.frame.size.height-VPADDING);
		x += stepX;
	}
	
	CGContextSetGrayStrokeColor(ctx, 0.9, 1);
	CGContextDrawPath(ctx, kCGPathStroke);
	
	float height = self.frame.size.height-2*VPADDING;
	for (int i = 0; i < [dataSet numValues]; i++) {
		x = HPADDING;
		DataDimension *dim = [dataSet.dimensions objectAtIndex:0];
		CGContextMoveToPoint(ctx, x, VPADDING+(int)(height*(dim.values[i]-dim.min)/(dim.max-dim.min)));
		for (int j = 1; j < [dataSet.dimensions count]; j++) {
			x += stepX;
			dim = [dataSet.dimensions objectAtIndex:j];
			CGContextAddLineToPoint(ctx, x, VPADDING+(int)(height*(dim.values[i]-dim.min)/(dim.max-dim.min)));
		}
	}
	CGContextDrawPath(ctx, kCGPathStroke);
}

@end
