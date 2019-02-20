//
//  MUImageCache.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUImageCache.h"
#import "MUImageDataFileManager.h"
#import "MUImageRetrieveOperation.h"
#import "MUImageDecoder.h"
#import <objc/message.h>


#define kImageInfoIndexFileName 0
#define kImageInfoIndexContentType 1
#define kImageInfoIndexWidth 2
#define kImageInfoIndexHeight 3
#define kImageInfoIndexLock 4


@interface MUImageCache ()
@property (nonatomic, strong) MUImageDecoder* decoder;
@property (nonatomic,assign ) BOOL savedFile;
@end

@implementation MUImageCache{
    
    NSLock* _lock;
    NSString* _metaPath;
    
    NSMutableDictionary* _images;
    NSMutableDictionary* _imagesMetaData;
    NSMutableDictionary* _addingImages;
    NSOperationQueue* _retrievingQueue;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static MUImageCache* __instance = nil;
    dispatch_once(&onceToken, ^{
        NSString *metaPath = [[MUImageCacheUtils directoryPath] stringByAppendingPathComponent:@"/__images"];
        __instance = [[[self class] alloc] initWithMetaPath:metaPath];
    });
    
    return __instance;
}

- (instancetype)initWithMetaPath:(NSString*)metaPath
{
    if (self = [super init]) {
        _lock = [[NSLock alloc] init];
        _addingImages = [[NSMutableDictionary alloc] init];
        _maxCachedBytes = 1024 * 1024 * 512;
        _retrievingQueue = [NSOperationQueue new];
        _retrievingQueue.qualityOfService = NSQualityOfServiceUserInteractive;
        _retrievingQueue.maxConcurrentOperationCount = 6;
#ifdef FLYIMAGE_WEBP
        _autoConvertWebP = NO;
        _compressionQualityForWebP = 0.8;
#endif
        
        _metaPath = [metaPath copy];
        NSString* folderPath = [[_metaPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"/files"];
        self.dataFileManager = [[MUImageDataFileManager alloc] initWithFolderPath:folderPath];
        
        _metaPath = [metaPath copy];
        _decoder = [[MUImageDecoder alloc] init];
        
        
        [self loadMetadata];
        
        
    }
    return self;
}

- (void)loadMetadata
{
    // load content from index file
    NSError* error;
    NSData* metadataData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:_metaPath] options:NSDataReadingMappedAlways error:&error];
    if (error != nil || metadataData == nil) {
        [self createMetadata];
        return;
    }
    
    NSDictionary* parsedObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:metadataData options:kNilOptions error:&error];
    if (error != nil || parsedObject == nil) {
        [self createMetadata];
        return;
    }
    
    _images = [NSMutableDictionary dictionaryWithDictionary:parsedObject];
    _imagesMetaData = [NSMutableDictionary dictionaryWithDictionary:parsedObject];
}

- (void)createMetadata
{
    _images = [NSMutableDictionary dictionary];
    _imagesMetaData = [NSMutableDictionary dictionary];
}

- (void)dealloc
{
    [_retrievingQueue cancelAllOperations];
}

