//
//  UIView+MUNormal.m
//  Pods
//
//  Created by Jekity on 2017/10/17.
//
//

#import "UIView+MUNormal.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

#pragma mark - 被添加的圆角覆盖物标识
@implementation UIView (MUNormal)
+(instancetype)viewForXibMuWithRetainObject:(id)view{
    
    UIView *superView = [self viewForXibMu];
    NSString *name = [superView nameWithInstance:superView superView:view];
    if (name.length > 0) {
        [view setValue:superView forKey:name];
    }
    return superView;
}
+(instancetype)viewForXibNOMargainMuWithRetainObject:(id)view{
    
    UIView *superView = [self viewForXibNOMargaimMu];
    NSString *name = [superView nameWithInstance:superView superView:view];
    if (name.length > 0) {
        [view setValue:superView forKey:name];
    }
    return superView;
}
-(NSString *)nameWithInstance:(UIView *)instance superView:(id)superView{
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([superView class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        
        if ([stringType containsString:NSStringFromClass([instance class])]) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
    
}
+(instancetype)viewForXibNOMargaimMu{
    
    UIView * view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    //    tempView.translatesAutoresizingMaskIntoConstraints = NO;
    view.autoresizingMask = UIViewAutoresizingNone;
    //    view.autoresizingMask = NO;
    CGFloat maxY  = 0;
    UIView *tempSubView = nil;
    for (UIView *subView in view.subviews) {
        CGRect temprect2             =  [subView convertRect:subView.bounds toView:view];
        CGFloat tempY               = CGRectGetMaxY(temprect2);
        if (tempY > maxY) {
            maxY = tempY;
            tempSubView = subView;
        }
    }
    NSLayoutConstraint *bottomFenceConstraint = nil;
    NSLayoutConstraint *widthFenceConstraint = nil;
    if (tempSubView) {
        
        widthFenceConstraint.priority = UILayoutPriorityRequired ;
        widthFenceConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width];
        [view addConstraint:widthFenceConstraint];
        
        bottomFenceConstraint.priority = UILayoutPriorityRequired - 1;
        bottomFenceConstraint = [NSLayoutConstraint constraintWithItem:tempSubView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [view addConstraint:bottomFenceConstraint];
    }
    
    CGSize size = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [view removeConstraint:bottomFenceConstraint];
    [view removeConstraint:widthFenceConstraint];
    
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height);
    return view;
}
+(instancetype)viewForXibMu{
    
    UIView * view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    //    tempView.translatesAutoresizingMaskIntoConstraints = NO;
    view.autoresizingMask = NO;
    CGFloat maxY  = 0;
    UIView *tempSubView = nil;
    for (UIView *subView in view.subviews) {
        CGRect temprect2             =  [subView convertRect:subView.bounds toView:view];
        CGFloat tempY               = CGRectGetMaxY(temprect2);
        if (tempY > maxY) {
            maxY = tempY;
            tempSubView = subView;
        }
    }
    NSLayoutConstraint *bottomFenceConstraint = nil;
    NSLayoutConstraint *widthFenceConstraint = nil;
    if (tempSubView) {
        
        widthFenceConstraint.priority = UILayoutPriorityRequired ;
        widthFenceConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width];
        [view addConstraint:widthFenceConstraint];
        
        bottomFenceConstraint.priority = UILayoutPriorityRequired - 1;
        bottomFenceConstraint = [NSLayoutConstraint constraintWithItem:tempSubView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [view addConstraint:bottomFenceConstraint];
    }
    
    CGSize size = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [view removeConstraint:bottomFenceConstraint];
    [view removeConstraint:widthFenceConstraint];
    
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height + 12.);
    return view;
}
+(instancetype)viewForXibMuWithIndex:(NSUInteger)index{
    UIView *tempView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][index];
    //    tempView.translatesAutoresizingMaskIntoConstraints = NO;
    tempView.autoresizingMask = NO;
    CGFloat maxY  = 0;
    UIView *tempSubView = nil;
    for (UIView *subView in tempView.subviews) {
        CGRect temprect2             =  [subView convertRect:subView.bounds toView:tempView];
        CGFloat tempY               = CGRectGetMaxY(temprect2);
        if (tempY > maxY) {
            maxY = tempY;
            tempSubView = subView;
        }
    }
    NSLayoutConstraint *bottomFenceConstraint = nil;
    NSLayoutConstraint *widthFenceConstraint = nil;
    if (tempSubView) {
        
        widthFenceConstraint.priority = UILayoutPriorityRequired ;
        widthFenceConstraint = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width];
        [tempView addConstraint:widthFenceConstraint];
        
        bottomFenceConstraint.priority = UILayoutPriorityRequired - 1;
        bottomFenceConstraint = [NSLayoutConstraint constraintWithItem:tempSubView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [tempView addConstraint:bottomFenceConstraint];
    }
    
    CGSize size = [tempView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [tempView removeConstraint:bottomFenceConstraint];
    [tempView removeConstraint:widthFenceConstraint];
    
    tempView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height + 12.);
    return tempView;
}
-(void)refreshViewLayout{
    [self updateConstraints];
    UIView *tempView = self;
    //    tempView.translatesAutoresizingMaskIntoConstraints = NO;
    tempView.autoresizingMask = NO;
    CGFloat maxY  = 0;
    UIView *tempSubView = nil;
    for (UIView *subView in tempView.subviews) {
        CGRect temprect2             =  [subView convertRect:subView.bounds toView:tempView];
        CGFloat tempY               = CGRectGetMaxY(temprect2);
        if (tempY > maxY) {
            maxY = tempY;
            tempSubView = subView;
        }
    }
    NSLayoutConstraint *bottomFenceConstraint = nil;
    NSLayoutConstraint *widthFenceConstraint = nil;
    if (tempSubView) {
        
        widthFenceConstraint.priority = UILayoutPriorityRequired;
        widthFenceConstraint = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width];
        [tempView addConstraint:widthFenceConstraint];
        
        bottomFenceConstraint.priority = UILayoutPriorityRequired - 1;
        bottomFenceConstraint = [NSLayoutConstraint constraintWithItem:tempSubView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [tempView addConstraint:bottomFenceConstraint];
    }
    
    CGSize size = [tempView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [tempView removeConstraint:bottomFenceConstraint];
    [tempView removeConstraint:widthFenceConstraint];
    
    tempView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height+12.);
}
-(void)refreshViewLayoutWith:(UITableView *)tableview{
    
    [self refreshViewLayout];
    [tableview reloadData];
}

