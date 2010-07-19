//
//  TrackPadLayer.m
//  ParVisMT
//
//  Created by Robert Kosara on 9/12/09.
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

#import "TrackPadBgLayer.h"
#import "TouchInfo.h"

@implementation TrackPadBgLayer


- (id)initWithFrame:(CGRect)frame numDimensions:(int)numDims {
	if ((self = [super init])) {
		self.backgroundColor = CGColorGetConstantColor(kCGColorClear);
		self.frame = frame;
		self.needsDisplayOnBoundsChange = YES;
		[self setNeedsDisplay];
		[self setOpacity:0.95];
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
}

@end
