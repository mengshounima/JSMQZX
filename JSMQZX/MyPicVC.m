//
//  MyPicVC.m
//  JSMQZX
//
//  Created by 李 燕琴 on 16/1/2.
//  Copyright © 2016年 liyanqin. All rights reserved.
//

#import "MyPicVC.h"

@interface MyPicVC ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *pictureArr;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIScrollView *picScroll;
@property (nonatomic,assign) int currentIndex;
@end

@implementation MyPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initView];
    [self initData];
   
}
-(void)initData{
    _currentIndex = 0;
    _pictureArr = [[NSMutableArray alloc] init];
    if (_RZ_imageArr.count>0) {
          self.pictureArr = [_RZ_imageArr mutableCopy];
    }
  
    if (self.pictureArr.count>0) {
        _rightBtn.enabled = YES;
    }
    else{
        _rightBtn.enabled = NO;
    }
    if (self.pictureArr.count==1) {
        _picScroll.contentSize = CGSizeMake(0,0);
    }
    else{
        _picScroll.contentSize = CGSizeMake(self.pictureArr.count*SCREEN_WIDTH,0);
    }

    //重新布局
    for (int i= 0; i<self.pictureArr.count; i++) {
        //页码
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i+SCREEN_WIDTH*0.4, 10, SCREEN_WIDTH*0.2, 20)];
        numberLabel.text = [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)self.pictureArr.count];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.tag = i+1+100;
        MyLog(@"tag = %d",numberLabel.tag);
        [self.picScroll addSubview:numberLabel];
        
        UIImageView  *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i+SCREEN_WIDTH*0.1, 30, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7-30)];
        imageV.backgroundColor = [UIColor redColor];
        imageV.image = [_pictureArr objectAtIndex:i];
        [self.picScroll addSubview:imageV];
        
    }
    [_picScroll setContentOffset:CGPointMake(0, _picScroll.contentOffset.y) animated:NO]; //设置scrollview的显示为当前滑动到的页面
    
}
-(void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        MyLog(@"返回时照片------------------------------------------------%d",self.pictureArr.count);
        
        if (self.pictureArr.count>0) {
            
            //添加通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddPicFinished" object:self.pictureArr];
        }
    }
    [super viewWillDisappear:animated];
}


-(void)clickDelete:(UIButton *)button{
    [self.pictureArr removeObjectAtIndex:_currentIndex];//移除照片
    
    if (self.pictureArr.count==1) {
        _picScroll.contentSize = CGSizeMake(0,0);
    }
    else{
        _picScroll.contentSize = CGSizeMake(self.pictureArr.count*SCREEN_WIDTH,0);
    }
    //删除所有页
    for (UIView * subview in [_picScroll subviews]) {
        //if([subview isKindOfClass:[UIImageView class]]) continue;//这是为了防止滚动条被移除;
        [subview removeFromSuperview];
    }
    //重新布局
    for (int i= 0; i<self.pictureArr.count; i++) {
        //页码
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i+SCREEN_WIDTH*0.4, 10, SCREEN_WIDTH*0.2, 20)];
        numberLabel.text = [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)self.pictureArr.count];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.tag = i+1+100;
        MyLog(@"删除tag = %d",numberLabel.tag);
        [self.picScroll addSubview:numberLabel];
        
        UIImageView  *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i+SCREEN_WIDTH*0.1, 30, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7-30)];
        
        imageV.image = [_pictureArr objectAtIndex:i];
        [self.picScroll addSubview:imageV];

    }
    _currentIndex = _currentIndex-1;
    if (_currentIndex==-1) {
         [_picScroll setContentOffset:CGPointMake(0, _picScroll.contentOffset.y) animated:NO]; //设置scrollview的显示为当前滑动到的页面
    }
    else{
        [_picScroll setContentOffset:CGPointMake(SCREEN_WIDTH*(_currentIndex), _picScroll.contentOffset.y) animated:NO]; //设置scrollview的显示为当前滑动到的页面
    }
    
    if (self.pictureArr.count<1) {
        _rightBtn.enabled = NO;
    }
}
-(void)initView{
    self.title = @"照片浏览";
    //右上角删除按钮
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    [_rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    _rightBtn.layer.cornerRadius = 6;
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = [UIColor orangeColor];
    [_rightBtn addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
     _rightBtn.enabled = NO;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _picScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.7)];
    //_picScroll.backgroundColor = [UIColor lightGrayColor];
    _picScroll.delegate = self;
    _picScroll.pagingEnabled=YES;//scrollView不会停在页面之间，即只会显示第一页或者第二页，不会各一半显示
    [self.view addSubview:_picScroll];
    
    float Y = CGRectGetMaxY(_picScroll.frame);
    UIButton *AddPicBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.4, Y+SCREEN_HEIGHT*0.1, SCREEN_WIDTH*0.2, SCREEN_HEIGHT*0.1)];
    AddPicBtn.layer.cornerRadius = 6;
    AddPicBtn.backgroundColor = [UIColor orangeColor];
    [AddPicBtn setTitle:@"添加" forState:UIControlStateNormal];
    [AddPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AddPicBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [AddPicBtn addTarget:self action:@selector(ClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:AddPicBtn];
    
}
-(void)ClickAddBtn:(UIButton *)button{
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
        
        [self.pictureArr addObject:image];
        _currentIndex = self.pictureArr.count-1;
        [self reloadScrollView];
        _rightBtn.enabled = YES;
     
        MyLog(@"添加后照片------------------------------------------------%@",self.pictureArr);
 
        
    }];
}
-(void)reloadScrollView{
    if (self.pictureArr.count==1) {
         _picScroll.contentSize = CGSizeMake(0,0);
    }
    else{
         _picScroll.contentSize = CGSizeMake(self.pictureArr.count*SCREEN_WIDTH,0);
    }
    
            //页码
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*(self.pictureArr.count-1)+SCREEN_WIDTH*0.4, 10, SCREEN_WIDTH*0.2, 20)];
            numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)_pictureArr.count,(unsigned long)self.pictureArr.count];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.tag = _pictureArr.count+100;
            MyLog(@"tag = %d",numberLabel.tag);
            [self.picScroll addSubview:numberLabel];
            
            UIImageView  *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*(self.pictureArr.count-1)+SCREEN_WIDTH*0.1, 30, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.7-30)];
            
            imageV.image = [_pictureArr objectAtIndex:_pictureArr.count-1];
            [self.picScroll addSubview:imageV];
             [_picScroll setContentOffset:CGPointMake(SCREEN_WIDTH*(self.pictureArr.count-1), _picScroll.contentOffset.y) animated:NO]; //设置scrollview的显示为当前滑动到的页面
    
    //遍历title
    int i = 1;
    for (UILabel *subLabel in _picScroll.subviews) {
         MyLog(@"subLabel.tag%ld",(long)subLabel.tag);
        if (subLabel.tag==i+100) {
            subLabel.text = [NSString stringWithFormat:@"%d/%lu",i,(unsigned long)self.pictureArr.count];
            i++;
        }
        
    }

    
    
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
      CGPoint offset = scrollView.contentOffset;
    _currentIndex = offset.x /SCREEN_WIDTH; //计算当前的页码
    MyLog(@"_currentIndex%d",_currentIndex);

}


/*
//停止滑动时
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
        //这里写上停止时要执行的代码
        CGPoint offset = scrollView.contentOffset;
        _currentIndex = offset.x /SCREEN_WIDTH; //计算当前的页码
    
}*/
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

@end
