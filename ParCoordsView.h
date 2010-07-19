//
//  ParCoordsView.h
//  ParVisMT
//
//  Created by Robert Kosara on 9/9/09.
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
