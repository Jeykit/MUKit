//
//  UIView+MUSignal.m
//  elmsc
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "UIView+MUSignal.h"
#import <objc/message.h>

@interface UIView (MUSiganl)

//@property(nonatomic,assign)id viewController;

//判断当前触摸位置是否还在视图内，如果不在则不触发事件
@property(nonatomic,assign,getter=isTrigger)BOOL trigger;

@property (nonatomic,assign)NSIndexPath *innerIndexPath;

@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,weak)UICollectionView *collectionView;

@property (nonatomic,weak)NSObject *targetObject;

@property (nonatomic,strong)NSString *repeatedSignalName;

@property (nonatomic,weak)UIViewController* mu_ViewController;

@property (nonatomic,assign)NSUInteger innerSection;

@property (nonatomic,assign,getter=isControlsEvent)BOOL controlsEvent;

@property (nonatomic,assign,getter=isExitSignalName)BOOL exitSignalName;
@end

static NSString const * havedSignal = @"havedSignal_";
static UIControlEvents allEventControls = -1;

@implementation UIView (MUSignal)


-(void)setControlsEvent:(BOOL)controlsEvent{
    objc_setAssociatedObject(self, @selector(isControlsEvent), @(controlsEvent), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isControlsEvent{
    return [objc_getAssociatedObject(self, @selector(isControlsEvent)) boolValue];
}
-(void)setExitSignalName:(BOOL)exitSignalName{
    objc_setAssociatedObject(self, @selector(isExitSignalName), @(exitSignalName), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isExitSignalName{
    return [objc_getAssociatedObject(self, @selector(isExitSignalName)) boolValue];
}


-(void)setAllControlEvents:(UIControlEvents)allControlEvents{
    if (!self.isExitSignalName) {//先设置Event 再设置signal name
        self.controlsEvent     = YES;
        self.exitSignalName    = NO;
        
        allEventControls = allControlEvents;//保存类型

    }else{
        if ([self isKindOfClass:[UIControl class]]) {
            UIControl *control = (UIControl *)self;
            if (allControlEvents != allEventControls) {
                [control removeTarget:self action:@selector(didEvent:) forControlEvents:allEventControls];
                 allEventControls = allControlEvents;
            }
           
            [control addTarget:self action:@selector(didEvent:) forControlEvents:allControlEvents];
        
        }
        
    }
    

    objc_setAssociatedObject(self, @selector(allControlEvents), @(allControlEvents), OBJC_ASSOCIATION_ASSIGN);
}
-(UIControlEvents)allControlEvents{
    return [objc_getAssociatedObject(self, @selector(allControlEvents)) integerValue];
}


-(void)setClickSignalName:(NSString *)clickSignalName{
    

    objc_setAssociatedObject(self, @selector(clickSignalName), clickSignalName, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.userInteractionEnabled = YES;
    if (!self.isControlsEvent) {//先设置signal name 再设置 event
        
        self.controlsEvent     = NO;
        self.exitSignalName    = YES;
        
        self.allControlEvents = [self eventControlWithInstance:self];//设置类型
    }else{
        

        if ([self isKindOfClass:[UIControl class]]) {
            UIControl *control = (UIControl *)self;
            [control addTarget:self action:@selector(didEvent:) forControlEvents:allEventControls];
        
        }
        
    }
    
}
#pragma clang diagnostic pop
-(void)didEvent:(UIControl *)control{
    
    if (self.clickSignalName == nil) {
        
        NSString *name = [self dymaicSignalName];
        if (name.length <= 0) {
            
            self.clickSignalName = name;
        }else{
            name = [name stringByReplacingOccurrencesOfString:@"_" withString:@""];
            self.clickSignalName = name;
        }
        
    }else{
        
        if (self.clickSignalName.length <= 0) {
            return;
        }
    }
    [self sendSignal];
}

-(NSString *)clickSignalName{
    
//    if ([self isKindOfClass:[UITableViewCell class]] || [self isKindOfClass:[UICollectionViewCell class]] ) {
//        
//        return nil;
//    }
    return objc_getAssociatedObject(self, @selector(clickSignalName));
}

-(void)setInnerSection:(NSUInteger)innerSection{
    objc_setAssociatedObject(self, @selector(innerSection), @(innerSection), OBJC_ASSOCIATION_ASSIGN);
}

-(NSUInteger)innerSection{
    
    return [objc_getAssociatedObject(self, @selector(innerSection)) integerValue];
}

-(NSUInteger)sections{
    return self.innerSection;
}
#pragma -mark mu_viewController
-(void)setMu_ViewController:(UIViewController*)mu_ViewController{
    objc_setAssociatedObject(self, @selector(mu_ViewController), mu_ViewController, OBJC_ASSOCIATION_ASSIGN);
}

-(UIViewController*)mu_ViewController{
    
    return objc_getAssociatedObject(self, @selector(mu_ViewController));
}

-(id)viewController{
    
    return self.mu_ViewController;
}


-(void)setTrigger:(BOOL)trigger{
    
    objc_setAssociatedObject(self, @selector(isTrigger), [NSNumber numberWithBool:trigger], OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)isTrigger{
    
    return  [objc_getAssociatedObject(self, @selector(isTrigger)) boolValue];
}

-(void)setInnerIndexPath:(NSIndexPath *)innerIndexPath{
    
    objc_setAssociatedObject(self, @selector(innerIndexPath), innerIndexPath, OBJC_ASSOCIATION_ASSIGN);
}

#pragma -mark repeated name
-(void)setRepeatedSignalName:(NSString *)repeatedSignalName{
    
    objc_setAssociatedObject(self, @selector(repeatedSignalName), repeatedSignalName, OBJC_ASSOCIATION_COPY);
}

-(NSString *)repeatedSignalName{
    
    return objc_getAssociatedObject(self, @selector(repeatedSignalName));
}

-(NSIndexPath *)innerIndexPath{
    
    return objc_getAssociatedObject(self, @selector(innerIndexPath));
}

-(NSIndexPath *)indexPath{
    
    return self.innerIndexPath;
}

-(void)setTableView:(UITableView *)tableView{
    
    objc_setAssociatedObject(self, @selector(tableView), tableView, OBJC_ASSOCIATION_ASSIGN);
}

-(UITableView *)tableView{
    
    return objc_getAssociatedObject(self, @selector(tableView));
}

-(void)setCollectionView:(UICollectionView *)collectionView{
    
    objc_setAssociatedObject(self, @selector(collectionView), collectionView, OBJC_ASSOCIATION_ASSIGN);
}

-(UICollectionView *)collectionView{
    
    return objc_getAssociatedObject(self, @selector(collectionView));
}

#pragma -mark the task in execution with targetObject
-(void)setTargetObject:(NSObject *)targetObject{
    
    objc_setAssociatedObject(self, @selector(targetObject), targetObject, OBJC_ASSOCIATION_ASSIGN);
}

-(NSObject *)targetObject{
    
    return objc_getAssociatedObject(self, @selector(targetObject));
}


#pragma mark -signal name
-(UIView *(^)(NSString *))setSignalName{
    
    __weak typeof(self)weakSelf = self;
    return ^(NSString *signalName){
        
        weakSelf.clickSignalName = signalName;
        
        return weakSelf;
    };
}

-(void)setSetSignalName:(UIView *(^)(NSString *))setSignalName{
    
    objc_setAssociatedObject(self, @selector(setSetSignalName:), setSignalName, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark enforce -target
-(UIView *(^)(NSObject *))enforceTarget{
    
    __weak typeof(self)weakSelf = self;
    return ^(NSObject * target){
        __weak typeof(target)weakTarget = target;
        weakSelf.targetObject = weakTarget;
        return weakSelf;
    };
}

-(void)setEnforceTarget:(UIView *(^)(NSObject *))enforceTarget{
    
    objc_setAssociatedObject(self, @selector(enforceTarget), enforceTarget, OBJC_ASSOCIATION_ASSIGN);
}
#pragma mark -events
-(void)setControlEvents:(UIView *(^)(UIControlEvents))controlEvents{
    objc_setAssociatedObject(self, @selector(controlEvents), controlEvents, OBJC_ASSOCIATION_ASSIGN);
}
-(UIView *(^)(UIControlEvents))controlEvents{
    __weak typeof(self)weakSelf = self;
    return ^(UIControlEvents  event){
        weakSelf.allControlEvents = event;
        return weakSelf;
    };
    
}
#pragma mark- touch events handler
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.clickSignalName == nil) {
        NSString *name = [self dymaicSignalName];
        if (name.length <= 0) {
            [super touchesBegan:touches withEvent:event];
        }else{
            
            if ([self isKindOfClass:[UITableViewCell class]] || [self isKindOfClass:[UICollectionView class]]) {
                [super touchesBegan:touches withEvent:event];
            }else{
                self.clickSignalName = name;
            }
            
        }
        
    }else{
        
        if (self.clickSignalName.length <= 0) {
            [super touchesBegan:touches withEvent:event];
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.clickSignalName != nil) {
        UITouch *touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self];
        
        self.trigger = [self pointInside:point withEvent:event];
        
        if (self.isTrigger) {
            
            [self sendSignal];
        }
        
    }else{
        [super touchesEnded:touches withEvent:event];
    }
    
    
}
-(NSString *)nameWithInstance:(id)instance responder:(UIResponder *)responder{
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([responder class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        //        NSLog(@"ivar_name--------%@------%@",NSStringFromClass([responder class]),key);
        if ((object_getIvar(responder, thisIvar) == instance)) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }else{
            key = @"";
        }
    }
    free(ivars);
    return key;
    
}
-(NSString *)dymaicSignalName{
    
    
    //     NSLog(@"%@",NSStringFromClass([nextResponder class]));
    NSString *name = @"";
    if ([self isKindOfClass:[UITableViewCell class]] || [self isKindOfClass:[UICollectionViewCell class]]||[self isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]||[NSStringFromClass([self class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([self class]) isEqualToString:@"UICollectionViewCellContentView"]) {
        return name;
    }
    UIResponder *nextResponder = self.nextResponder;
    while (nextResponder != nil) {
        
        
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            self.mu_ViewController = nil;
            break;
        }
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            self.mu_ViewController = (UIViewController*)nextResponder;
            name = [self nameWithInstance:self responder:nextResponder];
            if (name.length > 0) {
                name = [name stringByReplacingOccurrencesOfString:@"_" withString:@""];
                return name;
                
            }
            break;
            
        }
//        else if ([nextResponder isKindOfClass:[UITableViewCell class]] || [nextResponder isKindOfClass:[UICollectionViewCell class]]){
//            self.innerIndexPath = [self indexPathForCellWithId:nextResponder];
//            
//        }
        else if ([nextResponder isKindOfClass:[UITableViewHeaderFooterView class]]) {
            UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *)nextResponder;
            self.innerSection                             = headerFooterView.tag;
        }
        name = [self nameWithInstance:self responder:nextResponder];
        if (name.length > 0) {
            name = [name stringByReplacingOccurrencesOfString:@"_" withString:@""];
            NSString *selectorString = [havedSignal stringByAppendingString:name];
            selectorString = [NSString stringWithFormat:@"%@:",selectorString];
            if ([nextResponder respondsToSelector:NSSelectorFromString(selectorString)]) {
                self.enforceTarget(nextResponder);
            }
            return name;
        }
        nextResponder = nextResponder.nextResponder;
    }
    return name;
}
#pragma -mark indexPath
-(NSIndexPath *)indexPathForCellWithId:(id)subViews{
    
    NSIndexPath *idxPath;
    
    
    if ([subViews isKindOfClass:[UITableViewCell class]]) {
        
        UITableViewCell *cell = (UITableViewCell *)subViews;
        
        UITableView *tableView = (UITableView *)cell.superview.superview;
        
        idxPath = [tableView indexPathForCell:cell];
        
        self.tableView = tableView;
        
    }else{
        
        UICollectionViewCell *cell = (UICollectionViewCell *)subViews;
        
        UICollectionView *collectionView = (UICollectionView *)cell.superview;
        
        idxPath = [collectionView indexPathForCell:cell];
        
        self.collectionView = collectionView;
    }
    return idxPath;
}


//send action to target(viewController)
-(void)sendSignal{
    
    void(*action)(id,SEL,id) = (void(*)(id,SEL,id))objc_msgSend;
    if (self.repeatedSignalName.length<=0) {
        self.clickSignalName = [havedSignal stringByAppendingString:self.clickSignalName];
        self.clickSignalName = [NSString stringWithFormat:@"%@:",self.clickSignalName];
        self.repeatedSignalName = self.clickSignalName;
    }
    
    if (self.repeatedSignalName.length <=0) {
        return;
    }
    
    //防止子控件获取控制器时失败
    [self getViewControllerFromCurrentView];
    SEL selctor = NSSelectorFromString(self.repeatedSignalName);
    if ([self.targetObject respondsToSelector:selctor]) {
        action(self.targetObject,selctor,self);
        return;
        
    }
    
    //指定在cell里执行
    if (self.tableView) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        if (cell&&[cell respondsToSelector:selctor]) {
            action(cell,selctor,self);
             return;
        }
       
        
    }
    if (self.collectionView) {
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.indexPath];
        if (cell&&[cell respondsToSelector:selctor]) {
            action(cell,selctor,self);
            return;
        }
       
        
    }
    //
    if ([self.mu_ViewController respondsToSelector:selctor]) {
        action(self.mu_ViewController,selctor,self);
    }
    
    //Don't not straight to this method that it will be kill when you run in a really iOS(64) Device
    //    objc_msgSend(self.viewController,selctor,self);
    
}
-(void)getViewControllerFromCurrentView{
    
    UIResponder *nextResponder = self.nextResponder;
    //     NSLog(@"%@",NSStringFromClass([nextResponder class]));
    while (nextResponder != nil) {
        
        
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            self.mu_ViewController = nil;
            break;
        }
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            self.mu_ViewController = (UIViewController*)nextResponder;
            
            break;
            
        }else if ([nextResponder isKindOfClass:[UITableViewCell class]] || [nextResponder isKindOfClass:[UICollectionViewCell class]]){
            
            self.innerIndexPath = [self indexPathForCellWithId:nextResponder];
            
        }else if ([nextResponder isKindOfClass:[UITableViewHeaderFooterView class]]) {
            UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *)nextResponder;
            self.innerSection                             = headerFooterView.tag;
        }
        
        nextResponder = nextResponder.nextResponder;
    }
}


