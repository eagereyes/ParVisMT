//
//  ParCoordsBackgroundLayer.h
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "DataSet.h"
#import "DataDimension.h"


@interface ParCoordsBackgroundLayer : CALayer {

	DataSet *dataSet;
	
}

- (id)initWithDataSet:(DataSet *)d;


@end
