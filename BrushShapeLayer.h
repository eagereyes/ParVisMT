//
//  BrushShapeLayer.h
//  ParVisX
//
//  Created by Robert Kosara on 9/10/09.
//  Copyright 2009 UNC Charlotte. All rights reserved.
//

#import <QuartzCore/CALayer.h>

@interface BrushShapeLayer : CALayer {

	int numPoints;

	int *coords;
}

- (void)setPointsAtY1:(int)y1 Y2:(int)y2 Y3:(int)y3 Y4:(int)y4;

- (void)setPointsAtY1:(int)y1 Y2:(int)y2 Y3:(int)y3;


@end
