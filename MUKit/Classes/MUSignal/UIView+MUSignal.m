//
//  UIView+MUSignal.m
//  elmsc
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "UIView+MUSignal.h"
#import <objc/message.h>


typedef void (^DeallocBlock)(void);
@interface MUOrignalObject : NSObject
@property (nonatomic, copy) DeallocBlock block;
-(instancetype)initWithBlock:(DeallocBlock)block;
@end
@implementation MUOrignalObject
- (instancetype)initWithBlock:(DeallocBlock)block
{
    if (self = [super init]){
        self.block = block;
    }
    return self;
}
- (void)dealloc {
    self.block ? self.block() : nil;
}
@end
@interface UIView ()

//@property(nonatomic,assign)id viewController;

//判断当前触摸位置是否还在视图内，如果不在则不触发事件
@property(nonatomic,assign,getter=isTrigger)BOOL trigger;

@property (nonatomic,assign)NSIndexPath *innerIndexPath;

@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,weak)UICollectionView *collectionView;

@property (nonatomic,weak)NSObject *targetObject;

@property (nonatomic,strong)NSString *repeatedSignalName;

@property (nonatomic,weak)UIViewController* mu_ViewController;

@property (nonatomic,assign,getter=isAchieve)BOOL achieve;

@end

static NSString const * havedSignal = @"MUSignal_";
static UIControlEvents allEventControls = -1;
@implementation UIView (MUSignal)

