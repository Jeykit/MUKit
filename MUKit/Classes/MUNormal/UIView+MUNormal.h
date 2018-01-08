//
//  UIView+MUNormal.h
//  Pods
//
//  Created by Jekity on 2017/10/17.
//
//

#import <UIKit/UIKit.h>

@interface UIView (MUNormal)
+(instancetype)viewForXibMu;
+(instancetype)viewForXibMuWithIndex:(NSUInteger)index;
+(instancetype)viewForXibMuWithRetainObject:(id)object;
+(instancetype)viewForXibNOMargainMuWithRetainObject:(id)view;
+(instancetype)viewForXibNOMargaimMu;
//-(void)refreshViewLayout;
//-(void)refreshViewLayoutWith:(UITableView *)tableview;
//-(void)refreshViewLayoutNOMargain;
//-(void)refreshViewLayoutNOMargainWith:(UITableView *)tableview;
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

@interface UIButton (MUNormal)
@property(nonatomic, strong)UIColor *titleColorMu;
@property(nonatomic, copy)NSString  *titleStringMu;
@property(nonatomic, strong)UIImage *contentImageMu;
@property(nonatomic, strong)UIImage *backgroundImageMu;
@property(nonatomic, assign)CGFloat  fontSizeMu;
@property(nonatomic, assign)BOOL  swapPositionMu;//图片与标题互换位置

@property(nonatomic, strong)UIColor *highlightedTitleColorMu;
@property(nonatomic, copy)NSString  *highlightedTitleStringMu;
@property(nonatomic, strong)UIImage *highlightedContentImageMu;
@property(nonatomic, strong)UIImage *highlightedBackgroundImageMu;
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

-(NSAttributedString *)attributesWithLineSpacing:(CGFloat)firstLineHeadIndent;//文字首行缩进
-(NSAttributedString *)attributesWithColor:(UIColor *)color string:(NSString *)string;//颜色
-(NSAttributedString *)attributesWithFont:(UIFont *)font string:(NSString *)string;//字体
-(NSAttributedString *)attributesWithUnderlineColor:(UIColor *)color string:(NSString *)string;//下划线
-(NSAttributedString *)attributesWithStrikethroughlineColor:(UIColor *)color string:(NSString *)string;//中划线
@end
