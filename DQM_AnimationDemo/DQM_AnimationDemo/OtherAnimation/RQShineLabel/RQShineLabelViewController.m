//
//  RQShineLabelViewController.m
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/24.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "RQShineLabelViewController.h"
#import "RQShineLabel.h"

@interface RQShineLabelViewController ()
@property (strong, nonatomic) RQShineLabel *shineLabel;
@property (strong, nonatomic) NSArray *textArray;
@property (assign, nonatomic) NSUInteger textIndex;
@property (strong, nonatomic) UIImageView *wallpaper1;
@property (strong, nonatomic) UIImageView *wallpaper2;
@end

@implementation RQShineLabelViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  //点击屏幕即可显示下一个
  
  
  _textArray = @[
                 @"For something this complicated, it’s really hard to design products by focus groups. A lot of times, people don’t know what they want until you show it to them.",
                 @"We’re just enthusiastic about what we do.",
                 @"We made the buttons on the screen look so good you’ll want to lick them."
                 ];
  _textIndex  = 0;
  
  self.wallpaper1 = ({
    UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper1"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.view.bounds;
    imageView;
  });
  [self.view addSubview:self.wallpaper1];
  
  self.wallpaper2 = ({
    UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper2"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.view.bounds;
    imageView.alpha = 0;
    imageView;
  });
  [self.view addSubview:self.wallpaper2];
  
  self.shineLabel = ({
    RQShineLabel *label = [[RQShineLabel alloc] initWithFrame:CGRectMake(16, 16, 320 - 32, CGRectGetHeight(self.view.bounds) - 16)];
    label.numberOfLines = 0;
    label.text = [self.textArray objectAtIndex:self.textIndex];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    label.center = self.view.center;
    label;
  });
  [self.view addSubview:self.shineLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.shineLabel shine];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesBegan:touches withEvent:event];
  if (self.shineLabel.isVisible) {
    [self.shineLabel fadeOutWithCompletion:^{
      [self changeText];
      [UIView animateWithDuration:2.5 animations:^{
        if (self.wallpaper1.alpha > 0.1) {
          self.wallpaper1.alpha = 0;
          self.wallpaper2.alpha = 1;
        }
        else {
          self.wallpaper1.alpha = 1;
          self.wallpaper2.alpha = 0;
        }
      }];
      [self.shineLabel shine];
    }];
  }
  else {
    [self.shineLabel shine];
  }
}

- (void)changeText
{
  self.shineLabel.text = self.textArray[(++self.textIndex) % self.textArray.count];
}



#pragma mark - statusBar Style
-(UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}



#pragma mark - navibar
-(BOOL)navUIBaseViewControllerIsNeedNavBar:(DQMNavUIBaseViewController *)navUIBaseViewController
{
  return true;
}

- (UIColor *)dqmNavigationBackgroundColor:(DQMNavigationBar *)navigationBar
{
  return [UIColor clearColor];
}

- (NSMutableAttributedString *)dqmNavigationBarTitle:(DQMNavigationBar *)navigationBar
{
  return [QMSGeneralHelpers changeStringToMutableAttributedStringTitle:self.title font:kQmBoldFont(16) rangeOfFont:NSMakeRange(0, self.title.length) color:UIColor.whiteColor colorOfFont:NSMakeRange(0, self.title.length)];;
}

- (BOOL)dqmNavigationIsHideBottomLine:(DQMNavigationBar *)navigationBar
{
  return true;
}


@end
