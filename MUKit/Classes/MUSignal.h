//
//  MUSignal.h
//  elmsc
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#ifndef MUSignal_h
#define MUSignal_h
#import "UIView+MUSignal.h"
#import "NSObject+MUSignal.h"


#define DefclickSignalName self.clickSignalName
#undef	Click_signal
#define Click_signal(DefclickSignalName) \
- (void)havedSignal_##DefclickSignalName:(id)object
#endif /* MUSignal_h */
