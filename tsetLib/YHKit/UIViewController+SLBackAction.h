

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerDelegate <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (SLBackAction)<BackButtonHandlerDelegate>

@end
