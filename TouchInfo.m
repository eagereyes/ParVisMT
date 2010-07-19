//
//  TouchInfo.m
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

#import "TouchInfo.h"


@implementation TouchInfo

@synthesize x;
@synthesize y;
@synthesize oldX;
@synthesize oldY;

- (id)initWithInitialX:(float)initialX Y:(float)initialY {
	if ((self = [super init])) {
		oldX = x = initialX;
		oldY = y = initialY;
	}
	return self;
}

- (NSComparisonResult)compareX:(TouchInfo *)other {
	if (x < other.x)
		return NSOrderedAscending;
	else if (x > other.x)
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

- (void)setX:(float)newX {
	oldX = x;
	x = newX;
}

- (void)setY:(float)newY {
	oldY = y;
	y = newY;
}

@end
