//
//  ViewController.m
//  multipleImagesuploadingObjC
//
//  Created by Mac on 30/04/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self singleImage];
    [self multipleImages];
    // Do any additional setup after loading the view.
}
-(void)singleImage
{
    // creating a NSMutableURLRequest that we can manipulate before sending
    NSURL *theURL = [NSURL URLWithString:@"http://localhost/APIs/withoutJSON/ImageAPI.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:theURL];
    
    // setting the HTTP method
    [request setHTTPMethod:@"POST"];
    
    // we want a JSON response
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSString *boundary = [[NSUUID UUID]UUIDString];
    // setting the Content-type and the boundary
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // we need a buffer of mutable data where we will write the body of the request
    NSMutableData *body = [NSMutableData data];
    NSDictionary *paramsDict = [[NSMutableDictionary alloc]init];
    [paramsDict setValue:@"sub.png" forKey:@"ImgName"];
    [paramsDict setValue:@"floor" forKey:@"tag"];
    for (NSString *key in paramsDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [paramsDict objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    NSData *imageData;
   
    UIImage *img1 = [UIImage imageNamed:@"cat.png"];
   
    imageData = UIImageJPEGRepresentation(img1, 1.0);
  
    
    NSString *fileNameStr = @"sampleImg.jpg";
   
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ImgName\"; filename=\"%@\"\r\n",fileNameStr] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {NSLog(@"no image data!!!");}
    // we close the body with one last boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // assigning the completed NSMutableData buffer as the body of the HTTP POST request
    [request setHTTPBody:body];
    
    
    
    // send the request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"completion handler with response: %@", [NSHTTPURLResponse localizedStringForStatusCode:[(NSHTTPURLResponse*)response statusCode]]);
        
        
        NSInteger status = [(NSHTTPURLResponse*)response statusCode];
        
        if(error){
            NSLog(@"http request error: %@", error.localizedDescription);
            // handle the error
        }
        else{
            if (status == 200)
            {
                NSString *responseData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                NSLog(@"");
            }
            // handle the success
            else
            {
                NSLog(@"");
            }
            // handle the error
        }
    }];
    
}

-(void)multipleImages
{
       NSData *imageData1;
       NSData *imageData2;
    NSMutableArray *multipleImgArray=[[NSMutableArray alloc] init];
    NSMutableArray *multipleImgDataArray=[[NSMutableArray alloc] init];
    NSMutableArray *multipleImgNameArray=[[NSMutableArray alloc] init];
    UIImage *img1 = [UIImage imageNamed:@"cat.png"];
    UIImage *img2 = [UIImage imageNamed:@"pizza.jpg"];
    
    imageData1 = UIImageJPEGRepresentation(img1, 1.0);
    imageData2 = UIImageJPEGRepresentation(img2, 1.0);
    
    [multipleImgNameArray addObject:@"FirstImg"];
    [multipleImgNameArray addObject:@"SecondImg"];
    
    [multipleImgArray addObject:img1];
    [multipleImgArray addObject:img2];
    
    [multipleImgDataArray addObject:imageData1];
    [multipleImgDataArray addObject:imageData2];
    
    
    NSString *fileNameStr = @"sampleImg.jpg";
       // creating a NSMutableURLRequest that we can manipulate before sending
    NSURL *theURL = [NSURL URLWithString:@"http://localhost/APIs/withoutJSON/multipleImagesAPI.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:theURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *boundary = [[NSUUID UUID]UUIDString];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    NSDictionary *paramsDict = [[NSMutableDictionary alloc]init];
    [paramsDict setValue:@"floor" forKey:@"tag"];
    [paramsDict setValue:@"2" forKey:@"count"];
    [paramsDict setValue:[multipleImgNameArray objectAtIndex:0] forKey:@"file1"];
    [paramsDict setValue:[multipleImgNameArray objectAtIndex:1] forKey:@"file2"];
    // writing the basic parameters
    for (NSString *key in paramsDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [paramsDict objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    for(int i=0;i<multipleImgArray.count;i++)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file%d\"; filename=\"%@\"\r\n", (i+1),fileNameStr] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[multipleImgDataArray objectAtIndex:i]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // we close the body with one last boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // assigning the completed NSMutableData buffer as the body of the HTTP POST request
    [request setHTTPBody:body];
    
    
    
    // send the request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSLog(@"completion handler with response: %@", [NSHTTPURLResponse localizedStringForStatusCode:[(NSHTTPURLResponse*)response statusCode]]);
        
        
        NSInteger status = [(NSHTTPURLResponse*)response statusCode];
        NSLog(@"http request error: %li", (long)status);
        if(error){
            NSLog(@"http request error: %@", error.localizedDescription);
            // handle the error
        }
        else{
            if (status == 200)
            {
                NSString *responseData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                NSLog(@"");
            }
            // handle the success
            else
            {
                NSLog(@"ststaus code not 200");
            }
            NSLog(@"Error is %@",error);
            // handle the error
        }
    }];
    
}
@end
