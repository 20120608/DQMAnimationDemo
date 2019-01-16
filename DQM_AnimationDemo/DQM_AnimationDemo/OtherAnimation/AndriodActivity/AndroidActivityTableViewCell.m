//
//  AndroidActivityTableViewCell.m
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/25.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import "AndroidActivityTableViewCell.h"

@implementation AndroidActivityTableViewCell


+(AndroidActivityTableViewCell *)cellWithTableView:(UITableView *)tableView
{
  static NSString *identifier = @"AndroidActivityTableViewCell";
  AndroidActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil)
  {
    cell = [[AndroidActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.contentView.width = kScreenWidth;
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    /** 头像 */
    self.headerImageView =  ({
      UIImageView *imageView = [[UIImageView alloc] init];
      [imageView setImage:[UIImage imageNamed:@"pkq"]];
      [self.contentView addSubview: imageView];
      [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10).priority(500);//降低优先级消除警告
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
      }];
      imageView;
    });
    
    /** 名称 */
    self.nameLabel = ({
      UILabel *label = [[UILabel alloc] init];
      [self.contentView addSubview:label];
      label.text = @"小帅哥";
      label.font = [UIFont boldSystemFontOfSize:16];
      [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
      }];
      label;
    });

  }
  return self;
}
@end
