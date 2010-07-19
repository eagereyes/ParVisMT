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
#import "TrackPadBgLayer.h"
#import "TrackPadFingersLayer.h"

@interface ParCoordsView : NSView {

	DataSet *data;
	
	ParCoordsBackgroundLayer *background;
	
	ParCoordsBrushLayer *brushLayer;
	
	CALayer *axisHighlight;

	CALayer *axisHighlight2;
	
	TrackPadBgLayer *tpLayer;
	
	TrackPadFingersLayer *fingersLayer;

	int activeAxis;
	
	int movingAxis;
	
	int previousCount;

	BOOL collectingEvents;
	
	BOOL doubleTap;
	
	BOOL fullScreen;
	
	BOOL mouseVisible;
	
	// maps NSTouch IDs to TouchInfo objects
	NSMutableDictionary *touchData;
	
	IBOutlet NSWindow *mainWindow;
}

- (int)x2axis:(float)x;

- (void)collectAndProcessTouches:(NSTouchPhase)phase inEvent:(NSEvent *)event;

- (void)handleTouches;

- (void)exitFullScreenMode;


@end
