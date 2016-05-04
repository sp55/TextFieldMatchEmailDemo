//
//  ViewController.m
//  TextFieldMatchEmailDemo
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray * hzArr;//后缀数组
@property(nonatomic,strong)NSMutableArray * dataArray;//匹配中的数组
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadhzArr];
}
-(void)loadhzArr
{
    //后缀数组
    _hzArr = @[@"@qq.com", @"@163.com", @"@126.com", @"@gmail.com", @"@sina.com",
               @"@sohu.com", @"@foxmail.com"];
}


//initUI
- (void)initUI
{   _dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    _tf = [[UITextField alloc] init];
    _tf.borderStyle = UITextBorderStyleBezel;
    _tf.placeholder = @"请输入邮箱";
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tf.frame = CGRectMake(10,80,self.view.frame.size.width-20,50);
    [self.view addSubview:_tf];
    _tf.delegate = self;
    // email后缀列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,150,self.view.frame.size.width-20,120)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
}
#pragma mark 文本框字符变化时
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //编辑的时候修改数据源
    self.tableView.hidden = NO; //文本变化  不隐藏
    if (!range.length) //如果长度为不为0
    {
        NSLog(@"length长度为不为0");
        [_dataArray removeAllObjects];
        [_hzArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * ppString = [textField.text stringByAppendingString:[NSString stringWithFormat:@"%@%@",string,obj]];
//            NSLog(@"string=%@  obj=%@",string,obj);
            [self.dataArray addObject:ppString];
        }];
    }
    else
    {
        NSLog(@"length长度为0");
        [_dataArray removeAllObjects];
        if (textField.text.length - 1 == 0) {//文本长度 = 1 再删除 就隐藏tableView
            self.tableView.hidden = YES;
        }else{
            [_hzArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *matchStr = [textField.text substringToIndex:(textField.text.length - 1)];
                NSString * ppString = [NSString stringWithFormat:@"%@%@",matchStr,obj];
//                NSLog(@"matchStr=%@  obj=%@",matchStr,obj);
                [self.dataArray addObject:ppString];
            }];
        }
    }
    [self.tableView reloadData];
    return YES;
}
//清空隐藏
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.tableView.hidden = YES;
    return YES;
}
// 进入编辑状态是否需要匹配
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.text.length != 0)
    {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
    return YES;
}

#pragma mark dataSource method and delegate method

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor cyanColor];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 30;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 将完整email填入输入框
    self.tf.text = self.dataArray[indexPath.row];
    self.tableView.hidden = YES;
}
//收键盘  隐藏tableView
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.tableView.hidden = YES;
}

@end