-(void)performTarget:(id)target aSelector:(SEL)aSelector anArgument:(id)anArgument{
    
    if ([target respondsToSelector:aSelector]) {
        
        if (!self.innerIndexPath) {
            [self getViewControllerFromCurrentView];
        }
        void(*action)(id,SEL,id) = (void(*)(id,SEL,id))objc_msgSend;
        action(target,aSelector,anArgument);
        
        return;
    }
    
    //    log(@"selector is not found");
}

#pragma mark -hitTest
static NSUInteger tostFlag = 0;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if (tostFlag%2 == 0) {
        if ([self pointInside:point withEvent:event]) {
            for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
                CGPoint convertedPoint = [subview convertPoint:point fromView:self];
                UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
                if (hitTestView) {
                    if (hitTestView.clickSignalName.length <= 0&&[hitTestView isKindOfClass:[UIControl class]]) {
                        NSString *name = [hitTestView dymaicSignalName];
                        name = [name stringByReplacingOccurrencesOfString:@"_" withString:@""];
                        hitTestView.clickSignalName = name;
                    }
                    return hitTestView;
                }
            }
            return self;
        }
    }
    
    return nil;
}

#pragma mark -configured allEventControls
-(UIControlEvents)eventControlWithInstance:(UIView *)instance{
    if (![instance isKindOfClass:[UIButton class]]) {
        
        if ([instance isKindOfClass:[UITextField class]]) {
            return UIControlEventEditingChanged;
        }else{
            return UIControlEventValueChanged;
        }
        
    }else{
        return UIControlEventTouchUpInside;
    }
    return -1;
}

@end



