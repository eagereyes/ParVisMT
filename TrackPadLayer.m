//
//  TrackPadLayer.m
//  ParVisX
//
//  Created by Robert Kosara on 9/12/09.
//  Copyright 2009 UNC Charlotte. All rights reserved.
//

#import "TrackPadLayer.h"
#import "TouchInfo.h"

#define FRAMEWIDTH 20

@implementation TrackPadLayer


- (id)initWithFrame:(CGRect)frame touchData:(NSDictionary *)touchData numDimensions:(int)numDims {
	if ((self = [super init])) {
		self.backgroundColor = CGColorGetConstantColor(kCGColorClear);
		self.frame = frame;
		self.needsDisplayOnBoundsChange = YES;
		[self setNeedsDisplay];
		[self setOpacity:0.95];
		touches = touchData;
		numDimensions = numDims;
	}
	return self;
}

// Based on Apple's QuartzShapes example, http://developer.apple.com/mac/library/samplecode/QuartzShapes/
- (void)drawInContext:(CGContextRef)context {

	// cover up text behind the lower right corner
	CGContextSetGrayFillColor(context, 1, 1);
	CGContextFillRect(context, CGRectMake(self.frame.size.width-FRAMEWIDTH, 0, FRAMEWIDTH, self.frame.size.height));
	
	float edgeRadius = 5;
	
    // Add a rounded rect to the path
    float fw, fh;
    
    // Calculate the width and height of the rectangle in the new coordinate system.
    fw = (CGRectGetWidth(self.bounds)-FRAMEWIDTH/2) / edgeRadius;
    fh = CGRectGetHeight(self.bounds) / edgeRadius;
    
	CGMutablePathRef path = CGPathCreateMutable();
	
    CGPathMoveToPoint(path, NULL, fw, fh/2);  // Start at lower right corner
    CGPathAddArcToPoint(path, NULL, fw, fh, fw/2, fh, 1);  // Top right corner
    CGPathAddArcToPoint(path, NULL, 0, fh, 0, fh/2, 1); // Top left corner
    CGPathAddArcToPoint(path, NULL, 0, 0, fw/2, 0, 1); // Lower left corner
    CGPathAddArcToPoint(path, NULL, fw, 0, fw, fh/2, 1); // Back to lower right
	CGPathCloseSubpath(path);
    
	//  Save the context's state so that the translate and scale can be undone with a call
    //  to CGContextRestoreGState.
    CGContextSaveGState(context);
    //  Translate the origin of the contex to the lower left corner of the rectangle.
    CGContextTranslateCTM(context, CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds));
    //Normalize the scale of the context so that the width and height of the arcs are 1.0
    CGContextScaleCTM(context, edgeRadius, edgeRadius);
    CGContextAddPath(context, path);
    // Fill the path
	CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.798, 0.807, 0.817, 1.000));
    CGContextFillPath(context);
    CGContextRestoreGState(context);

	CGPathRelease(path);

	int stepX = (self.frame.size.width-FRAMEWIDTH)/(numDimensions-1);
	for (int x = FRAMEWIDTH/4; x < self.frame.size.width; x += stepX) {
		CGContextMoveToPoint(context, x, FRAMEWIDTH/2);
		CGContextAddLineToPoint(context, x, self.frame.size.height-FRAMEWIDTH/2);
	}
	CGContextSetGrayStrokeColor(context, 0.5, 1);
	CGContextStrokePath(context);
	
	CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.000, 0.251, 0.502, 0.500));
	for (TouchInfo *t in [touches allValues]) {
		CGContextAddEllipseInRect(context, CGRectMake(t.x*(self.frame.size.width-FRAMEWIDTH/2)-7, t.y*self.frame.size.height-7, 15, 15));
	}
	CGContextFillPath(context);
}

@end
