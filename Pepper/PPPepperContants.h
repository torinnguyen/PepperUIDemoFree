//
//  PPPepperContants.h
//
//  Created by Torin Nguyen on 7/6/12.
//  Copyright (c) 2012 torinnguyen@gmail.com. All rights reserved.
//

#ifndef PepperDemo_PPPepperContants_h
#define PepperDemo_PPPepperContants_h

//Graphics
#define EDGE_PADDING                 5                //Don't change this after graphic is fixed

//Look & feel
#define FRAME_ASPECT_RATIO           0.0f             //Heigth/Width - Change to non-zero for custom aspect ratio, default is (1.3333 or 4:3). Should be >= 1.0f
#define FRAME_SCALE_IPAD             0.4f
#define FRAME_SCALE_IPHONE           0.47f
#define FRAME_SCALE_PORTRAIT         0.9f             //scaleOnDeviceRotation property must be enabled for this to take effect

#define MIN_BOOK_SCALE               0.75f            //enableBookScale property must be enabled for this to take effect
#define MAX_BOOK_SCALE               0.90f            //Book cover can be smaller than the 3D/Pepper pages to have more dramatic transition animation
#define MAX_BOOK_ROTATE              20.0f            //degree. enableBookRotate property must be enabled for this to take effect

#endif