#pragma mark -x
-(void)setX_Mu:(CGFloat)x_Mu{
    CGRect frame = self.frame;
    frame.origin.x = x_Mu;
    self.frame = frame;
}
-(CGFloat)x_Mu{
    return self.frame.origin.x;
}

#pragma mark -y
-(void)setY_Mu:(CGFloat)y_Mu{
    CGRect frame = self.frame;
    frame.origin.y = y_Mu;
    self.frame = frame;
}
-(CGFloat)y_Mu{
    return self.frame.origin.y;
}
#pragma mark -size
-(void)setSize_Mu:(CGSize)size_Mu{
    CGRect frame = self.frame;
    frame.size = size_Mu;
    self.frame = frame;
}
-(CGSize)size_Mu{
    return self.frame.size;
}
#pragma mark -origin
-(void)setOrigin_Mu:(CGPoint)origin_Mu{
    CGRect frame = self.frame;
    frame.origin = origin_Mu;
    self.frame = frame;
}
-(CGPoint)origin_Mu{
    return self.frame.origin;
}

#pragma mark -minX
-(CGFloat)minX_Mu{
    
    return CGRectGetMinX(self.frame);
}
#pragma mark -minY

-(CGFloat)minY_Mu{
    return CGRectGetMinY(self.frame);
}

#pragma mark-maxX
-(CGFloat)maxX_Mu{
    return CGRectGetMaxX(self.frame);
}

#pragma mark-maxY
-(CGFloat)maxY_Mu{
    return CGRectGetMaxY(self.frame);
}

#pragma mark -midX
-(CGFloat)midX_Mu{
    return CGRectGetMidX(self.frame);
}
#pragma mark -midY
-(CGFloat)midY_Mu{
    return CGRectGetMidY(self.frame);
}
#pragma mark -centerX
-(void)setCenterX_Mu:(CGFloat)centerX_Mu{
    CGPoint center = self.center;
    center.x = centerX_Mu;
    self.center = center;
}
-(CGFloat)centerX_Mu{
    return self.center.x;
}
#pragma mark -centerY
-(void)setCenterY_Mu:(CGFloat)centerY_Mu{
    CGPoint center = self.center;
    center.y = centerY_Mu;
    self.center = center;
}
-(CGFloat)centerY_Mu{
    return self.center.y;
}

