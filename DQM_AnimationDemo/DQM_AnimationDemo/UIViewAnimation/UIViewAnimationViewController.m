//
//  UIViewAnimationViewController.m
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/24.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "UIViewAnimationViewController.h"

@interface UIViewAnimationViewController ()

/** 动画的视图 */
@property(nonatomic,strong) UIView          *redView;

/** 动画时间选择 */
@property(nonatomic,strong) UISegmentedControl          *timeIntervalSegmentedControl;
/** 动画延迟时间选择 */
@property(nonatomic,strong) UISegmentedControl          *delayIntervalSegmentedControl;
/** 动画曲线 */
@property(nonatomic,strong) UISegmentedControl          *viewAnimationCurveSegmentedControl;

/** NO:repeatCount= 1   TRUE: repeatCount= MAXFLOAT */
@property(nonatomic,strong) UISwitch                    *alwayscycleSwitch;
/** 是否执行反向操作 */
@property(nonatomic,strong) UISwitch                    *repeatAutoreversesSwitch;

//动画参数

/** 动画持续时间 */
@property (nonatomic,assign) NSTimeInterval                                         timeInterval;
/** 动画延迟时间 */
@property (nonatomic,assign) NSTimeInterval                                         delayInterval;
/** 执行次数 */
@property (nonatomic,assign) float                                                  repeatCount;
/** 动画的曲线
 UIViewAnimationCurve的枚举值：
 UIViewAnimationCurveEaseInOut,         // 慢进慢出（默认值）
 UIViewAnimationCurveEaseIn,            // 慢进
 UIViewAnimationCurveEaseOut,           // 慢出
 UIViewAnimationCurveLinear             // 匀速
 */
@property (nonatomic,assign) UIViewAnimationCurve                                   viewAnimationCurve;
/** 设置是否从当前状态开始播放动画
 假设上一个动画正在播放，且尚未播放完毕，我们将要进行一个新的动画：
 当为YES时：动画将从上一个动画所在的状态开始播放
 当为NO时：动画将从上一个动画所指定的最终状态开始播放,此时上一个动画马上结束
 */
@property (nonatomic,assign) BOOL                                                   fromCurrentState;
/** 在结束后是否执行反向动画 */
@property (nonatomic,assign) BOOL                                                   repeatAutoreverses;
/** 是否禁用动画效果（对象属性依然会被改变，只是没有动画效果） */
@property (nonatomic,assign) BOOL                                                   animationsEnabled;
/** 是否开启旋转翻页动画 */
@property (nonatomic,assign) BOOL                                                   openTransitionAnimation;
/**
 UIViewAnimationTransitionNone,              //不使用动画
 UIViewAnimationTransitionFlipFromLeft,      //从左向右旋转翻页
 UIViewAnimationTransitionFlipFromRight,     //从右向左旋转翻页
 UIViewAnimationTransitionCurlUp,            //从下往上卷曲翻页
 UIViewAnimationTransitionCurlDown,          //从上往下卷曲翻页
 */
@property (nonatomic,assign) UIViewAnimationTransition                              animationTransition;
/** 需要过渡效果的View */
@property (nonatomic,strong) UIView                                                 *animationForView;
/** 是否使用视图缓存，YES：视图在开始和结束时渲染一次；NO：视图在每一帧都渲染 */
@property (nonatomic,assign) BOOL                                                   cache;

/** 动画起始位置 */
@property(nonatomic,assign) CGPoint          beginPoint;
/** 动画目标位置 */
@property(nonatomic,assign) CGPoint          endPoint;


@end

@implementation UIViewAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationStartAgainIfNeed) name:UIApplicationDidBecomeActiveNotification object:nil];
  
  self.redView = ({
    UIView *view = [[UIView alloc] init];
    [self.view addSubview: view];
    view.backgroundColor = QMHexColor(@"ff0000");
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.view.mas_centerX);
      make.centerY.mas_equalTo(self.view.mas_centerY);
      make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    view;
  });
  
  //初始化动画
  [self initAnimationCode];
  
  [self createUI];
}

- (void)initAnimationCode {
  self.timeInterval = 3;
  self.delayInterval = 0;
  self.repeatCount = 1.0;
  self.viewAnimationCurve = UIViewAnimationCurveEaseInOut;
  self.fromCurrentState = true;
  self.repeatAutoreverses = false;
  self.animationsEnabled = true;
  self.openTransitionAnimation = true;
  self.animationTransition = UIViewAnimationTransitionNone;
  self.animationForView = self.redView;
  self.cache = true;
  
}

