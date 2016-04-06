//
//  ZYXDetailViewController.m
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/3/14.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXDetailViewController.h"
#import "ZYXItem.h"
#import "ZYXImageStore.h"

@interface ZYXDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *serialTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbar;

@end

@implementation ZYXDetailViewController

//- (void)viewDidLayoutSubviews
//{
//    for (UIView *subview in self.view.subviews)
//    {
//        if ([subview hasAmbiguousLayout])
//        {
//            NSLog(@"AMBIGUOUS: %@", subview);
//        }
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCameraOverlayView:) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCameraOverlayView:) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
}

- (void)hideCameraOverlayView:(NSNotification *)notiifcation
{
    NSLog(@"显示或关闭");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameTextField.text = self.item.itemName;
    self.serialTextField.text = self.item.serialNumber;
    self.valueTextField.text = [NSString stringWithFormat:@"%d", self.item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:[self.item dateCreated]];
    
    NSString *itemKey = self.item.itemKey;
    
    UIImage *imageToDisplay = [[ZYXImageStore sharedStore] imageForKey:itemKey];
    self.imageView.image = imageToDisplay;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    self.item.itemName = self.nameTextField.text;
    self.item.serialNumber = self.serialTextField.text;
    self.item.valueInDollars = [self.valueTextField.text intValue];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)setItem:(ZYXItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
    
//    for (UIView *subview in self.view.subviews)
//    {
//        if ([subview hasAmbiguousLayout])
//        {
//            [subview exerciseAmbiguityInLayout];
//        }
//    }
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        UIView *cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        cameraView.backgroundColor = [UIColor redColor];
        imagePicker.cameraOverlayView = cameraView;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [[ZYXImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
