//
//  CABaseKeyFrameViewController.m
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/25.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "CABaseKeyFrameViewController.h"

@interface CABaseKeyFrameViewController ()

/** 动画的视图 */
@property(nonatomic,strong) UIView          *redView;

@end

@implementation CABaseKeyFrameViewController

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
  
  NSArray *btnTitleArray = [[NSArray alloc] initWithObjects:@"关键帧",@"路径",@"抖动", nil];
  NSMutableArray *btnArr = [[NSMutableArray alloc] init];
  for (int i = 0; i < btnTitleArray.count; i++) {
    UIButton *button = ({
      UIButton *button = [[UIButton alloc] init];
      button.tag = i;
      [self.view addSubview:button];
      [button setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
      [button setTitle:btnTitleArray[i] forState:UIControlStateNormal];
      [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)btnClicked:(UIButton *)sender {
  switch (sender.tag) {
    case 0:
      [self makeKeyFrameAnimation];
      break;
    case 1:
      [self makePathAnimation];
      break;
    case 2:
      [self makeShakeAnimation];
      break;
    default:
      break;
  }
}

//关键帧动画
-(void)makeKeyFrameAnimation{
  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  NSValue *value_0 = [NSValue valueWithCGPoint:CGPointMake(50, kScreenHeight/2-50)];
  NSValue *value_1 = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/3, kScreenHeight/2-50)];
  NSValue *value_2 = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/3, kScreenHeight/2+50)];
  NSValue *value_3 = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth*2/3, kScreenHeight/2+50)];
  NSValue *value_4 = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth*2/3, kScreenHeight/2-50)];
  NSValue *value_5 = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth-50, kScreenHeight/2-50)];
  animation.values = [NSArray arrayWithObjects:value_0,value_1,value_2,value_3,value_4,value_5, nil];
  animation.duration = 2.0f;
  [self.redView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

//路径
-(void)makePathAnimation{
  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2) radius:60 startAngle:0.0f endAngle:M_PI*2 clockwise:YES];
  animation.duration = 2.0f;
  animation.path = path.CGPath;
  [self.redView.layer addAnimation:animation forKey:@"pathAnimation"];
}

//抖动动画
-(void)makeShakeAnimation{
  CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
  NSValue *value_0 = [NSNumber numberWithFloat:-M_PI/180*4];
  NSValue *value_1 = [NSNumber numberWithFloat:M_PI/180*4];
  NSValue *value_3 = [NSNumber numberWithFloat:-M_PI/180*4];
  anima.values = @[value_0,value_1,value_3];
  anima.repeatCount = MAXFLOAT;
  [self.redView.layer addAnimation:anima forKey:@"shakeAnimation"];
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
