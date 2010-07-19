//
//  DataSet.h
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


@interface DataSet : NSObject {

	NSMutableArray *dimensions;
	
	BOOL *brushed;
}

@property (nonatomic, readonly) NSMutableArray *dimensions;

@property (nonatomic, readonly) BOOL *brushed;

- (int)numValues;

- (void)brushByDimension:(int)axis from:(float)normalizedMin to:(float)normalizedMax;

- (void)brushByDimension1:(int)axis1 dimension2:(int)axis2 from1:(float)normalizedMin1 to1:(float)normalizedMax1 from2:(float)normalizedMin2 to2:(float)normalizedMax2;

- (void)angularBrushDimension:(int)axis1 dimension2:(int)axis2 from:(float)minDifference to:(float)maxDifference;

- (void)resetBrush;

@end
