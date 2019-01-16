//
//  AndroidActivityPushViewController.m
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/25.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "AndroidActivityPushViewController.h"
#import "AndroidActivityTableViewCell.h"
#import "AndroidDetailViewController.h"

const float animationDuration = 0.35; //转场时间

@interface AndroidActivityPushViewController ()

@end

@implementation AndroidActivityPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
  
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  AndroidActivityTableViewCell *cell = [AndroidActivityTableViewCell cellWithTableView:tableView];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  AndroidDetailViewController *vc = [[AndroidDetailViewController alloc] initWithTitle:@"新界面"];
  [self.navigationController pushViewController:vc animated:NO];
  
  AndroidActivityTableViewCell *cell = (AndroidActivityTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  cell.headerImageView.hidden = true;
  
  
  //新的
  UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [UIScreen mainScreen].scale);
  [vc.view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  UIImageView *newImageView = ({
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = newImage;
    imageView.alpha = 0.1;
    [self.view.window addSubview: imageView];
    imageView;
  });
  
  //原来的界面
  UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [UIScreen mainScreen].scale);
  [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  UIImageView *oldImageView = ({
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = snapshotImage;
    [self.view.window addSubview: imageView];
    imageView;
  });
  
  [UIView animateWithDuration:animationDuration animations:^{
    oldImageView.alpha = 0;
    newImageView.alpha = 1;
  }];
  
  
  CGRect startRact = [cell.headerImageView convertRect:cell.headerImageView.bounds toView:self.view.window];
  UIImageView *animationView =  ({
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:startRact];
    [self.view.window addSubview: imageView];
    imageView.image = cell.headerImageView.image;
    imageView;
  });
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.fromValue = [NSValue valueWithCGPoint:animationView.center];
  animation.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, kScreenHeight/2)];
  animation.duration = animationDuration;
  animation.fillMode = kCAFillModeBoth;
  animation.removedOnCompletion = NO;
  [animationView.layer addAnimation:animation forKey:@"positionAnimation"];
  CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  animation2.toValue = [NSNumber numberWithFloat:3.0f];
  animation2.duration = animationDuration;
  animation2.fillMode = kCAFillModeForwards;
  animation2.removedOnCompletion = NO;
  [animationView.layer addAnimation:animation2 forKey:@"scaleAnimation"];
  
  
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [oldImageView removeFromSuperview];
    [newImageView removeFromSuperview];
    [animationView removeFromSuperview];
    cell.headerImageView.hidden = false;
    vc.bigImageView.hidden = false;
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
