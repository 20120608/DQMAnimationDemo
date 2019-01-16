//
//  DQMFoldingTableViewController.m
//  QM_FoldingTableViewDemo
//
//  Created by 漂读网 on 2018/12/18.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "DQMFoldingTableViewController.h"
#import "DQMListExpendHeaderView.h"
#import "UIViewAnimationViewController.h"                 //基础动画
#import "RQShineLabelViewController.h"                    //不规则出现和隐藏的Label
#import "CABaseAnimationViewController.h"                 //基础动画
#import "CABaseKeyFrameViewController.h"                  //关键帧动画
#import "AndroidActivityPushViewController.h"             //仿安卓转场

@interface DQMFoldingTableViewController ()

/** section的数组 */
@property (nonatomic, strong) NSMutableArray<DQMGroup *> *groups;

@end

@implementation DQMFoldingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  UIView *animationView = ({
    UIView *view = [[UIView alloc] init];
    [self.dqm_navgationBar addSubview: view];
    view.backgroundColor = QMHexColor(@"999999");
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.view.mas_centerX).offset(10);
      make.top.mas_equalTo(20).offset(10);
      make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    view;
  });
  
}


#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.groups.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // 关键
  return self.groups[section].isOpened ? self.groups[section].teams.count : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return self.groups[section].name;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *const ID = @"team";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  
  if (!cell) {
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    
  }
  
  cell.detailTextLabel.text = self.groups[indexPath.section].teams[indexPath.row].sortNumber;
  cell.textLabel.text = self.groups[indexPath.section].teams[indexPath.row].name;
  
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  DQMListExpendHeaderView *headerView = [DQMListExpendHeaderView headerViewWithTableView:tableView];
  
  headerView.group = self.groups[section];
  QMWeak(self);
  [headerView setSelectGroup:^BOOL{
    
    weakself.groups[section].isOpened = !weakself.groups[section].isOpened;
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

    return weakself.groups[section].isOpened;
  }];
  
  return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 44;
}


#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.groups[indexPath.section].teams[indexPath.row].destVc) {
    DQMBaseViewController *vc = [[self.groups[indexPath.section].teams[indexPath.row].destVc alloc] initWithTitle:self.groups[indexPath.section].teams[indexPath.row].name];
    if ([vc isKindOfClass:[DQMBaseViewController class]]) {
     
      [self.navigationController pushViewController:vc animated:true];
    }
    
  }
}



#pragma mark - dataSource
- (NSMutableArray<DQMGroup *> *)groups
{
  if (_groups == nil) {
    _groups = [NSMutableArray array];
    
    self.addItem([DQMTeam initTeamWithName:@"[UIView beginAnimations: context:]" sortNumber:@"0" destVc:[UIViewAnimationViewController class] extensionDictionary:nil], @"UIView动画", 0)
    .addItem([DQMTeam initTeamWithName:@"基础CABase动画" sortNumber:@"0" destVc:[CABaseAnimationViewController class] extensionDictionary:nil], @"CABaseAnimation", 1)
    .addItem([DQMTeam initTeamWithName:@"关键帧动画" sortNumber:@"1" destVc:[CABaseKeyFrameViewController class] extensionDictionary:nil], @"CABaseAnimation", 1)
    .addItem([DQMTeam initTeamWithName:@"pop动画" sortNumber:@"0" destVc:[CABaseKeyFrameViewController class] extensionDictionary:nil], @"pop动画", 2)
    
    
    
    
    .addItem([DQMTeam initTeamWithName:@"RQShineLabel" sortNumber:@"0" destVc:[RQShineLabelViewController class] extensionDictionary:nil], @"其他", 2)
    .addItem([DQMTeam initTeamWithName:@"安卓activity转场" sortNumber:@"1" destVc:[AndroidActivityPushViewController class] extensionDictionary:nil], @"其他", 2);

  }
  return _groups;
}




#pragma mark - 用点语法添加每组每单元的数据
-(DQMFoldingTableViewController *(^)(DQMTeam *item, NSString *name, int section))addItem {
  QMWeak(self);
  return  ^DQMFoldingTableViewController *(DQMTeam *item, NSString *name, int section) {
    if (self.groups.count <= section) {
      [self.groups addObject:[DQMGroup sectionWithItems:@[] andHeaderTitle:@"组头" footerTitle:@"组尾" name:name]];
    }
    [weakself.groups[section].teams addObject:item];
    return weakself;
  };
}



@end
