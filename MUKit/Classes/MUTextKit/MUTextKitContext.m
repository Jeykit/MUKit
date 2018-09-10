//
//  MUTextKitContext.m
//  MUKit_Example
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUTextKitContext.h"
#import "MUTextLayoutManager.h"
#import <pthread.h>

@implementation MUTextKitContext
{
    // All TextKit operations (even non-mutative ones) must be executed serially.
    NSRecursiveLock* __instanceLock__;
    NSLayoutManager *_layoutManager;
    NSTextStorage *_textStorage;
    NSTextContainer *_textContainer;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
                           lineBreakMode:(NSLineBreakMode)lineBreakMode
                    maximumNumberOfLines:(NSUInteger)maximumNumberOfLines
                          exclusionPaths:(NSArray *)exclusionPaths
                         constrainedSize:(CGSize)constrainedSize

{
    if (self = [super init]) {
        // Concurrently initialising TextKit components crashes (rdar://18448377) so we use a global lock.
        
        __instanceLock__ = [[NSRecursiveLock alloc]init];
        
        // Create the TextKit component stack with our default configuration.
        
        _textStorage = [[NSTextStorage alloc] init];
        _layoutManager = [[MUTextLayoutManager alloc] init];
        _layoutManager.usesFontLeading = NO;
        [_textStorage addLayoutManager:_layoutManager];
        
        // Instead of calling [NSTextStorage initWithAttributedString:], setting attributedString just after calling addlayoutManager can fix CJK language layout issues.
        // See https://github.com/facebook/AsyncDisplayKit/issues/2894
        if (attributedString) {
            [_textStorage setAttributedString:attributedString];
        }
        
        _textContainer = [[NSTextContainer alloc] initWithSize:constrainedSize];
        // We want the text laid out up to the very edges of the container.
        _textContainer.lineFragmentPadding = 0;
        _textContainer.lineBreakMode = lineBreakMode;
        _textContainer.maximumNumberOfLines = maximumNumberOfLines;
        _textContainer.exclusionPaths = exclusionPaths;
        [_layoutManager addTextContainer:_textContainer];
    }
    return self;
}

- (void)performBlockWithLockedTextKitComponents:(void (^)(NSLayoutManager *,
                                                          NSTextStorage *,
                                                          NSTextContainer *))block
{
    [__instanceLock__ lock];
    if (block) {
        block(_layoutManager, _textStorage, _textContainer);
    }
    [__instanceLock__ unlock];
}

- (NSLayoutManager *)layoutManager{
    return _layoutManager;
}

- (NSTextContainer *)textContainer{
    return _textContainer;
}

- (NSTextStorage *)textStorage{
    return _textStorage;
}
@end
