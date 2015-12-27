//
//  PicViewController.m
//  JSMQZX
//
//  Created by 李 燕琴 on 15/12/16.
//  Copyright © 2015年 liyanqin. All rights reserved.
//

#import "PicViewController.h"

@interface PicViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSArray *photos;

@end

@implementation PicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    self.photos = _RZ_imageArr;
    if (self.photos.count>0) {
        _deleteBtn.enabled = YES;
    }
    else{
          _deleteBtn.enabled = NO;
    }
    _photoStack.dataSource = self;
    _photoStack.delegate = self;
    MyLog(@"%f %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    _photoStack.frame =CGRectMake(20, 104,SCREEN_WIDTH-40,SCREEN_HEIGHT-145-80);
    
    //CGSizeMake(SCREEN_WIDTH-40,SCREEN_HEIGHT)
    
    MyLog(@"x=%f y=%f 高度%f 宽度%f", _photoStack.frame.origin.x, _photoStack.frame.origin.y,_photoStack.frame.size.width,_photoStack.frame.size.height);
    [self.photoStack reloadData];
    if (self.photos.count>0) {
        _photoStack.userInteractionEnabled = YES;
    }
    else{
        _photoStack.userInteractionEnabled = NO;
    }
    self.pageControl.numberOfPages = [self.photos count];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        MyLog(@"返回时照片------------------------------------------------%d",self.photos.count);

        if (self.photos.count>0) {
           
                       //添加通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddPicFinished" object:self.photos];
        }
}
    [super viewWillDisappear:animated];
}



#pragma mark -
#pragma mark Deck DataSource Protocol Methods

-(NSUInteger)numberOfPhotosInPhotoStackView:(PhotoStackView *)photoStack {
    return [self.photos count];
    MyLog(@"刷新时*************%d",self.photos.count);
}

-(UIImage *)photoStackView:(PhotoStackView *)photoStack photoForIndex:(NSUInteger)index {
    //reload图片
    /*NSString *imagename = [NSString stringWithFormat:@"%@%@",[self.photos[index] objectForKey:@"photoCode"],[self.photos[index] objectForKey:@"photoUrl"]];*/
    return [self.photos objectAtIndex:index];
}



#pragma mark -
#pragma mark Deck Delegate Protocol Methods

-(void)photoStackView:(PhotoStackView *)photoStackView willStartMovingPhotoAtIndex:(NSUInteger)index {
    // User started moving a photo
}

-(void)photoStackView:(PhotoStackView *)photoStackView willFlickAwayPhotoAtIndex:(NSUInteger)index {
    // User flicked the photo away, revealing the next one in the stack
}

-(void)photoStackView:(PhotoStackView *)photoStackView didRevealPhotoAtIndex:(NSUInteger)index {
    self.pageControl.currentPage = index;
}

-(void)photoStackView:(PhotoStackView *)photoStackView didSelectPhotoAtIndex:(NSUInteger)index {
    NSLog(@"selected %d", index);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickAddPic:(id)sender {
    UIActionSheet * sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册", nil];
    }
    [sheet showInView:self.view];
}

#pragma mark - 实现ActionSheet delegate事件
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUInteger sourceType = 0;
    
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        switch (buttonIndex)
        {
            case 0:
                return;// 取消
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera; // 相机
                break;
            
            default:
                break;
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // 相册
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self; // 设置代理
    imagePicker.allowsEditing = YES; // 允许编辑
    imagePicker.sourceType = sourceType; // 设置图片源
    [[imagePicker navigationBar] setTintColor:[UIColor whiteColor]];
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
}


#pragma mark - 实现ImagePicker delegate 事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.5);
        NSMutableArray *photosMutable = [[NSMutableArray alloc] init];
                [photosMutable addObject:image];
        self.photos = photosMutable;
        if (self.photos.count>0) {
            photosMutable  = [self.photos mutableCopy];
            _deleteBtn.enabled = YES;
        }

        MyLog(@"添加后照片------------------------------------------------%d",self.photos.count);
        [self.photoStack reloadData];
        self.photoStack.userInteractionEnabled = YES;
        self.pageControl.numberOfPages = [self.photos count];
        
    }];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)clickDelete:(id)sender{
    NSMutableArray *photosMutable = [self.photos mutableCopy];
    [photosMutable removeObjectAtIndex:self.pageControl.currentPage];
    self.photos = photosMutable;
    MyLog(@"删除后照片------------------------------------------------%d",self.photos.count);
    if (self.photos.count>0) {
        _deleteBtn.enabled = YES;
    }
    else{
        _deleteBtn.enabled = NO;
    }

    [self.photoStack reloadData];
    self.pageControl.numberOfPages = [self.photos count];
}

@end
