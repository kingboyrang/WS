//
//  CaseCameraImage.m
//  ElandSearch
//
//  Created by rang on 13-8-11.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "AlbumCameraImage.h"

@implementation AlbumCameraImage
-(void)showCameraInController:(UIViewController*)controller{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing=YES;//是否允許編輯
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        //[picker release];
        return;
    }
    [controller presentViewController:picker animated:YES completion:nil];
    //[picker release];
}
-(void)showAlbumInController:(UIViewController*)controller{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing=YES;//是否允許編輯
   //相簿
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [controller presentViewController:picker animated:YES completion:^{}];
    //[picker release];
}
#pragma mark -
#pragma mark UIImagePickerController  Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
	UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(photoFromAlbumCameraWithImage:)]) {
        [self.delegate photoFromAlbumCameraWithImage:image];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
