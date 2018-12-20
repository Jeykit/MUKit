//
//  FlyImageLayerTableViewCell.m
//  Demo
//
//  Created by Ye Tong on 4/18/16.
//  Copyright © 2016 NorrisTong. All rights reserved.
//

#import "FlyImageLayerTableViewCell.h"
#import "UIImageView+MUCache.h"

@implementation FlyImageLayerTableViewCell

- (id)imageViewWithFrame:(CGRect)frame {
//    int tag = rand()%10+1;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width - tag * 20,frame.size.height - tag * 20)];
      UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
	imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
	[self.contentView addSubview:imageView];
	
	return imageView;
}

- (void)renderImageView:(id)imageView url:(NSURL *)url {
    ((UIImageView *)imageView).imageURLString = url.absoluteString;
}

@end
