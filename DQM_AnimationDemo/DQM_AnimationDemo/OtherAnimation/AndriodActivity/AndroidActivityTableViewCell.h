//
//  AndroidActivityTableViewCell.h
//  DQM_AnimationDemo
//
//  Created by 漂读网 on 2018/12/25.
//  Copyright © 2018 漂读网. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AndroidActivityTableViewCell : UITableViewCell

/** 头像 */
@property(nonatomic,strong) UIImageView          *headerImageView;
/** 名称 */
@property(nonatomic,strong) UILabel              *nameLabel;

+(AndroidActivityTableViewCell *)cellWithTableView:(UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
