//
//  AndroidDetailViewController.m
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/26.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "AndroidDetailViewController.h"

@interface AndroidDetailViewController ()

@end

@implementation AndroidDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
  self.view.backgroundColor = [UIColor orangeColor];
  
  UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2, kScreenWidth, kScreenHeight/2)];
  blueView.backgroundColor = [UIColor blueColor];
  [self.view addSubview:blueView];
  
  self.bigImageView =  ({
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview: imageView];
    imageView.hidden = true;
    imageView.image = [UIImage imageNamed:@"pkq"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.view.mas_centerX);
      make.centerY.mas_equalTo(self.view.mas_centerY);
      make.size.mas_equalTo(CGSizeMake(180, 180));
    }];
    imageView;
  });
  
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
