//
//  BrushShapeLayer.m
//  ParVisX
//
//  Created by Robert Kosara on 9/10/09.
//  Copyright 2009 UNC Charlotte. All rights reserved.
//

#import "BrushShapeLayer.h"
#import <math.h>

@implementation BrushShapeLayer

- (id)init {
	if ((self = [super init])) {
		numPoints = 0;
		coords = malloc(4 * sizeof(int));
		self.backgroundColor = CGColorGetConstantColor(kCGColorClear);
	}
	return self;
}

- (void)setPointsAtY1:(int)y1 Y2:(int)y2 Y3:(int)y3 Y4:(int)y4 {
	numPoints = 4;
	coords[0] = y1;
	coords[1] = y2;
	coords[2] = y3;
	coords[3] = y4;
}

- (void)setPointsAtY1:(int)y1 Y2:(int)y2 Y3:(int)y3 {
	numPoints = 3;
	coords[0] = y1;
	coords[1] = y2;
	coords[2] = y3;
}

- (void)drawInContext:(CGContextRef)context {
	[super drawInContext:context];

	if (numPoints == 4) {
		CGContextMoveToPoint(context, 0, coords[0]);
		CGContextAddLineToPoint(context, 0, coords[1]);
		CGContextAddLineToPoint(context, self.frame.size.width, coords[2]);
		CGContextAddLineToPoint(context, self.frame.size.width, coords[3]);
	} else if (numPoints == 3) {
		CGContextMoveToPoint(context, 0, coords[0]);
		int topY = MAX(coords[1], coords[2]);
		int bottomY = MIN(coords[1], coords[2]);
		double startAngle = atan((double)(topY-coords[0])/(double)self.frame.size.width);
		double endAngle = atan((double)(bottomY-coords[0])/(double)self.frame.size.width);
		CGContextAddArc(context, 0, coords[0], self.frame.size.width*.9, startAngle, endAngle, 1);
		CGContextAddLineToPoint(context, 0, coords[0]);
	}

	CGContextSetRGBFillColor(context, 0, 0.251, 0.502, .5);
	CGContextFillPath(context);
}

@end
