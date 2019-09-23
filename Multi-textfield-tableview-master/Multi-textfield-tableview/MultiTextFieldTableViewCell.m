//
//  MultiTextFieldTableViewCell.m
//  Multi-textfield-tableview
//
//  Created by mcf on 2019/3/31.
//  Copyright © 2019 mcf. All rights reserved.
//

#import "MultiTextFieldTableViewCell.h"

NSString * const MultiTextFieldIdentifier = @"MultiTextFieldIdentifier";

@implementation MultiTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.inputView = [[UITextField alloc] init];
    self.inputView.delegate = self;
    self.inputView.placeholder = @"tap here to input ";
    [self.inputView addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.inputView];
    
    return self;
}

- (void)textDidChanged:(UITextField *)field {
    if ([self.delegate respondsToSelector:@selector(multiTextFieldCell:inputDidChanged:)]) {
        [self.delegate multiTextFieldCell:self inputDidChanged:field.text];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.inputView.frame = CGRectMake(150, 7, self.contentView.bounds.size.width - 180, 30);
    self.textLabel.frame = CGRectMake(10, 7, 130, 30);
}

@end
