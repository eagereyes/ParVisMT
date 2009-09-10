//
//  ParCoordsBrushLayer.m
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParCoordsBrushLayer.h"

@implementation ParCoordsBrushLayer

- (id)initWithDataSet:(DataSet *)d {
	if ((self = [super init])) {
		dataSet = d;
		self.backgroundColor = CGColorGetConstantColor(kCGColorClear);
		[self setNeedsDisplay];
		[self setNeedsDisplayOnBoundsChange:YES];
		self.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	}
	return self;
}

- (void)drawInContext:(CGContextRef)ctx {
	[super drawInContext:ctx];
	
	int stepX = (self.frame.size.width-2*HPADDING)/([dataSet.dimensions count]-1);
	
	
	float height = self.frame.size.height-2*VPADDING;
	for (int i = 0; i < [dataSet numValues]; i++) {
		if (dataSet.brushed[i]) {
			int x = HPADDING;
			DataDimension *dim = [dataSet.dimensions objectAtIndex:0];
			CGContextMoveToPoint(ctx, x, VPADDING+(int)(height*(dim.values[i]-dim.min)/(dim.max-dim.min)));
			for (int j = 1; j < [dataSet.dimensions count]; j++) {
				x += stepX;
				dim = [dataSet.dimensions objectAtIndex:j];
				CGContextAddLineToPoint(ctx, x, VPADDING+(int)(height*(dim.values[i]-dim.min)/(dim.max-dim.min)));
			}
		}
	}

	CGContextSetStrokeColor(ctx, CGColorGetComponents(CGColorGetConstantColor(kCGColorBlack)));
	CGContextDrawPath(ctx, kCGPathStroke);
}

@end