- (void)addImageWithKey:(NSString *)key
               filename:(NSString *)filename
               drawSize:(CGSize)drawSize
           cornerRadius:(CGFloat)cornerRadius
              completed:(MUImageCacheRetrieveBlock)completed{
    
    [self doAddImageWithKey:key
                   filename:filename
                   drawSize:drawSize
            contentsGravity:kCAGravityResizeAspect
               cornerRadius:cornerRadius
                  completed:completed];
    
}
- (void)doAddImageWithKey:(NSString*)key
                 filename:(NSString*)filename
                 drawSize:(CGSize)drawSize
          contentsGravity:(NSString* const)contentsGravity
             cornerRadius:(CGFloat)cornerRadius
                completed:(MUImageCacheRetrieveBlock)completed
{
    NSParameterAssert(key != nil);
    NSParameterAssert(filename != nil);
    
    
    if ([self isImageExistWithURLString:key] && completed != nil) {
        [self asyncGetImageWithURLString:key
                    placeHolderImageName:nil
                                drawSize:drawSize
                         contentsGravity:contentsGravity
                            cornerRadius:cornerRadius
                               completed:completed];
        return;
    }
    // ignore draw size when add images
    @synchronized(_addingImages)
    {
        if ([_addingImages objectForKey:key] == nil) {
            NSMutableArray* blocks = [NSMutableArray array];
            if (completed != nil) {
                [blocks addObject:completed];
            }
            
            [_addingImages setObject:blocks forKey:key];
        } else {
            // waiting for drawing
            NSMutableArray* blocks = [_addingImages objectForKey:key];
            if (completed != nil) {
                [blocks addObject:completed];
            }
            return;
        }
    }
    
    [self doAddImageWithKey:[key copy]
                   filename:[filename copy]
                   drawSize:drawSize
            contentsGravity:contentsGravity
               cornerRadius:cornerRadius];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
- (void)doAddImageWithKey:(NSString*)key
                 filename:(NSString*)filename
                 drawSize:(CGSize)drawSize
          contentsGravity:(NSString* const)contentsGravity
             cornerRadius:(CGFloat)cornerRadius{
    
    static dispatch_queue_t __drawingQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *name = [NSString stringWithFormat:@"com.MUImage.addimage.%@", [[NSUUID UUID] UUIDString]];
        __drawingQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    });
    __weak typeof(self)weakSelf = self;
    dispatch_async(__drawingQueue, ^{
        __strong typeof(weakSelf)self = weakSelf;
        // get image meta
        CGSize imageSize = CGSizeZero;
        MUImageContentType contentType;
        NSString *filePath = [self.dataFileManager.folderPath stringByAppendingPathComponent:filename];
        UIImage *image = nil;
        @autoreleasepool {
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            contentType = [MUImageCacheUtils contentTypeForImageData:fileData];
            
            if ( contentType == MUImageContentTypeWebP ) {
#ifdef FLYIMAGE_WEBP
                if ( _autoConvertWebP ) {
                    // Decode WebP
                    BOOL hasAlpha;
                    image = [_decoder imageWithWebPData:fileData hasAlpha:&hasAlpha];
                    if ( image != nil ) {
                        NSData *compresstionImageData;
                        if ( hasAlpha ) {
                            // Convert WebP to PNG
                            compresstionImageData = UIImagePNGRepresentation(image);
                            if ( compresstionImageData != nil ){
                                contentType = ImageContentTypePNG;
                            }
                        }else{
                            // Convert WebP to JPEG
                            compresstionImageData = UIImageJPEGRepresentation(image, self.compressionQualityForWebP);
                            if ( compresstionImageData != nil ){
                                contentType = ImageContentTypeJPEG;
                            }
                        }
                        
                        // save image into disk
                        if ( compresstionImageData != nil ){
                            NSString *filePath = [self.dataFileManager.folderPath stringByAppendingPathComponent:filename];
                            [compresstionImageData writeToFile:filePath atomically:YES];
                        }
                    }
                }
#endif
            }else{
                // read image meta, not data
                image = [UIImage imageWithContentsOfFile:filePath];
                
            }
            imageSize = image.size;
        }
        [self.dataFileManager addExistFileName:filename];
        MUImageDataFile *dataFile = [self.dataFileManager retrieveFileWithName:filename];
        if (!dataFile.isOpening) {//file not haved been opened
            if ( [dataFile open] == false ) {
                [self afterAddImage:[MUImageCacheUtils drawImage:image drawSize:drawSize CornerRadius:cornerRadius] key:key filePath:dataFile.filePath];
                return;
            }
        }
        // save data file's param
        void *bytes = dataFile.address;
        size_t fileLength = (size_t)dataFile.fileLength;
        
        // callback with image
        //           NSLog(@"%@------%@",NSStringFromCGSize(imageSize),NSStringFromCGSize(drawSize));
        UIImage *decodeImage = [self.decoder imageWithFile:(__bridge void *)(dataFile)
                                               contentType:contentType
                                                     bytes:bytes
                                                    length:fileLength
                                                  drawSize:CGSizeEqualToSize(drawSize, CGSizeZero) ? imageSize : drawSize
                                           contentsGravity:contentsGravity
                                              cornerRadius:cornerRadius];
        
        if (decodeImage) {
            
            [self afterAddImage:decodeImage key:key filePath:filePath];
        }else{
            [self afterAddImage:[MUImageCacheUtils drawImage:image drawSize:drawSize CornerRadius:cornerRadius] key:key filePath:dataFile.filePath];
        }
        if (contentType == MUImageContentTypeUnknown) {
            return ;
        }
        
        @synchronized (_images) {
            // path, width, height, length
            NSArray *imageInfo = @[ filename,
                                    @(contentType),
                                    @(imageSize.width),
                                    @(imageSize.height) ];
            
            [_images setObject:imageInfo forKey:key];
            [_imagesMetaData setObject:imageInfo forKey:key];
        }
        
        if (self.savedFile) {
            self.savedFile = NO;
        }
    });
    
}
#pragma clang diagnostic pop
- (void)afterAddImage:(UIImage*)image
                  key:(NSString*)key
             filePath:(NSString *)filePath
{
    NSArray* blocks = nil;
    @synchronized(_addingImages)
    {
        blocks = [[_addingImages objectForKey:key] copy];
        [_addingImages removeObjectForKey:key];
    }
    
    for ( MUImageCacheRetrieveBlock block in blocks) {
        block( key, image ,filePath);
    }
}
- (void)asyncGetImageWithURLString:(NSString *)imageURLString
                         completed:(MUImageCacheRetrieveBlock)completed{
    
    [self asyncGetImageWithURLString:imageURLString
                placeHolderImageName:nil
                            drawSize:CGSizeZero
                     contentsGravity:kCAGravityResizeAspect
                        cornerRadius:0
                           completed:completed];
}


