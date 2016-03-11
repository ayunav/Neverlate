//
//  NLProgressController.h
//  neverlate
//
//  Created by Ayuna Vogel on 11/26/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLProgressViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@end
