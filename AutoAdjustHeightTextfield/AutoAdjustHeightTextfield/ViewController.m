//
//  ViewController.m
//  AutoAdjustHeightTextfield
//
//  Created by suning on 2019/9/24.
//  Copyright © 2019 Personal. All rights reserved.
//

#import "ViewController.h"
#import "UIView+YYAdd.h"

@interface UIScrollView (KeyBoard)

@end

@implementation UIScrollView(KeyBoard)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    for (UIView *sub in self.subviews) {
        
        if ([sub isKindOfClass:[UITextField class]]) {
            UITextField *input = (UITextField *)sub;
            [input resignFirstResponder];
        }
    }
}

@end

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *board;

@property (nonatomic, weak) UITextField *fistField;;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, strong) NSMutableArray *textfields;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIScrollView *board = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    board.contentSize = CGSizeMake(0, CGRectGetWidth(self.view.bounds));
    board.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:board];
    _board = board;
    
    _textfields = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat gap = 50.0f;
    
    for (int i = 0; i < 5; i++) {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(20, 100 + i*gap, self.view.width - 40.0f, 40)];
        [field addTarget:self action:@selector(textInputChanged:) forControlEvents:UIControlEventEditingChanged];
        field.returnKeyType = (i == 4) ? UIReturnKeyDone : UIReturnKeyNext;
        field.placeholder = @"请输入文字";
        field.delegate = self;
        [board addSubview:field];
        field.tag = i;
        [_textfields addObject:field];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSLog(@"=== %@", [NSValue valueWithCGRect:textField.frame]);
    self.fistField = textField;
    
    if (_keyBoardHeight > 0) {
        [self boardAutoAdjust:_keyBoardHeight];
    }
    return YES;
}

- (void)boardAutoAdjust:(CGFloat)keyboardHeight {
    
    if (self.fistField) {
        
        CGRect rec = _fistField.frame;
        
        CGFloat max_y = CGRectGetMaxY(rec);
        
        CGFloat b_offset = self.view.height - max_y - keyboardHeight;
        
        CGPoint point = self.board.contentOffset;
        point.y = -b_offset;
        
        [self.board setContentOffset:point animated:YES];
    }
}



- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    _keyBoardHeight = kbHeight;
    [self boardAutoAdjust:kbHeight];
}

- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    _keyBoardHeight = 0;
    [self.board setContentOffset:CGPointMake(0,-64) animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)textInputChanged:(UITextField *)sender {
    
    NSLog(@"=== %ld", (long)sender.tag);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        
        [textField resignFirstResponder];
        UITextField *next = [self.textfields objectAtIndex:(textField.tag + 1)];
        [next becomeFirstResponder];
        
    } else if (textField.returnKeyType == UIReturnKeyDone) {
        
        [textField resignFirstResponder];
    }
    
    return YES;;
}

@end
