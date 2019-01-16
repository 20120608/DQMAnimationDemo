//
//  CABaseAnimationViewController.m
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/25.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "CABaseAnimationViewController.h"

@interface CABaseAnimationViewController ()

/** 动画的视图 */
@property(nonatomic,strong) UIView          *redView;




@end

@implementation CABaseAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
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
  
  NSArray *btnTitleArray = [[NSArray alloc] initWithObjects:@"位移",@"透明度",@"缩放",@"旋转",@"背景色", nil];
  NSMutableArray *btnArr = [[NSMutableArray alloc] init];
  for (int i = 0; i < btnTitleArray.count; i++) {
    UIButton *button = ({
      UIButton *button = [[UIButton alloc] init];
      button.tag = i;
      [self.view addSubview:button];
      [button setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
      [button setTitle:btnTitleArray[i] forState:UIControlStateNormal];
      [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
      button;
    });
    [btnArr addObject:button];
  }
  [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:10 tailSpacing:10];
  [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(30);
    make.bottom.mas_equalTo(self.view.mas_bottom).offset(-1-HOME_INDICATOR_HEIGHT);
  }];
}

- (void)click:(UIButton *)sender {
  switch (sender.tag) {
    case 0:
      [self makePositionAnimation];
      break;
    case 1:
      [self makeOpacityAnimation];
      break;
    case 2:
      [self makeScaleAnimation];
      break;
    case 3:
      [self makeRotateAnimation];
      break;
    case 4:
      [self makeBackgroundAnimation];
      break;
    default:
      break;
  }
}

/*
 l 是所有动画对象的父类，负责控制动画的持续时间和速度，是个抽象类，不能直接使用，应该使用它具体的子类
 
 - duration：动画的持续时间
 
 - repeatCount：重复次数，无限循环可以设置HUGE_VALF或者MAXFLOAT
 
 - repeatDuration：重复时间
 
 - removedOnCompletion：默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，同时还要设置fillMode为kCAFillModeForwards
 
 - fillMode：决定当前对象在非active时间段的行为。比如动画开始之前或者动画结束之后
 
 - beginTime：可以用来设置动画延迟执行时间，若想延迟2s，就设置为CACurrentMediaTime()+2，CACurrentMediaTime()为图层的当前时间
 
 - timingFunction：速度控制函数，控制动画运行的节奏
 
 - autoreverses  动画结束时是否执行逆动画
 
 - delegate：动画代理
 */

//位移
-(void)makePositionAnimation {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, kScreenHeight/2)];
  animation.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth-50, kScreenHeight/2)];
  animation.duration = 1.0;
  animation.fillMode = kCAFillModeBoth;
  animation.removedOnCompletion = NO;
  animation.autoreverses = true;
  animation.repeatCount = MAXFLOAT;
  [self.redView.layer addAnimation:animation forKey:@"positionAnimation"];
  
}

//透明度
-(void)makeOpacityAnimation{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation.fromValue = [NSNumber numberWithFloat:1.0f];
  animation.toValue = [NSNumber numberWithFloat:0.5f];
  animation.duration = 1.0f;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  animation.repeatCount = MAXFLOAT;
  animation.autoreverses = true;
  [self.redView.layer addAnimation:animation forKey:@"opacityAnimation"];
}

//缩放
-(void)makeScaleAnimation{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  animation.toValue = [NSNumber numberWithFloat:2.0f];
  animation.duration = 1.0f;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  animation.repeatCount = MAXFLOAT;
  animation.autoreverses = true;
  [self.redView.layer addAnimation:animation forKey:@"scaleAnimation"];
}

//旋转
-(void)makeRotateAnimation{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  animation.toValue = [NSNumber numberWithFloat:M_PI];
  animation.duration = 1.0f;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  animation.repeatCount = MAXFLOAT;
  animation.autoreverses = true;
  [self.redView.layer addAnimation:animation forKey:@"rotateAnimation"];
}

//背景色变化
-(void)makeBackgroundAnimation{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
  animation.toValue = (id)[UIColor greenColor].CGColor;
  animation.duration = 1.0f;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  animation.repeatCount = MAXFLOAT;
  animation.autoreverses = true;
  [self.redView.layer addAnimation:animation forKey:@"backgroundAnimation"];
}


@end
