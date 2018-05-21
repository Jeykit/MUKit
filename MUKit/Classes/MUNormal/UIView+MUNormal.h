//
//  UIView+MUNormal.h
//  Pods
//
//  Created by Jekity on 2017/10/17.
//
//

#import <UIKit/UIKit.h>

@interface UIView (MUNormal)

/**
 这些方法加载出来xib(autolayout)的高度是经过计算的,它的高度绝大数情况下不会是屏幕的高度
 */
+(instancetype)viewForXibMu;
+(instancetype)viewForXibMuWithIndex:(NSUInteger)index;
+(instancetype)viewForXibNOMargaimMu;
/**
 @param object 持有xib的对象，自动对object对象初始化。常用
 */
+(instancetype)viewForXibMuWithRetainObject:(id)object;


/**
 @param view 持有xib的对象，自动对object对象初始化。xib的高度会在原有基础上增加12point。常用
 */
+(instancetype)viewForXibNOMargainMuWithRetainObject:(id)view;


@property (assign,nonatomic) CGFloat x_Mu;
@property (assign,nonatomic) CGFloat y_Mu;

@property (nonatomic, assign) CGSize size_Mu;
@property (nonatomic, assign) CGPoint origin_Mu;

@property (nonatomic, assign) CGFloat centerX_Mu;
@property (nonatomic, assign) CGFloat centerY_Mu;

@property (nonatomic, assign) CGFloat width_Mu;
@property (nonatomic, assign) CGFloat height_Mu;


@property (nonatomic, assign ,readonly) CGFloat maxX_Mu;
@property (nonatomic, assign ,readonly) CGFloat maxY_Mu;

@property (nonatomic, assign ,readonly) CGFloat minX_Mu;
@property (nonatomic, assign ,readonly) CGFloat minY_Mu;

@property (nonatomic, assign ,readonly) CGFloat midX_Mu;
@property (nonatomic, assign ,readonly) CGFloat midY_Mu;

@property(nonatomic, assign)CGFloat cornerRadius_Mu;
/**
 *  边框宽，边框颜色
 */
- (void)setMUBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/**
 *  边框宽，边框颜色，圆角
 */
- (void)setMUCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
@interface UILabel (MUNormal)
/**
 @param string 需要点击的字符串
 @param attributes 需要点击字符串的富文本属性
 @param tapBlock 文字被点击后的回调block
 */
-(void)addTapWithString:(NSString *)string attributes:(NSDictionary *)attributes tapBlock:(void (^)(void))tap;


/**
 @param array 需要点击的字符串数组
 @param attributes 需要点击字符串的富文本属性
 @param tapBlock 文字被点击后的回调block
 */
-(void)addTapWithArray:(NSArray<__kindof NSString *> *)array attributes:(NSDictionary *)attributes tapBlock:(void (^)(NSString * string))tap;//文字点击方法
@end
@interface UIButton (MUNormal)
//文字颜色
@property(nonatomic, strong)UIColor *titleColorMu;

//标题
@property(nonatomic, copy)NSString  *titleStringMu;

//图片
@property(nonatomic, strong)UIImage *contentImageMu;

//背景图片
@property(nonatomic, strong)UIImage *backgroundImageMu;


//标题字体
@property(nonatomic, assign)CGFloat  fontSizeMu;


//图片与标题互换位置
@property(nonatomic, assign)BOOL  swapPositionMu;

//标题高亮颜色
@property(nonatomic, strong)UIColor *highlightedTitleColorMu;


//高亮状态下的标题
@property(nonatomic, copy)NSString  *highlightedTitleStringMu;


//高亮状态下的图片
@property(nonatomic, strong)UIImage *highlightedContentImageMu;


//高亮状态下的背景图片
@property(nonatomic, strong)UIImage *highlightedBackgroundImageMu;


//倒计时
/**
 @param seconds 倒计时的秒数
 */
-(void)startCountDownWithSeconds:(NSInteger)seconds;
@end

#pragma mark -NSString
@interface NSString (MUNormal)

//YYYY_MM_dd
-(NSString *)timestampToYYYY_MM_ddFromMu;

//YYYY-MM-dd hh:mm:ss
-(NSString *)timestampToDateFromMu;

/*时间戳转化为时间*/
- (NSString *)timestampToDateWithFormatFromMu:(NSString *)Format;

//时间转时间戳
- (NSString *)timestampFromDateWithFormatMu:(NSString *)Format;

/*获取当前时间戳,秒为单位*/
+ (NSString *)getNowTimeTimestampMu;

/**分别根据时间戳与标准时间计算: 几分钟之前，几小时之前...*/
- (NSString *)timeBeforeInfoWithTimestampMu:(NSString *)timestamp;

/**时间戳转星座*/
-(NSString *)timestampToConstellationMu;

/**根据时间戳算年龄*/
-(NSString *)timestampToAgeMu;
/**
 * @brief 将数字1234 格式化为1,234
 */
-(NSString *)decimalStringWithNumberMu;
/**正常号转银行卡号 － 增加4位间的空格*/
-(NSString *)normalNumberToBankNumberMu;

/**银行卡号转正常号 － 去除4位间的空格*/
-(NSString *)bankNumberToNormalNumberMu;

/**处理银行卡 格式为****1234保留最后4位*/
- (NSString *)securityBankCardMu;

/**中间的用*替代*/
- (NSString *)stringByReplacingIndex:(NSUInteger)index count:(NSUInteger)count withString:(NSString *)aString;

/*邮箱*/
- (BOOL)validateEmailMu;

/*车牌号验证*/
- (BOOL)validateCarNoMu;

/*车型*/
- (BOOL)validateCarTypeMu;

/*身份证号*/
- (BOOL)validateIdentityCardMu;

/*格式化HTML代码*/
+ (NSString *)htmlEntityDecode:(NSString *)string;

/*倒计时  @"Day",@"Hour",@"Minute",@"Seconds",@"Msec",如果dictionary为nil则表示倒计时结束*/
- (void)countdownWithTimeInterval:(NSString *)timeInterval callback:(void(^)(NSDictionary *dictionary))callback;

/*字典转字符串**/
+ (NSString*)dictionaryToJson:(NSDictionary *)dict;

/*字符串转字典**/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//文字首行缩进
-(NSAttributedString *)attributesWithLineSpacing:(CGFloat)firstLineHeadIndent;

//颜色
-(NSAttributedString *)attributesWithColor:(UIColor *)color string:(NSString *)string;

//字体
-(NSAttributedString *)attributesWithFont:(UIFont *)font string:(NSString *)string;

//下划线
-(NSAttributedString *)attributesWithUnderlineColor:(UIColor *)color string:(NSString *)string;

//中划线
-(NSAttributedString *)attributesWithStrikethroughlineColor:(UIColor *)color string:(NSString *)string;
@end