- (void)asyncGetImageWithURLString:(NSString *)ImageURLString
              placeHolderImageName:(NSString *)imageName
                          drawSize:(CGSize)drawSize
                   contentsGravity:(NSString* const)contentsGravity
                      cornerRadius:(CGFloat)cornerRadius
                         completed:(MUImageCacheRetrieveBlock)completed{
    
    NSParameterAssert(ImageURLString != nil);
    NSParameterAssert(completed != nil);
    
    NSArray* imageInfo;
    @synchronized(_images)
    {
        imageInfo = [_images objectForKey:ImageURLString];
    }
    
    if (imageInfo == nil || [imageInfo count] <= kImageInfoIndexHeight) {
        if (imageName.length > 0) {
               completed(ImageURLString, [MUImageCacheUtils drawImage:[UIImage imageNamed:imageName] drawSize:drawSize CornerRadius:cornerRadius] ,nil);
        }else{
            completed(ImageURLString, nil ,nil);
        }
        return;
    }
    
    // filename, width, height, length
    NSString* filename = [imageInfo firstObject];
    MUImageDataFile* dataFile = [self.dataFileManager retrieveFileWithName:filename];
    if (dataFile == nil) {
        @synchronized(_images)
        {
            [_images removeObjectForKey:ImageURLString];
        }
        NSString *filePath = [self.dataFileManager.folderPath stringByAppendingPathComponent:filename];
        if (filePath.length > 0) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        if (imageName.length > 0) {
            completed(ImageURLString, [MUImageCacheUtils drawImage:[UIImage imageNamed:imageName] drawSize:drawSize CornerRadius:cornerRadius] ,nil);
        }else{
            completed(ImageURLString, nil ,nil);
        }
        return;
    }
    
    // if the image is retrieving, then just add the block, no need to create a new operation.
    
    NSArray *tempArray = [_retrievingQueue.operations copy];
    for (MUImageRetrieveOperation* operation in tempArray) {
        if ([operation.name isEqualToString:ImageURLString]) {
            NSString* renderer = objc_getAssociatedObject(self,@selector(asyncGetImageWithURLString:placeHolderImageName:drawSize:contentsGravity:cornerRadius:completed:));
            CGSize innerSize = CGSizeZero;
            if (renderer) {
                innerSize = CGSizeFromString(renderer);
            }
            if (CGSizeEqualToSize(drawSize, innerSize)) {
                [operation addBlock:completed];
                return;
            }
            break ;
        }
    }
    
    CGSize imageSize = drawSize;
    if (drawSize.width == 0 && drawSize.height == 0) {
        CGFloat imageWidth = [[imageInfo objectAtIndex:kImageInfoIndexWidth] floatValue];
        CGFloat imageHeight = [[imageInfo objectAtIndex:kImageInfoIndexHeight] floatValue];
        imageSize = CGSizeMake(imageWidth, imageHeight);
    }
    
    objc_setAssociatedObject(self, @selector(asyncGetImageWithURLString:placeHolderImageName:drawSize:contentsGravity:cornerRadius:completed:), NSStringFromCGSize(imageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    MUImageContentType contentType = [[imageInfo objectAtIndex:kImageInfoIndexContentType] integerValue];
    
    __weak __typeof__(self) weakSelf = self;
    MUImageRetrieveOperation* operation = [[MUImageRetrieveOperation alloc] initWithRetrieveBlock:^UIImage * {
        if (!dataFile.isOpening) {
            if ( [dataFile open] == NO) {
                return nil;
            }
        }
        
        return [weakSelf.decoder imageWithFile:(__bridge void *)(dataFile)
                                   contentType:contentType
                                         bytes:dataFile.address
                                        length:(size_t)dataFile.fileLength
                                      drawSize:CGSizeEqualToSize(drawSize, CGSizeZero) ? imageSize : drawSize
                               contentsGravity:contentsGravity
                                  cornerRadius:cornerRadius];
    }];
    operation.name = ImageURLString;
    operation.filePath = dataFile.filePath;
    [operation addBlock:completed];
    [_retrievingQueue addOperation:operation];
}

- (void)cancelGetImageWithURLString:(NSString*)imageURLString
{
    NSParameterAssert(imageURLString != nil);
    
    for (MUImageRetrieveOperation* operation in _retrievingQueue.operations) {
        if (!operation.cancelled && !operation.finished && [operation.name isEqualToString:imageURLString]) {
            [operation cancel];
            return;
        }
    }
}
- (BOOL)isImageExistWithURLString:(NSString *)imageURLString{
    NSParameterAssert(imageURLString != nil);
    
    @synchronized(_images)
    {
        return [_images objectForKey:imageURLString] != nil;
    }
}
#pragma mark - Working with Metadata
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
- (void)saveMetadata
{
    
    if (_imagesMetaData.allKeys.count == 0) {
        return ;
    }
    static dispatch_queue_t __metadataQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *name = [NSString stringWithFormat:@"com.muimage.iconmeta.%@", [[NSUUID UUID] UUIDString]];
        __metadataQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    });
    
    dispatch_async(__metadataQueue, ^{
        [_lock lock];
        NSArray *meta = [_imagesMetaData mutableCopy];
        [_lock unlock];
        NSData *data = [NSJSONSerialization dataWithJSONObject:meta options:kNilOptions error:NULL];
        BOOL fileWriteResult = [data writeToFile:_metaPath atomically:YES];
        if (fileWriteResult == NO) {
            MUImageErrorLog(@"couldn't save metadata");
        }
    });
}
#pragma clang diagnostic pop
- (void)purge
{
    
    NSMutableArray* lockedFilenames = [NSMutableArray array];
    @synchronized(_images)
    {
        NSMutableArray* lockedKeys = [NSMutableArray array];
        for (NSString* key in _images) {
            NSArray* imageInfo = [_images objectForKey:key];
            if ([imageInfo count] > kImageInfoIndexLock && [[imageInfo objectAtIndex:kImageInfoIndexLock] boolValue]) {
                [lockedFilenames addObject:[imageInfo objectAtIndex:kImageInfoIndexFileName]];
                [lockedKeys addObject:key];
            }
        }
        
        // remove unlock keys
        NSArray* allKeys = [_images allKeys];
        for (NSString* key in allKeys) {
            if ([lockedKeys indexOfObject:key] == NSNotFound) {
                [_images removeObjectForKey:key];
                [_imagesMetaData removeObjectForKey:key];
            }
        }
    }
    
    [_retrievingQueue cancelAllOperations];
    
    @synchronized(_addingImages)
    {
        for (NSString* key in _addingImages) {
            NSArray* blocks = [_addingImages objectForKey:key];
            dispatch_main_async_safe(^{
                for ( MUImageCacheRetrieveBlock block in blocks) {
                    block( key, nil ,nil);
                }
            });
        }
        
        [_addingImages removeAllObjects];
    }
    
    // remove files
    [self.dataFileManager purgeWithExceptions:lockedFilenames toSize:0 completed:nil];
    
    [self saveMetadata];
}
//auto save metas when runloop in free time
- (void)commit{
    if (self.savedFile == NO) {
        self.savedFile = YES;
        [self saveMetadata];
    }
}
@end