/** 接口说明 */
//- (void)setUIViewAnimation {
//
//  [UIView setAnimationDuration:_timeInterval];//动画持续时间
//  [UIView setAnimationWillStartSelector:@selector(ViewAnimationWillStart)];//设置动画将开始时代理对象执行的SEL
//  [UIView setAnimationDelay:_delayInterval];//设置动画延迟执行的时间
//  [UIView setAnimationRepeatCount:_repeatCount];//设置动画的重复次数
//  [UIView setAnimationCurve:_viewAnimationCurve];//动画曲线
//  [UIView setAnimationBeginsFromCurrentState:_fromCurrentState];//设置是否从当前状态开始播放动画
//  [UIView setAnimationRepeatAutoreverses:_repeatAutoreverses];//设置动画是否继续执行相反的动画
//  [UIView setAnimationsEnabled:_animationsEnabled];//是否禁用动画效果（对象属性依然会被改变，只是没有动画效果）
//  [UIView setAnimationTransition:_animationTransition forView:self.animationForView cache:_cache];//设置视图的过渡效果
//
//}


- (void)createUI {
  
  //时间选择
  self.timeIntervalSegmentedControl = ({
    NSArray *arr = [[NSArray alloc]initWithObjects:@"持续:",@"1s",@"2s",@"3s",@"4s",@"5s",@"6s", nil];
    UISegmentedControl *view = [[UISegmentedControl alloc] initWithItems:arr];
    [self.view addSubview: view];
    [view addTarget:self action:@selector(timeIntervalSegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.view.mas_left).offset(10);
      make.right.mas_equalTo(self.view.mas_right).offset(-10);
      make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10-HOME_INDICATOR_HEIGHT);
      make.height.mas_equalTo(30);
    }];
    view.backgroundColor = QMHexColor(@"ffffff");
    view;
  });
  
  //延时执行
  self.delayIntervalSegmentedControl = ({
    NSArray *arr = [[NSArray alloc]initWithObjects:@"延时:",@"1s",@"2s",@"3s",@"4s",@"5s",@"6s", nil];
    UISegmentedControl *view = [[UISegmentedControl alloc] initWithItems:arr];
    [self.view addSubview: view];
    [view addTarget:self action:@selector(delayIntervalSegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.view.mas_left).offset(10);
      make.right.mas_equalTo(self.view.mas_right).offset(-10);
      make.bottom.mas_equalTo(self.timeIntervalSegmentedControl.mas_top).offset(-5);
      make.height.mas_equalTo(30);
    }];
    view.backgroundColor = QMHexColor(@"ffffff");
    view;
  });
  
  /** 动画曲线 */
  self.viewAnimationCurveSegmentedControl = ({
    NSArray *arr = [[NSArray alloc]initWithObjects:@"动画曲线:",@"EaseInOut",@"EaseIn",@"EaseOut",@"Linear", nil];
    UISegmentedControl *view = [[UISegmentedControl alloc] initWithItems:arr];
    [self.view addSubview: view];
    [view addTarget:self action:@selector(viewAnimationCurveSegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.view.mas_left).offset(10);
      make.right.mas_equalTo(self.view.mas_right).offset(-10);
      make.bottom.mas_equalTo(self.delayIntervalSegmentedControl.mas_top).offset(-5);
      make.height.mas_equalTo(30);
    }];
    view.backgroundColor = QMHexColor(@"ffffff");
    view;
  });
  

  
  UIView *alwayscycleView = ({
    UIView *view = [[UIView alloc] init];
    [self.view addSubview: view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.view.mas_left).offset(10);
      make.bottom.mas_equalTo(self.viewAnimationCurveSegmentedControl.mas_top).offset(-5);
    }];
    
    UILabel *label = ({
      UILabel *label = [[UILabel alloc] init];
      [view addSubview:label];
      label.text = @"无限循环:";
      label.textColor = QMTextColor;
      label.font = kQmBoldFont(14);
      [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.centerY.mas_equalTo(view.mas_centerY);
      }];
      label;
    });
    
    //使用重复循环执行
    self.alwayscycleSwitch = ({
      UISwitch *alwayscycleSwitch = [[UISwitch alloc] init];
      [view addSubview: alwayscycleSwitch];
      [alwayscycleSwitch addTarget:self action:@selector(alwayscycleSwitchClick:) forControlEvents:UIControlEventValueChanged];
      [alwayscycleSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(5);
        make.right.mas_equalTo(view.mas_right);
        make.top.mas_equalTo(view.mas_top);
        make.bottom.mas_equalTo(view.mas_bottom);
      }];
      alwayscycleSwitch;
    });
    view.backgroundColor = QMHexColor(@"ffffff");
    view;
  });
  
  
  UIView *repeatAutoreversesView = ({
    UIView *view = [[UIView alloc] init];
    [self.view addSubview: view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(alwayscycleView.mas_right).offset(10);
      make.top.mas_equalTo(alwayscycleView.mas_top);
    }];
    
    UILabel *label = ({
      UILabel *label = [[UILabel alloc] init];
      [view addSubview:label];
      label.text = @"执行反向:";
      label.textColor = QMTextColor;
      label.font = kQmBoldFont(14);
      [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.centerY.mas_equalTo(view.mas_centerY);
      }];
      label;
    });
    
    //使用重复循环执行
    self.repeatAutoreversesSwitch = ({
      UISwitch *repeatAutoreversesSwitch = [[UISwitch alloc] init];
      [view addSubview: repeatAutoreversesSwitch];
      [repeatAutoreversesSwitch addTarget:self action:@selector(repeatAutoreversesSwitchClick:) forControlEvents:UIControlEventValueChanged];
      [repeatAutoreversesSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(5);
        make.right.mas_equalTo(view.mas_right);
        make.top.mas_equalTo(view.mas_top);
        make.bottom.mas_equalTo(view.mas_bottom);
      }];
      repeatAutoreversesSwitch;
    });
    
    view;
  });
  repeatAutoreversesView.backgroundColor = QMHexColor(@"ffffff");

  
}


