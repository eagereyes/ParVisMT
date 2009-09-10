//
//  TouchInfo.m
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TouchInfo.h"


@implementation TouchInfo

@synthesize x;
@synthesize y;

- (id)initWithInitialX:(float)initialX Y:(float)initialY {
	if ((self = [super init])) {
		x = initialX;
		y = initialY;
	}
	return self;
}

@end
