//
//  ViewController.m
//  ios
//
//  Created by Resident evil on 9/2/15.
//  Copyright (c) 2015 Resident evil. All rights reserved.
//

#import "ViewController.h"
#import "LzmaSDKObjCReader.h"

@interface ViewController () <LzmaSDKObjCReaderDelegate>

@property (nonatomic, strong) LzmaSDKObjCReader * reader;

@end

@implementation ViewController

- (void) onLzmaSDKObjCReader:(nonnull LzmaSDKObjCReader *) reader
			 extractProgress:(float) progress
{
	NSLog(@"DELEGATE, extractProgress = %f", progress);
}

- (IBAction) on1:(id)sender
{
	NSString * testFile = nil;

	testFile = @"lzma.7z";
//	testFile = @"lzma_aes256.7z";
//	testFile = @"lzma_aes256_encfn.7z";

	testFile = @"lzma2.7z";
	testFile = @"lzma2_aes256.7z";
	testFile = @"lzma2_aes256_encfn.7z";

//	testFile = @"ppmd.7z";
//	testFile = @"bzip2.7z";
//	testFile = @"bzip2_aes256.7z";
//	testFile = @"ppmd_aes256.7z";
//	testFile = @"bzip2_aes256_encfn.7z";
//	testFile = @"ppmd_aes256_encfn.7z";


	NSString * archivePath = [@"/Volumes/Data/Documents/LzmaSDK-ObjC/tests/files/" stringByAppendingPathComponent:testFile];
//	archivePath = @"/Volumes/Data/1/example.7Z";

	self.reader = [[LzmaSDKObjCReader alloc] initWithFileURL:[NSURL fileURLWithPath:archivePath]];

	_reader.delegate = self;

	_reader.passwordGetter = ^NSString*(void){
		NSLog(@"Request password");
		return @"1234";
	};

	NSError * error = nil;
	if (![_reader open:&error])
	{
		if (error) NSLog(@"Open error: %@", error);
	}

	error = [_reader lastError];
	if (error) NSLog(@"Open error: %@", error);

	NSMutableArray * items = [NSMutableArray array];
	[_reader iterateWithHandler:^BOOL(LzmaSDKObjCItem * item, NSError * error){
		NSLog(@"\n%@", item);
		if (item) [items addObject:item];
		return YES;
	}];
	NSLog(@"Iteration error: %@", _reader.lastError);

	BOOL result = [_reader test:items];
	NSLog(@"Test result: %@", result ? @"YES" : @"NO");

	result = [_reader extract:items
							 toPath:@"/Volumes/Data/1/"
				withFullPaths:YES];
	NSLog(@"Extract result: %@", result ? @"YES" : @"NO");


	self.reader = nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
