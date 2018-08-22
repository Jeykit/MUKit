//
//  FlyImageLayerTableViewCell.m
//  Demo
//
//  Created by Ye Tong on 4/18/16.
//  Copyright © 2016 NorrisTong. All rights reserved.
//

#import "FlyImageLayerTableViewCell.h"
#import "UIImageView+MUImageCache.h"

@implementation FlyImageLayerTableViewCell

- (id)imageViewWithFrame:(CGRect)frame {
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.frame = frame;
	imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
	[self.contentView addSubview:imageView];
	
	return imageView;
}

- (void)renderImageView:(id)imageView url:(NSURL *)url {
    ((UIImageView *)imageView).imageURL = url.absoluteString;
}

@end
