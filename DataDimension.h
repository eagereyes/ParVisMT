//
//  DataDimension.h
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DataDimension : NSObject {

	int numValues;
	
	float *values;
	
	float min, max;
	
	BOOL inverted;
	
	char *name;
}

@property (nonatomic, readonly) int numValues;

@property (nonatomic, readonly) float *values;

@property (nonatomic, readonly) float min;

@property (nonatomic, readonly) float max;

@property (nonatomic, assign) BOOL inverted;

@property (nonatomic, readonly) char *name;

- (id)initWithLabel:(char *)n;

- (void)addValue:(float)v;

- (void)normalize;

- (void)invert;

@end
