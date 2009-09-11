//
//  ParCoordsBrushLayer.h
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "DataSet.h"
#import "DataDimension.h"

extern const int HPADDING;
extern const int TOPPADDING;
extern const int BOTTOMPADDING;

@interface ParCoordsBrushLayer : CALayer {

	DataSet *dataSet;

	int numPoints;
	
	int *coords;
	
	CGFloat leftX;
	
	CGFloat width;
}

- (id)initWithDataSet:(DataSet *)d;

- (void)setPointsAtX:(int)x width:(int)w Y1:(int)y1 Y2:(int)y2 Y3:(int)y3 Y4:(int)y4;

- (void)setPointsAtX:(int)x width:(int)w Y1:(int)y1 Y2:(int)y2 Y3:(int)y3;

- (void)clearBrushShape;

@end