#pragma mark - chooseSetting
/**
 选择动画执行时间间隔
 */
-(void)timeIntervalSegmentedControlClick:(UISegmentedControl *)sender {
  _timeInterval = sender.selectedSegmentIndex+1;
}
/**
动画延迟时间选择
 */
-(void)delayIntervalSegmentedControlClick:(UISegmentedControl *)sender {
  _delayInterval = sender.selectedSegmentIndex+1;
}

/**
 动画曲线
 */
-(void)viewAnimationCurveSegmentedControlClick:(UISegmentedControl *)sender {
  if (sender.selectedSegmentIndex == 0) {
    _viewAnimationCurve = UIViewAnimationCurveEaseInOut;
  } else {
    _viewAnimationCurve = sender.selectedSegmentIndex - 1;
  }
}


/**
 是否无限循环
 */
- (void)alwayscycleSwitchClick:(UISwitch *)sender {
  _repeatCount = sender.isOn ? MAXFLOAT : 1;
}

/**
 是否无限循环
 */
- (void)repeatAutoreversesSwitchClick:(UISwitch *)sender {
  _repeatAutoreverses = sender.isOn;
}



#pragma mark - use touching to start
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
  /**
   UIView beginAnimations  缺点是如果退回到后台再进入动画会暂停   需要重新设置代码才能继续动画
   */
  
  UITouch *tuch = touches.anyObject;
  CGPoint point = [tuch locationInView:self.view];
  
  self.beginPoint = self.redView.center;
  self.endPoint = point;

  [UIView beginAnimations:@"testAnimation" context:nil];
  [UIView setAnimationDuration:_timeInterval];
  [UIView setAnimationDelegate:self];
  
  //设置动画延迟执行的时间
  [UIView setAnimationDelay:_delayInterval];

  [UIView setAnimationRepeatCount:_repeatCount];
  [UIView setAnimationCurve:_viewAnimationCurve];
  //设置动画是否继续执行相反的动画
  [UIView setAnimationRepeatAutoreverses:_repeatAutoreverses];
  
  _animationForView.center = point;
  _animationForView.transform = CGAffineTransformMakeRotation(M_PI);
  _animationForView.transform = CGAffineTransformMakeScale(1.5, 1.5);

  [UIView commitAnimations];
  
}

/**
 界面重新进入后需要重新执行吗 (只有重复次数为无限大才需要)
 */
- (void)animationStartAgainIfNeed {
  if (_repeatCount == MAXFLOAT) {
    
    _animationForView.center = self.beginPoint;
    [UIView beginAnimations:@"testAnimation" context:nil];
    [UIView setAnimationDuration:_timeInterval];
    [UIView setAnimationDelegate:self];
    
    //设置动画延迟执行的时间
    [UIView setAnimationDelay:_delayInterval];
    
    [UIView setAnimationRepeatCount:_repeatCount];
    [UIView setAnimationCurve:_viewAnimationCurve];
    //设置动画是否继续执行相反的动画
    [UIView setAnimationRepeatAutoreverses:_repeatAutoreverses];
    
    _animationForView.center = self.endPoint;
    _animationForView.transform = CGAffineTransformMakeRotation(-M_PI);
    _animationForView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    [UIView commitAnimations];
  }
}


#pragma mark - UIViewAnimation Delegate
/**
 动画即将开始
 */
- (void)animationWillStart:(NSString *)animationID context:(void *)context {
  
  NSLog(@"*** ViewAnimationWillStart ***");
}

/**
 手势结束
 */
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  NSLog(@"*** ViewAnimationDidStopSelector ***");
}







#pragma mark - navibar
/** 导航条左边的按钮 */
- (UIImage *)dqmNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(DQMNavigationBar *)navigationBar
{
  [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
  
  return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(DQMNavigationBar *)navigationBar
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