-(void)setAchieve:(BOOL)achieve{
    objc_setAssociatedObject(self, @selector(isAchieve), @(achieve), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isAchieve{
    return [objc_getAssociatedObject(self, @selector(isAchieve)) boolValue];
}


-(void)setAllControlEvents:(UIControlEvents)allControlEvents{
    if ([self isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)self;
        if (self.isAchieve) {
            
            if (allControlEvents != allEventControls) {
                [control removeTarget:self action:@selector(didEvent:) forControlEvents:allEventControls];
                allEventControls = allControlEvents;
                [control addTarget:self action:@selector(didEvent:) forControlEvents:allControlEvents];
            }
        }else{
            self.achieve = YES;
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
    if ([self isKindOfClass:[UIControl class]]) {
        
        if (!self.isAchieve) {
            UIControl *control = (UIControl *)self;
            self.achieve = YES;
            allEventControls = [self eventControlWithInstance:self];
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
            self.clickSignalName = name;
        }
        
    }
    if (self.clickSignalName.length <= 0) {
        return;
    }
    [self sendSignal];
}

-(NSString *)clickSignalName{
    
    return objc_getAssociatedObject(self, @selector(clickSignalName));
}


#pragma -mark mu_viewController
-(void)setMu_ViewController:(UIViewController*)mu_ViewController{
    MUOrignalObject *ob = [[MUOrignalObject alloc] initWithBlock:^{
        objc_setAssociatedObject(self, @selector(mu_ViewController), nil, OBJC_ASSOCIATION_ASSIGN);
    }];
    // 这里关联的key必须唯一，如果使用_cmd，对一个对象多次关联的时候，前面的对象关联会失效。
    if (mu_ViewController) {
        objc_setAssociatedObject(mu_ViewController, (__bridge const void *)(ob.block), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else{
        ob.block();
    }
    objc_setAssociatedObject(self, @selector(mu_ViewController), mu_ViewController, OBJC_ASSOCIATION_ASSIGN);
}

-(UIViewController*)mu_ViewController{
    
    return objc_getAssociatedObject(self, _cmd);
}

-(id)viewController{
    
    if (!self.mu_ViewController) {
        
        [self getViewControllerFromCurrentView];
    }
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
    
    MUOrignalObject *ob = [[MUOrignalObject alloc] initWithBlock:^{
        objc_setAssociatedObject(self, @selector(tableView), nil, OBJC_ASSOCIATION_ASSIGN);
    }];
    // 这里关联的key必须唯一，如果使用_cmd，对一个对象多次关联的时候，前面的对象关联会失效。
    if (tableView) {
        objc_setAssociatedObject(tableView, (__bridge const void *)(ob.block), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, @selector(tableView), tableView, OBJC_ASSOCIATION_ASSIGN);
}

-(UITableView *)tableView{
    
    return objc_getAssociatedObject(self, @selector(tableView));
}

-(void)setCollectionView:(UICollectionView *)collectionView{
    
    MUOrignalObject *ob = [[MUOrignalObject alloc] initWithBlock:^{
        objc_setAssociatedObject(self, @selector(collectionView), nil, OBJC_ASSOCIATION_ASSIGN);
    }];
    // 这里关联的key必须唯一，如果使用_cmd，对一个对象多次关联的时候，前面的对象关联会失效。
    if (collectionView) {
        objc_setAssociatedObject(collectionView, (__bridge const void *)(ob.block), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, @selector(collectionView), collectionView, OBJC_ASSOCIATION_ASSIGN);
}

-(UICollectionView *)collectionView{
    
    return objc_getAssociatedObject(self, @selector(collectionView));
}

#pragma -mark the task in execution with targetObject
-(void)setTargetObject:(NSObject *)targetObject{
    
    MUOrignalObject *ob = [[MUOrignalObject alloc] initWithBlock:^{
        objc_setAssociatedObject(self, @selector(targetObject), nil, OBJC_ASSOCIATION_ASSIGN);
    }];
    // 这里关联的key必须唯一，如果使用_cmd，对一个对象多次关联的时候，前面的对象关联会失效。
    if (targetObject) {
        objc_setAssociatedObject(targetObject, (__bridge const void *)(ob.block), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
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
- (void)MUTouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if (self.clickSignalName.length <= 0) {
        NSString *name = [self dymaicSignalName];
        if (name.length > 0) {
            self.clickSignalName = name;
            UITouch *touch = [touches anyObject];
            
            CGPoint point = [touch locationInView:self];
            
            self.trigger = [self pointInside:point withEvent:event];
            
            if (self.isTrigger && ![self isKindOfClass:[UIControl class]]) {
                
                [self sendSignal];
            }
            
        }
    }else{
        UITouch *touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self];
        
        self.trigger = [self pointInside:point withEvent:event];
        if (self.isTrigger && ![self isKindOfClass:[UIControl class]]) {
            [self sendSignal];
        }
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
        if (![stringType hasPrefix:@"@"] || ![object_getIvar(responder, thisIvar) isKindOfClass:[UIView class]]) {
            continue;
        }
        
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
                name = [name substringFromIndex:1];//防止命名有_的属性名被过滤掉
                return name;
                
            }
            break;
            
        }
        if([nextResponder isKindOfClass:NSClassFromString(@"UIKeyboardCandidateBarCell")] || [self isKindOfClass:NSClassFromString(@"PUPhotosGridCell")]){//清除键盘上的信号设置
            return name;
        }
        
        name = [self nameWithInstance:self responder:nextResponder];
        if (name.length > 0) {
            name = [name substringFromIndex:1];//防止命名有_的属性名被过滤掉
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
    
    NSIndexPath *indexPath;
    
    
    if ([subViews isKindOfClass:[UITableViewCell class]]) {
        
        UITableViewCell *cell = (UITableViewCell *)subViews;
        
        if (@available(iOS 11.0, *)) {
            UITableView *tableView = (UITableView *)cell.superview;
            indexPath = [tableView indexPathForCell:cell];
            self.tableView = tableView;
        }else{
            UITableView *tableView = (UITableView *)cell.superview.superview;
            indexPath = [tableView indexPathForCell:cell];
            self.tableView = tableView;
        }
        
        
    }else{
        
        UICollectionViewCell *cell = (UICollectionViewCell *)subViews;
        
        UICollectionView *collectionView = (UICollectionView *)cell.superview;
        
        indexPath = [collectionView indexPathForCell:cell];
        
        self.collectionView = collectionView;
    }
    return indexPath;
}


//send action to target(viewController)
static BOOL forceRefrshMU = NO;//强制刷新标志
-(void)sendSignal{
    
    if (self.repeatedSignalName.length<=0) {
        self.clickSignalName = [havedSignal stringByAppendingString:self.clickSignalName];
        self.clickSignalName = [NSString stringWithFormat:@"%@:",self.clickSignalName];
        self.repeatedSignalName = self.clickSignalName;
    }
    
    if (self.repeatedSignalName.length <=0) {
        return;
    }
    void(*action)(id,SEL,id) = (void(*)(id,SEL,id))objc_msgSend;
    //防止子控件获取控制器时失败
    if(forceRefrshMU){
        self.mu_ViewController = nil;
        forceRefrshMU = NO;//执行后复原
    }
    if (!self.mu_ViewController) {
        [self getViewControllerFromCurrentView];
    }
    SEL selctor = NSSelectorFromString(self.repeatedSignalName);
    if ([self.targetObject respondsToSelector:selctor]) {
        action(self.targetObject,selctor,self);
        return;
        
    }
    //指定在cell里执行
    if (self.tableView&&self.indexPath) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        if (cell&&[cell respondsToSelector:selctor]) {
            action(cell,selctor,self);
            return;
        }
    }
    if (self.collectionView&&self.indexPath) {
        
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
-(void)forceRefresh{
    self.mu_ViewController = nil;
}
@end
@implementation NSObject (MUSignal)
-(void)sendSignal:(NSString *)signalName target:(NSObject *)target object:(id)object{
    
    if (!signalName || !target) {
        
        NSLog(@"%@-%@ The method can not be perform if the signalName or target is nil.",NSStringFromClass([target class]),signalName);
        return;
    }
    signalName = [havedSignal stringByAppendingString:signalName];
    
    signalName = [NSString stringWithFormat:@"%@:",signalName];
    
    SEL selector = NSSelectorFromString(signalName);
    
    /**end*/
    if ([target respondsToSelector:selector]) {
        
        void(*action)(id,SEL,id) = (void(*)(id,SEL,id))objc_msgSend;
        
        action(target,selector,object);
    }else{
        
        NSLog(@"%@-%@ The method can not be perform if the signalName or target is nil.",NSStringFromClass([target class]),signalName);
    }
    
}

-(void)sendSignal:(NSString *)signalName target:(NSObject *)target{
    
    [self sendSignal:signalName target:target object:nil];
}

@end
//hook
void MUHookMethodCellSubDecrption(const char * originalClassName ,SEL originalSEL ,const char * newClassName ,SEL newSEL){
    
    Class originalClass = objc_getClass(originalClassName);//get a class through a string
    if (originalClass == 0) {
        NSLog(@"%@-%@ I can't find a class through a 'originalClassName",NSStringFromClass(originalClass),NSStringFromSelector(newSEL));
        return;
    }
    Class newClass     = objc_getClass(newClassName);
    if (newClass == 0) {
        NSLog(@"%@-%@ I can't find a class through a 'originalClassName",NSStringFromClass(originalClass),NSStringFromSelector(newSEL));
        return;
    }
    class_addMethod(originalClass, newSEL, class_getMethodImplementation(newClass, newSEL), nil);//if newSEL not found in originalClass,it will auto add a method to this class;
    Method oldMethod = class_getInstanceMethod(originalClass, originalSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(originalClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}
@implementation UITableViewCell (MUSignal)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(prepareForReuse) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_prepareForReuse_tableviewcell)];
    });
    
}
+(void)muHookMethodViewController:(NSString *)originalClassName orignalSEL:(SEL)originalSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL{
    
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];
    MUHookMethodCellSubDecrption(originalName, originalSEL, newName, newSEL);
}
-(void)mu_prepareForReuse_tableviewcell{
    
    forceRefrshMU = YES;
    [self mu_prepareForReuse_tableviewcell];
    //    self.mu_ViewController = nil;
}
@end
@implementation UICollectionViewCell (MUSignal)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(prepareForReuse) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_prepareForReuse_collectionViewcell)];
    });
}
+(void)muHookMethodViewController:(NSString *)originalClassName orignalSEL:(SEL)originalSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL{
    
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];
    MUHookMethodCellSubDecrption(originalName, originalSEL, newName, newSEL);
}
-(void)mu_prepareForReuse_collectionViewcell{
    forceRefrshMU = YES;
    [self mu_prepareForReuse_collectionViewcell];
}
@end
