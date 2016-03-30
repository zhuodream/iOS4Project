//
//  ZYXViewController.m
//  ZYXQuiz
//
//  Created by 卓酉鑫 on 16/2/19.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXViewController.h"

@interface ZYXViewController ()

@property (nonatomic, assign) int currentQuestionIndex;

@property (nonatomic, strong) NSArray *questionArr;
@property (nonatomic, strong) NSArray *answerArr;

@property (nonatomic, weak) IBOutlet UILabel *qustionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;

@end

@implementation ZYXViewController

//xib文件会调用该方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.questionArr = @[@"What's 7+7?", @"What's 8+8?", @"What's 9+9?"];
        self.answerArr = @[@"14", @"16", @"18"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showQuestion:(id)sender
{
    self.currentQuestionIndex++;
    if (self.currentQuestionIndex == self.questionArr.count)
    {
        self.currentQuestionIndex = 0;
    }
    
    NSString *question = self.questionArr[self.currentQuestionIndex];
    self.qustionLabel.text = question;
    
    self.answerLabel.text = @"???";
}

- (IBAction)showAnswer:(id)sender
{
    NSString *answer = self.answerArr[self.currentQuestionIndex];
    self.answerLabel.text = answer;
}

@end
