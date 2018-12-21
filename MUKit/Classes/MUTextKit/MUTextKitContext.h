//
//  MUTextKitContext.h
//  MUKit_Example
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MUTextKitContext : NSObject
/**
 Initializes a context and its associated TextKit components.
 
 Initialization of TextKit components is a globally locking operation so be careful of bottlenecks with this class.
 */
- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
                           lineBreakMode:(NSLineBreakMode)lineBreakMode
                    maximumNumberOfLines:(NSUInteger)maximumNumberOfLines
                          exclusionPaths:(NSArray *)exclusionPaths
                         constrainedSize:(CGSize)constrainedSize;

/**
 All operations on TextKit values MUST occur within this locked context.  Simultaneous access (even non-mutative) to
 TextKit components may cause crashes.
 
 The block provided MUST not call out to client code from within its scope or it is possible for this to cause deadlocks
 in your application.  Use with EXTREME care.
 
 Callers MUST NOT keep a ref to these internal objects and use them later.  This WILL cause crashes in your application.
 __attribute__((noescape)) 标记一个block
 */
- (void)performBlockWithLockedTextKitComponents:( void (^)(NSLayoutManager *layoutManager,
                                                                      NSTextStorage *textStorage,
                                                                      NSTextContainer *textContainer))block;

@property (nonatomic, strong ,readonly) NSLayoutManager *layoutManager;
@property (nonatomic, strong ,readonly) NSTextStorage *textStorage;
@property (nonatomic, strong ,readonly) NSTextContainer *textContainer;
@end
