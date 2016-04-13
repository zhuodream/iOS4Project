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
#import "ZYXItemStore.h"
#import "ZYXAssetTypeViewController.h"
#import "AppDelegate.h"

@interface ZYXDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, UIViewControllerRestoration>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *serialTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (nonatomic, strong) UIPopoverPresentationController *imagePopover;
//@property (nonatomic, strong) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

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

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        if (isNew)
        {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [[ZYXItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCameraOverlayView:) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCameraOverlayView:) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:iv];
    self.imageView = iv;
    
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    NSDictionary *nameMap = @{ @"imageView" : self.imageView,
                               @"dateLabel" : self.dateLabel,
                               @"toolbar" : self.toolBar};
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    NSArray *verticalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-8-[imageView]-8-[toolbar]" options:0 metrics:nil views:nameMap];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalContraints];
}

- (void)hideCameraOverlayView:(NSNotification *)notiifcation
{
    NSLog(@"显示或关闭");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication]  statusBarOrientation];
    [self prepareViewsForOrientation:io];

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
    if (itemKey)
    {
        UIImage *imageToDisplay = [[ZYXImageStore sharedStore] imageForKey:itemKey];
        self.imageView.image = imageToDisplay;

    }
    else
    {
        self.imageView.image = nil;
    }
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel)
    {
        typeLabel = NSLocalizedString(@"None", @"Type label None");
    }
    self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type the button"), typeLabel];
    
    [self updateFonts];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    self.item.itemName = self.nameTextField.text;
    self.item.serialNumber = self.serialTextField.text;
    int newValue = [self.valueTextField.text intValue];
    if (newValue != self.item.valueInDollars)
    {
        
        self.item.valueInDollars = newValue;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue forKey:ZYXNextItemValuePrefsKey];
    }
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

//iPhone界面转屏的时候调用，在iOS8被废弃
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientiom
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return;
    }
    if (UIInterfaceOrientationIsLandscape(orientiom))
    {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }
    else
    {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

#pragma mark - Action Method
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
    //如果使用UIPopoverController则需要在第二次点击按钮时关闭该controller
//    if ([self.imagePickerPopover isPopoverVisible])
//    {
//        [self.imagePickerPopover dismissPopoverAnimated:YES];
//        self.imagePickerPopover = nil;
//        return;
//    }
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
    imagePicker.modalPresentationStyle = UIModalPresentationPopover;
    self.imagePopover = imagePicker.popoverPresentationController;
    self.imagePopover.barButtonItem = sender;
    self.imagePopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.imagePopover.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//    {
//        //在iOS8.0中被废弃
//        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
//        self.imagePickerPopover.delegate = self;
//        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    }
//    else
//    {
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    }
}

//UIPopoverController的关闭操作
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//    self.imagePickerPopover = nil;
//}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    //释放对象
    self.imagePopover = nil;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    NSLog(@"iPhone");
    return UIModalPresentationNone;
}

#pragma mark - UIImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.item setThumbnailFromImage:image];
    [[ZYXImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
    
//UIPopoverController的手动关闭操作
//    if (self.imagePickerPopover)
//    {
//        [self.imagePickerPopover dismissPopoverAnimated:YES];
//        self.imagePickerPopover = nil;
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imagePopover = nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - font setting
- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameTextField.font = font;
    self.serialTextField.font = font;
    self.valueTextField.font = font;
}
- (IBAction)showAssetTypePicker:(id)sender
{
    [self.view endEditing:YES];
    ZYXAssetTypeViewController *avc = [[ZYXAssetTypeViewController alloc] init];
    avc.item = self.item;
    
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([identifierComponents count] == 3)
    {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    
    self.item.itemName = self.nameTextField.text;
    self.item.serialNumber = self.serialTextField.text;
    self.item.valueInDollars = [self.valueTextField.text intValue];
    [[ZYXItemStore sharedStore] saveChanges];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (ZYXItem *item in [[ZYXItemStore sharedStore] allItems])
    {
        if ([itemKey isEqualToString:item.itemKey])
        {
            self.item = item;
            break;
        }
    }
    
    [super decodeRestorableStateWithCoder:coder];
}

@end
