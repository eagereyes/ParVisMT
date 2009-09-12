//
//  TrackPadLayer.m
//  ParVisX
//
//  Created by Robert Kosara on 9/12/09.
//  Copyright 2009 UNC Charlotte. All rights reserved.
//

#import "TrackPadLayer.h"
#import "TouchInfo.h"


@implementation TrackPadLayer


- (id)initWithFrame:(CGRect)frame touchData:(NSDictionary *)touchData {
	if ((self = [super init])) {
		self.backgroundColor = CGColorGetConstantColor(kCGColorClear);
		self.frame = frame;
		self.needsDisplayOnBoundsChange = YES;
		[self setNeedsDisplay];
		touches = touchData;
	}
	return self;
}

// Based on Apple's QuartzShapes example, http://developer.apple.com/mac/library/samplecode/QuartzShapes/
- (void)drawInContext:(CGContextRef)context {
	CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.798, 0.807, 0.817, 1.000));
	
	float edgeRadius = 5;
	
    // Add a rounded rect to the path
    float fw, fh;
    
    // Calculate the width and height of the rectangle in the new coordinate system.
    fw = CGRectGetWidth(self.bounds) / edgeRadius;
    fh = CGRectGetHeight(self.bounds) / edgeRadius;
    
	CGMutablePathRef path = CGPathCreateMutable();
	
    // CGContextAddArcToPoint adds an arc of a circle to the context's path (creating the rounded
    // corners).  It also adds a line from the path's last point to the begining of the arc, making
    // the sides of the rectangle.
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
	
	CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.000, 0.251, 0.502, 0.500));
	for (TouchInfo *t in [touches allValues]) {
		CGContextAddEllipseInRect(context, CGRectMake(t.x*self.frame.size.width-7, t.y*self.frame.size.height-7, 15, 15));
	}
	CGContextFillPath(context);
}

@end