#pragma maek - width
-(void)setWidth_Mu:(CGFloat)width_Mu{
    CGRect frame = self.frame;
    frame.size.width = width_Mu;
    self.frame = frame;
}
-(CGFloat)width_Mu{
    return CGRectGetWidth(self.frame);
}

#pragma maek - height
-(void)setHeight_Mu:(CGFloat)height_Mu{
    CGRect frame = self.frame;
    frame.size.height = height_Mu;
    self.frame = frame;
}
-(CGFloat)height_Mu{
    return CGRectGetHeight(self.frame);
}

#pragma mark -cornerRadius
-(void)setCornerRadius_Mu:(CGFloat)cornerRadius_Mu{
    //    CGFloat previou = self.cornerRadius_Mu;
    CGFloat previou = self.cornerRadius_Mu;
    if (cornerRadius_Mu != previou) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.cornerRadius = cornerRadius_Mu;
        self.layer.masksToBounds = YES;
    }
    objc_setAssociatedObject(self, @selector(cornerRadius_Mu), @(cornerRadius_Mu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CGFloat)cornerRadius_Mu{
    return [objc_getAssociatedObject(self, @selector(cornerRadius_Mu)) floatValue];
}
-(void)setMUCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    self.cornerRadius_Mu = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
}

-(void)setMUBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
}

@end
#pragma mark -Button
@interface UILabel (MUNormals)
@property (nonatomic,copy) void (^TapBlock)(void);
@property (nonatomic,copy) void (^TapArrayBlock)(NSString * string);
@property (nonatomic,strong) NSMutableDictionary *textMapDictionary;
@end
@implementation UILabel (MUNormal)
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self isKindOfClass:[UILabel class]]) {
        
        if (self.textMapDictionary || [self.textMapDictionary allKeys].count != 0) {
            if ([self yb_getTapFrameWithTouchPoint:point result:nil]) {
                return self;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}
-(void)setTapBlock:(void (^)(void))TapBlock{
    objc_setAssociatedObject(self, @selector(TapBlock), TapBlock, OBJC_ASSOCIATION_COPY);
}
-(void (^)(void))TapBlock{
    id object = objc_getAssociatedObject(self, @selector(TapBlock));
    return object?:nil;
}
-(void)setTextMapDictionary:(NSMutableDictionary *)textMapDictionary{
    objc_setAssociatedObject(self, @selector(textMapDictionary), textMapDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setTapArrayBlock:(void (^)(NSString *))TapArrayBlock{
     objc_setAssociatedObject(self, @selector(TapArrayBlock), TapArrayBlock, OBJC_ASSOCIATION_COPY);
}
-(void (^)(NSString *))TapArrayBlock{
    id object = objc_getAssociatedObject(self, @selector(TapArrayBlock));
    return object?:nil;
}
-(NSMutableDictionary *)textMapDictionary{
    id object = objc_getAssociatedObject(self, @selector(textMapDictionary));
    return object?:nil;
}
-(void)addTapWithString:(NSString *)string attributes:(NSDictionary *)attributes tapBlock:(void (^)(void))tap{
    //创建富文本，并且将超链接文本设置为蓝色+下划线
    if (self.text.length>0) {
        if (self.numberOfLines != 1) {//多行显示
            self.font = [UIFont systemFontOfSize:12.];//字号大于或小于这个点击就会有偏差
        }
        NSRange range = [self.text rangeOfString:string];
        if (range.location != NSNotFound) {
            self.userInteractionEnabled = YES;
            if (!self.textMapDictionary||!self.textMapDictionary[NSStringFromRange(range)]) {
                UITapGestureRecognizer *taped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mu_Text_Taped:)];
                [self addGestureRecognizer:taped];
            }
            NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:self.text];
            [content addAttributes:attributes range:range];
            self.attributedText = content;
            self.TapBlock = tap;
            if (!self.textMapDictionary) {
                self.textMapDictionary = [NSMutableDictionary dictionary];
            }
            self.textMapDictionary[NSStringFromRange(range)] = string;
        }
    }
    
}
-(void)addTapWithArray:(NSArray<__kindof NSString *> *)array attributes:(NSDictionary *)attributes tapBlock:(void (^)(NSString *))tap{
    //创建富文本，并且将超链接文本设置为蓝色+下划线
    if (self.text.length>0) {
        if (self.numberOfLines != 1) {//多行显示
            self.font = [UIFont systemFontOfSize:12.];//字号大于或小于这个点击就会有偏差
        }
        
        for (NSString *str in array) {
            
            NSRange range = [self.text rangeOfString:str];
            if (range.location != NSNotFound) {
                self.userInteractionEnabled = YES;
                if (!self.textMapDictionary||!self.textMapDictionary[NSStringFromRange(range)]) {
                    UITapGestureRecognizer *taped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mu_TextArray_Taped:)];
                    [self addGestureRecognizer:taped];
                }
                NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:self.text];
                [content addAttributes:attributes range:range];
                self.attributedText = content;
                self.textMapDictionary[NSStringFromRange(range)] = str;
        }
            self.TapArrayBlock  = tap;
            if (!self.textMapDictionary) {
                self.textMapDictionary = [NSMutableDictionary dictionary];
            }
           
        }
    }
}

