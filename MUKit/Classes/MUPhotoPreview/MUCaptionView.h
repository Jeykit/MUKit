//
//  MUCaptionView.h
//  MUKit
//
//  Created by Jekity on 2018/8/30.
//

#import <UIKit/UIKit.h>

@interface MUCaptionView : UIToolbar

// To create your own custom caption view, subclass this view
// and override the following two methods (as well as any other
// UIView methods that you see fit):

// Override -setupCaption so setup your subviews and customise the appearance
// of your custom caption
// You can access the photo's data by accessing the _photo ivar
// If you need more data per photo then simply subclass MWPhoto and return your
// subclass to the photo browsers -photoBrowser:photoAtIndex: delegate method
- (void)setupCaption;

// Override -sizeThatFits: and return a CGSize specifying the height of your
// custom caption view. With width property is ignored and the caption is displayed
// the full width of the screen
- (CGSize)sizeThatFits:(CGSize)size withTitle:(NSString *)title;

@end
