//
//  MultiTextFieldTableViewCell.h
//  Multi-textfield-tableview
//
//  Created by mcf on 2019/3/31.
//  Copyright © 2019 mcf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const MultiTextFieldIdentifier;

@class MultiTextFieldTableViewCell;

@protocol MultiTextFielDelegate <NSObject>

- (void)multiTextFieldCell:(MultiTextFieldTableViewCell *)cell inputDidChanged:(NSString *)text;

@end

@interface MultiTextFieldTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, weak) id <MultiTextFielDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
