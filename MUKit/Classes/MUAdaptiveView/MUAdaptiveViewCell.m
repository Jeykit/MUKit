//
//  MUAdaptiveViewCell.m
//  MUKit
//
//  Created by Jekity on 2017/12/20.
//

#import "MUAdaptiveViewCell.h"


@interface MUAdaptiveViewCell()

//@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UIControl *customView;
@property(nonatomic, strong)UIView *barView1;
@property(nonatomic, strong)UIView *barView2;
@end
@implementation MUAdaptiveViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc]initWithFrame:self.contentView.frame];
        [self.contentView addSubview:_imageView];
        
        _customView = [[UIControl alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame)-11., CGRectGetMinY(self.contentView.frame) - 11., 22., 22.)];
        [_customView addTarget:self action:@selector(closedButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_customView];
        _customView.layer.borderColor = [UIColor colorWithWhite:.4 alpha:1.].CGColor;
        _customView.layer.borderWidth = 2.;
        _customView.layer.cornerRadius = 11.;
        _customView.layer.masksToBounds = YES;
     
        
        _barView1 = [self configuredView:_barView1];
        _barView2 = [self configuredView:_barView2];
        [_customView addSubview:_barView1];
        [_customView addSubview:_barView2];
        
        [self updateLayout];
    }
    return self;
}
-(UIView *)configuredView:(UIView *)view{
    view = [UIView new];
    view.backgroundColor = [UIColor colorWithWhite:.4 alpha:1.];
    //    view.backgroundColor = self.tintColor;
    view.userInteractionEnabled = NO;
    view.layer.allowsEdgeAntialiasing = YES;
    return view;
}
-(void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

- (void)updateLayout
{
    float barWidth, barHeight = 1.5, barX, bar1Y, bar2Y;
  
    barWidth = _customView.frame.size.height * 2 / 5;
    barX = (_customView.frame.size.width - barWidth) / 2;
    bar1Y = (_customView.frame.size.height - barHeight) / 2;
    bar2Y = bar1Y;

     _barView1.transform = CGAffineTransformIdentity;
    _barView2.transform = CGAffineTransformIdentity;
    
    _barView1.frame = CGRectMake(barX, bar1Y, barWidth, barHeight);
    _barView2.frame = CGRectMake(barX, bar2Y, barWidth, barHeight);
    
    _barView1.transform = CGAffineTransformMakeRotation(M_PI_4);
    _barView2.transform = CGAffineTransformMakeRotation(-M_PI_4);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
        CGPoint newPoint = [self.contentView convertPoint:point toView:self.customView];
        if ([self.customView pointInside:newPoint withEvent:event]) {
            return self.customView;
        }
  return [super hitTest:point withEvent:event];
 }

-(void)setTintColorMu:(UIColor *)tintColorMu{
    _tintColorMu = tintColorMu;
    _customView.layer.borderColor = tintColorMu.CGColor;
    _barView1.backgroundColor     = tintColorMu;
    _barView2.backgroundColor     = tintColorMu;
}
-(void)setCornerRadiusMu:(CGFloat)cornerRadiusMu{
    _cornerRadiusMu = cornerRadiusMu;
    _imageView.layer.cornerRadius = cornerRadiusMu;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.shouldRasterize = YES;
}
-(void)setHideButton:(BOOL)hideButton{
    _hideButton = hideButton;
    _customView.hidden = hideButton;
    
}
-(void)closedButtonTaped:(UIControl *)control{
    NSIndexPath *indexPath;
    if (@available(iOS 11.0, *)) {
        UITableView *tableView = (UITableView *)self.superview;
        indexPath = [tableView indexPathForCell:(UITableViewCell*)self];
    }else{
        UITableView *tableView = (UITableView *)self.superview.superview;
        indexPath = [tableView indexPathForCell:(UITableViewCell*)self];
    }
    if (self.deleteButtonByClicled) {
        
        self.deleteButtonByClicled(indexPath.row);
    }
}
@end
