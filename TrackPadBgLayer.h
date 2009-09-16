//
//  TrackPadLayer.h
//  ParVisX
//
//  Created by Robert Kosara on 9/12/09.
//  Copyright 2009 UNC Charlotte. All rights reserved.
//

#import <QuartzCore/CALayer.h>

#define FRAMEWIDTH 20


@interface TrackPadBgLayer : CALayer {

	int numDimensions;
	
}

- (id)initWithFrame:(CGRect)frame numDimensions:(int)numDims;

@end
