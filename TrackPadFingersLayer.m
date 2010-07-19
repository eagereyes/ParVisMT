//
//  TrackPadFingersLayer.m
//  ParVisMT
//
//  Created by Robert Kosara on 9/16/09.
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

#import "TrackPadFingersLayer.h"
#import "TouchInfo.h"
#import "TrackPadBgLayer.h"

@implementation TrackPadFingersLayer

- (id)initWithFrame:(CGRect)frame touchData:(NSDictionary *)touchData {
	if ((self = [super init])) {
		self.backgroundColor = CGColorGetConstantColor(kCGColorClear);
		self.frame = frame;
		self.needsDisplayOnBoundsChange = YES;
		touches = touchData;
	}
	return self;
}

- (void)drawInContext:(CGContextRef)context {
	CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.000, 0.251, 0.502, 0.500));
	for (TouchInfo *t in [touches allValues]) {
		CGContextAddEllipseInRect(context, CGRectMake(t.x*(self.frame.size.width-FRAMEWIDTH/2)-7, t.y*self.frame.size.height-7, 15, 15));
	}
	CGContextFillPath(context);
}

@end
