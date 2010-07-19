//
//  ParCoordsBrushLayer.h
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
	
	int movingAxisX;
}

- (id)initWithDataSet:(DataSet *)d;

- (void)setPointsAtX:(int)x width:(int)w Y1:(int)y1 Y2:(int)y2 Y3:(int)y3 Y4:(int)y4;

- (void)setPointsAtX:(int)x width:(int)w Y1:(int)y1 Y2:(int)y2 Y3:(int)y3;

- (void)setRearrangeAxisFrom:(int)fromX to:(int)newX;

- (void)clearBrushShape;

@end