-(void)mu_TextArray_Taped:(UITapGestureRecognizer *)gesture{
    if (self.textMapDictionary || [self.textMapDictionary allKeys].count != 0) {
        CGPoint point = [gesture locationInView:self];
        [self yb_getTapFrameWithTouchPoint:point result:self.TapArrayBlock];
//        if ([self yb_getTapFrameWithTouchPoint:point result:self.TapArrayBlock]) {
//        }
    }
}

-(void)mu_Text_Taped:(UITapGestureRecognizer *)gesture{
    if (self.textMapDictionary || [self.textMapDictionary allKeys].count != 0) {
        CGPoint point = [gesture locationInView:self];
        if ([self yb_getTapFrameWithTouchPoint:point result:nil]) {
            if (self.TapBlock) {
                self.TapBlock();
            }
        }
    }
}


#pragma mark - getTapFrame
- (BOOL)yb_getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *clickedString))resultBlock
{
    
    [self sizeToFit];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        
        UIFont *font = [UIFont systemFontOfSize:12];
        
        CGPathRelease(Path);
        
        Path = CGPathCreateMutable();
        
        CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self yb_transformForCoreText];
    
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self yb_getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        
        CGFloat lineSpace;
        
        if (style) {
            lineSpace = style.lineSpacing;
        }else {
            lineSpace = 0;
        }
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            for (NSString *str in [self.textMapDictionary allKeys]) {
                
                NSRange range = NSRangeFromString(str);
                if (NSLocationInRange(index, range)) {
                    
                    if (resultBlock) {
                        resultBlock(str);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}
- (CGAffineTransform)yb_transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)yb_getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent) + leading;
    
    return CGRectMake(point.x, point.y , width, height);
}
@end

#pragma mark -Button
@implementation UIButton (MUNormal)

