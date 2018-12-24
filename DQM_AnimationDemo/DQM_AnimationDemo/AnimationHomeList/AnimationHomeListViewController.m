//
//  AnimationHomeListViewController.m
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/24.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "AnimationHomeListViewController.h"

@interface AnimationHomeListViewController ()

@end

@implementation AnimationHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
  self.addItem([StaticListItem itemWithTitle:@"动画1" subTitle:@"subTitle" fixedCellHeight:44 itemOperation:^(NSIndexPath *indexPath) {
    
  }]);
  
  
  
}


#pragma mark - navibar delegate
- (BOOL)dqmNavigationIsHideBottomLine:(DQMNavigationBar *)navigationBar {
  return false;
}

- (BOOL)navUIBaseViewControllerIsNeedNavBar:(DQMNavUIBaseViewController *)navUIBaseViewController {
  return true;
}




@end
