//
//  ixeMediaControl.m
//  Ignite iOS Engine (ixe)
//
//  Created by Jeremy Anticouni on 11/16.
//  Copyright (c) 2013 All rights reserved.
//

/*
 
 WIDGET
 /--------------------/
 - TYPE : "___"
 - DESCRIPTION: "___ Description."
 /--------------------/
 - PROPERTIES
 /--------------------/
 * name=""        default=""               type="___"
 /--------------------/
 - EVENTS
 /--------------------/
 * name="share_done"
 * name="share_cancelled"
 /--------------------/
 - Example
 /--------------------/

 {
    "type": "Media",
    "properties": {
        "id": "myMedia",
        "source": "library"
    }
 }
 
 /--------------------/
 - Changelog
 /--------------------/
 
 /--------------------/
 */

#import "ixeMediaSource.h"
#import "ixeAppManager.h"
#import "ixeNavigationViewController.h"
#import "ixeViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface  ixeMediaSource()

@property NSInteger* sourceType;

@end

@implementation ixeMediaSource



-(void)buildView
{
    [super buildView];

}

-(CGSize)preferredSizeForSuggestedSize:(CGSize)size
{
    return CGSizeZero;
}

-(void)applySettings
{
    [super applySettings];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    NSString* mediaSource = [[self propertyContainer] getStringPropertyValue:@"source" defaultValue:@"camera"];
    
    if([mediaSource compare:@"camera"] == NSOrderedSame)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if([mediaSource compare:@"library"] == NSOrderedSame)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    }
    else if([mediaSource compare:@"video"] == NSOrderedSame)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        picker.allowsEditing = NO;
    }
    
    
    [[[ixeAppManager sharedInstance] rootViewController] presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    [[[ixeAppManager sharedInstance] rootViewController] dismissViewControllerAnimated:YES completion:NULL];
    
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, nil, nil);
        }
    }

    
    
    NSLog(@"Done!");
    [[self actionContainer] executeActionsForEventNamed:@"done"];
    
    
    //Here's the image!  [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

@end
