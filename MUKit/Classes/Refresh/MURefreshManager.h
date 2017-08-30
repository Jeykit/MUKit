//
//  MURefreshManager.h
//  Pods
//
//  Created by Jekity on 2017/8/30.
//
//

#import <Foundation/Foundation.h>

@interface MURefreshManager : NSObject
+(void)refreshWithScrollView:(UIScrollView *)scrollView;
+(void)refreshWithScrollView:(UIScrollView *)scrollView GIFImages:(NSArray*)images;
@end
