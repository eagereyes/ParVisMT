//
//  DataDimension.m
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

#import "DataDimension.h"
#import <math.h>

#define NUM_PREALLOC 500

@implementation DataDimension

@synthesize values;
@synthesize numValues;
@synthesize min;
@synthesize max;
@synthesize inverted;
@synthesize name;

- (id)initWithLabel:(char *)n {
	if ((self = [super init])) {
		numValues = 0;
		values = malloc(NUM_PREALLOC * sizeof(float));
		min = INFINITY;
		max = -INFINITY;
		inverted = NO;
		name = n;
	}
	return self;
}

- (void)addValue:(float)v {
	values[numValues++] = v;
	if (v < min)
		min = v;
	if (v > max)
		max = v;
}

- (void)normalize {
	for (int i = 0; i < numValues; i++)
		values[i] = (values[i]-min)/(max-min);
}

- (void)invert {
	inverted = !inverted;
	for (int i = 0; i < numValues; i++)
		values[i] = 1-values[i];
}

@end