//标题颜色
-(void)setTitleColorMu:(UIColor *)titleColorMu{
    [self setTitleColor:titleColorMu forState:UIControlStateNormal];
    objc_setAssociatedObject(self, @selector(titleColorMu), titleColorMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)titleColorMu{
    return objc_getAssociatedObject(self, @selector(titleColorMu));
}
//标题
-(void)setTitleStringMu:(NSString *)titleStringMu{
    [self setTitle:titleStringMu forState:UIControlStateNormal];
    objc_setAssociatedObject(self, @selector(titleStringMu), titleStringMu, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)titleStringMu{
    return objc_getAssociatedObject(self, @selector(titleStringMu));
}
//图片
-(void)setContentImageMu:(UIImage *)contentImageMu{
    
    [self setImage:contentImageMu forState:UIControlStateNormal];
    objc_setAssociatedObject(self, @selector(contentImageMu), contentImageMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImage *)contentImageMu{
    return objc_getAssociatedObject(self, @selector(contentImageMu));
}
//背景图片
-(void)setBackgroundImageMu:(UIImage *)backgroundImageMu{
    [self setBackgroundImage:backgroundImageMu forState:UIControlStateNormal];
    objc_setAssociatedObject(self, @selector(backgroundImageMu), backgroundImageMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImage *)backgroundImageMu{
    return objc_getAssociatedObject(self, @selector(backgroundImageMu));
}
//字体大小
-(void)setFontSizeMu:(CGFloat)fontSizeMu{
    self.titleLabel.font = [UIFont systemFontOfSize:fontSizeMu];
    objc_setAssociatedObject(self, @selector(fontSizeMu), @(fontSizeMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CGFloat)fontSizeMu{
    return [objc_getAssociatedObject(self, @selector(fontSizeMu)) floatValue];
}
//设置高亮标题颜色
-(void)setHighlightedTitleColorMu:(UIColor *)highlightedTitleColorMu{
    [self setTitleColor:highlightedTitleColorMu forState:UIControlStateHighlighted];
    objc_setAssociatedObject(self, @selector(highlightedTitleColorMu), highlightedTitleColorMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)highlightedTitleColorMu{
    return objc_getAssociatedObject(self, @selector(highlightedTitleColorMu));
}

//设置高亮标题
-(void)setHighlightedTitleStringMu:(NSString *)highlightedTitleStringMu{
    [self setTitle:highlightedTitleStringMu forState:UIControlStateHighlighted];
    objc_setAssociatedObject(self, @selector(highlightedTitleStringMu), highlightedTitleStringMu, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)highlightedTitleStringMu{
    return objc_getAssociatedObject(self, @selector(highlightedTitleStringMu));
}

//设置高亮图片
-(void)setHighlightedContentImageMu:(UIImage *)highlightedContentImageMu{
    [self setImage:highlightedContentImageMu forState:UIControlStateHighlighted];
    objc_setAssociatedObject(self, @selector(highlightedContentImageMu), highlightedContentImageMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImage *)highlightedContentImageMu{
    return objc_getAssociatedObject(self, @selector(highlightedContentImageMu));
}
//设置高亮背景图片
-(void)setHighlightedBackgroundImageMu:(UIImage *)highlightedBackgroundImageMu{
    [self setBackgroundImage:highlightedBackgroundImageMu forState:UIControlStateHighlighted];
    objc_setAssociatedObject(self, @selector(highlightedBackgroundImageMu), highlightedBackgroundImageMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImage *)highlightedBackgroundImageMu{
    return objc_getAssociatedObject(self, @selector(highlightedBackgroundImageMu));
}
-(void)setSwapPositionMu:(BOOL)swapPositionMu{
    if (swapPositionMu) {
        [self.titleLabel sizeToFit];
        UIImage *image = self.currentImage;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width - 4, 0, image.size.width)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width+4, 0, -self.titleLabel.bounds.size.width)];
    }
    objc_setAssociatedObject(self, @selector(swapPositionMu), @(swapPositionMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)swapPositionMu{
    
    return [objc_getAssociatedObject(self, @selector(swapPositionMu)) boolValue];
}

-(void)startCountDownWithSeconds:(NSInteger)seconds{
    __block NSInteger timeOut = seconds;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //设置定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        if (timeOut <=0 ) {//倒计时结束
            
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{//设置显示
                
                self.userInteractionEnabled = YES;
                [self setTitle:@" 重新获取 " forState:UIControlStateNormal];
                [self setTitle:@" 重新获取 " forState:UIControlStateDisabled];
                
            });
            
            
        }else{
            
            NSString *string = [NSString stringWithFormat:@" %lds ",(long)timeOut];
            
            dispatch_async(dispatch_get_main_queue(), ^{//设置显示
                
                self.userInteractionEnabled = NO;
                [self setTitle:string forState:UIControlStateNormal];
                //                self.titleLabel.text = string;
                [self setTitle:string forState:UIControlStateDisabled];
            });
            timeOut --;
        }
    });
    
    dispatch_resume(timer);
}
@end


#pragma mark -NSString常用
@implementation NSString (MUNormal)

//时间戳转YYYY-MM-dd格式
-(NSString *)timestampToYYYY_MM_ddFromMu{
    
    if (![self allNumberCharacters]) {
        return self;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]] ;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

//时间戳转YYYY-MM-dd hh:mm:ss格式
-(NSString *)timestampToDateFromMu{
    if (![self allNumberCharacters]) {
        return self;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]] ;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}
//时间戳转你想要的格式
-(NSString *)timestampToDateWithFormatFromMu:(NSString *)Format{
    if (![self allNumberCharacters]) {
        return self;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:Format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//时间转时间戳
-(NSString *)timestampFromDateWithFormatMu:(NSString *)Format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:Format];
    NSDate *lastDate = [formatter dateFromString:self];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",firstStamp];
}
//获取当前时间戳
+(NSString *)getNowTimeTimestampMu{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    return timeString;
}

/**分别根据时间戳与标准时间计算: 几分钟之前，几小时之前...*/
-(NSString *)timeBeforeInfoWithTimestampMu:(NSString *)timestamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取此时时间戳长度
    NSTimeInterval timeIntrval     = [timestamp doubleValue];
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timeIntrval; //时间差
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    //    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前",year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前",month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前",day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前",hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前",minute];
    }else{
        return [NSString stringWithFormat:@"刚刚"];
    }
    
}
/**时间戳转星座摩羯座 12月22日------1月19日
 水瓶座 1月20日-------2月18日
 双鱼座 2月19日-------3月20日
 白羊座 3月21日-------4月19日
 金牛座 4月20日-------5月20日
 双子座 5月21日-------6月21日
 巨蟹座 6月22日-------7月22日
 狮子座 7月23日-------8月22日
 处女座 8月23日-------9月22日
 天秤座 9月23日------10月23日
 天蝎座 10月24日-----11月21日
 射手座 11月22日-----12月21日
 */
-(NSString *)timestampToConstellationMu{
    //计算月份
    NSString *date = [self timestampToYYYY_MM_ddFromMu];
    NSString *retStr=@"";
    NSString *birthStr = [date substringFromIndex:5];
    int month=0;
    NSString *theMonth = [birthStr substringToIndex:2];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        month = [[theMonth substringFromIndex:1] intValue];
    }else{
        month = [theMonth intValue];
    }
    //计算天数
    int day=0;
    NSString *theDay = [birthStr substringFromIndex:3];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        day = [[theDay substringFromIndex:1] intValue];
    }else {
        day = [theDay intValue];
    }
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    if(month==2 && day>29) {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    retStr=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    return [NSString stringWithFormat:@"%@座",retStr];
}
/**根据时间戳算年龄*/
-(NSString *)timestampToAgeMu{
    NSString *dateString = [self timestampFromDateWithFormatMu:@"yyyy/MM/dd"];
    NSString *year = [dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateString substringWithRange:NSMakeRange(dateString.length-2, 2)];
    //    NSLog(@"出生于%@年%@月%@日", year, month, day);
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *compomemts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger nowYear = compomemts.year;
    NSInteger nowMonth = compomemts.month;
    NSInteger nowDay = compomemts.day;
    //    NSLog(@"今天是%ld年%ld月%ld日", nowYear, nowMonth, nowDay);
    
    // 计算年龄
    NSInteger userAge = nowYear - year.intValue - 1;
    if ((nowMonth > month.intValue) || (nowMonth == month.intValue && nowDay >= day.intValue)) {
        userAge++;
    }
    return [NSString stringWithFormat:@"%ld",userAge];
    
}
/**
 * @brief 将数字1234 格式化为1,234
 */
-(NSString *)decimalStringWithNumberMu{
    
    if (![self allNumberCharacters]) {
        return self;
    }
    NSNumber *number  = [NSNumber numberWithDouble:[self doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *string = [formatter stringFromNumber:number];
    //    if(suffix != nil){
    //        string = [string stringByAppendingString:suffix];
    //    }
    return string;
}
+ (NSString *)decimalStringWithNumber:(NSNumber *)number andSuffix:(NSString *)suffix {
    if(number == nil){
        return @"0";
    }
    if([number isKindOfClass:[NSString class]]){
        number = [NSNumber numberWithDouble:[(NSString *)number doubleValue]];
    }
    if (![number isKindOfClass:[NSNumber class]]) {
        
        return @"0";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *string = [formatter stringFromNumber:number];
    if(suffix != nil){
        string = [string stringByAppendingString:suffix];
    }
    return string;
}
/**正常号转银行卡号 － 增加4位间的空格*/
-(NSString *)normalNumberToBankNumberMu{
    NSString *tmpStr = self;
    NSInteger size = (tmpStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}
//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}
/**银行卡号转正常号 － 去除4位间的空格*/
-(NSString *)bankNumberToNormalNumberMu{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}
/**中间的用*替代*/
-(NSString *)stringByReplacingIndex:(NSUInteger)index count:(NSUInteger)count withString:(NSString *)aString{
    
    if ((index+count) > self.length) {
        return self;
    }
    NSString *subStr1 = [self substringToIndex:index];
    NSString *subStr2 = [self substringFromIndex:index+count];
    NSString *replaceStr = @"";
    if (!aString) {
        aString = @"*";
    }
    for (NSUInteger num = 0; num < count; num++) {
        replaceStr = [NSString stringWithFormat:@"%@%@",replaceStr,aString];
    }
    return [NSString stringWithFormat:@"%@%@%@",subStr1,replaceStr,subStr2];
}
//判断字符串是否为纯数字
- (BOOL)allNumberCharacters{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(str.length > 0)
    {
        return NO;
    }
    return YES;
}
/**处理银行卡 格式为****1234保留最后4位*/
- (NSString *)securityBankCardMu{
    NSString *IDCard =  self;
    if(IDCard.length > 10){
        return [NSString stringWithFormat:@"%@********%@",[IDCard substringToIndex:6], [IDCard substringFromIndex:IDCard.length-4]];
    }else if(IDCard.length > 4){
        return [NSString stringWithFormat:@"********%@", [IDCard substringFromIndex:IDCard.length-4]];
    }
    return IDCard;
}
/*邮箱*/
-(BOOL)validateEmailMu{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
/*车牌号验证*/
-(BOOL)validateCarNoMu{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}
/*车型*/
-(BOOL)validateCarTypeMu{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:self];
}
/*身份证号*/
- (BOOL)validateIdentityCardMu{
    if (self.length != 18) return NO;
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}
//字典转字符串
+(NSString *)dictionaryToJson:(NSDictionary *)dict{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
}
//文字首行缩进
-(NSMutableAttributedString *)attributesWithLineSpacing:(CGFloat)firstLineHeadIndent{
    //分段样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //头部缩进
    paragraphStyle.headIndent = firstLineHeadIndent;
    //首行缩进
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    //尾部缩进
    paragraphStyle.tailIndent = -firstLineHeadIndent;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self attributes:@{ NSParagraphStyleAttributeName : paragraphStyle}];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithAttributedString:attrText];
    return mString;
}
static dispatch_source_t timer;
/*倒计时*/
-(void)countdownWithTimeInterval:(NSString *)timeInterval callback:(void (^)(NSDictionary *))callback{
    
    if (timer) {
        dispatch_source_cancel(timer);
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] ;
    double currentTime = [timeInterval doubleValue] - interval;
    __block float timeout= currentTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.1*NSEC_PER_SEC, 0); // 每100毫秒执行
    timer = _timer;
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束，关闭处理
                if(callback){
                    callback(nil);
                }
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] ;
                double currentTime = [timeInterval doubleValue] - interval;
                
                int currentDay   = currentTime / (3600 *24);
                int currentHour  = (currentTime - currentDay*3600*24) / 3600;
                int currentMinute = (currentTime -currentDay*3600*24 -currentHour*3600) / 60;
                int currentSeconds = currentTime -currentDay*3600*24- currentHour*3600 -currentMinute*60;
                int currentMsec = (currentTime - currentDay*3600*24-currentHour*3600 - currentMinute*60 - currentSeconds)*1000;
                int msec = (currentMsec/100) % 1000;
                NSDictionary *dict = @{@"Day":[NSString stringWithFormat:@"%d",currentDay],@"Hour":[NSString stringWithFormat:@"%d",currentHour],@"Minute":[NSString stringWithFormat:@"%d",currentMinute],@"Seconds":[NSString stringWithFormat:@"%d",currentSeconds],@"Msec":[NSString stringWithFormat:@"%d",msec]};
                
                if(callback){
                    callback(dict);
                }
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
-(NSAttributedString *)attributesWithColor:(UIColor *)color string:(NSString *)string{
    
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self];
        [mString addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        
        return mString;
    }
    return nil;
}

-(NSAttributedString *)attributesWithFont:(UIFont *)font string:(NSString *)string{
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self];
        [mString addAttributes:@{NSFontAttributeName:font} range:range];
        
        return mString;
    }
    return nil;
}
-(NSAttributedString *)attributesWithUnderlineColor:(UIColor *)color string:(NSString *)string{
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self];
        [mString addAttributes:@{NSUnderlineColorAttributeName:color,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:range];
        
        return mString;
    }
    return nil;
}

-(NSAttributedString *)attributesWithStrikethroughlineColor:(UIColor *)color string:(NSString *)string{
    
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self];
        [mString addAttributes:@{NSUnderlineColorAttributeName:color,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:range];
        
        return mString;
        
    }
    return nil;
}
@end

