//
//  ParCoordsView.h
//  ParVisMT
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <AppKit/NSTouch.h>
#import "DataSet.h"
#import "ParCoordsBackgroundLayer.h"
#import "ParCoordsBrushLayer.h"
#import "TouchInfo.h"
#import "BrushShapeLayer.h"

@interface ParCoordsView : NSView {

	DataSet *data;
	
	ParCoordsBackgroundLayer *background;
	
	ParCoordsBrushLayer *brushLayer;
	
	BrushShapeLayer *brushShapeLayer;
	
	CALayer *axisHighlight;

	CALayer *axisHighlight2;

	int activeAxis;
	
	int previousCount;
	
	// maps NSTouch IDs to TouchInfo objects
	NSMutableDictionary *touchData;
	
}


- (void)handleTouches;

@end
