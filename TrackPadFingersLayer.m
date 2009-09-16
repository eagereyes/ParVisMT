//
//  TrackPadFingersLayer.m
//  ParVis X
//
//  Created by Robert Kosara on 9/16/09.
//  Copyright 2009 UNC Charlotte. All rights reserved.
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
