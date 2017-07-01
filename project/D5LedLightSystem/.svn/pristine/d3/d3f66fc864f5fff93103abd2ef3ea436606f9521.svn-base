//
//  UIColor+Image.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/6/28.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "UIColor+Image.h"

@implementation UIColor (Image)

/**
 *  从image的point处获取RGB颜色值
 *
 *  @param point 图片上要取颜色值的位置
 *  @param image 要取颜色值的图片
 *
 *  @return image上point处的颜色值
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha {
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(context, alpha);
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }
}

+ (UIColor *)getPixelColorAtLocation:(CGPoint)point fromeImage:(UIImage *)image view:(UIView *)view {
    @autoreleasepool {
        UIColor *color = nil;
        
        CGImageRef inImage = image.CGImage;
        // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
        CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
        if (cgctx == NULL) {
            return nil; /* error */
        }
        
        size_t w = CGImageGetWidth(inImage);
        size_t h = CGImageGetHeight(inImage);
        
        CGFloat value = w / CGRectGetWidth(view.frame);
        point.x = point.x * value;
        point.y = point.y * value;
        
        CGRect rect = {{0,0},{w,h}};
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(cgctx, rect, inImage);
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        unsigned char *data = CGBitmapContextGetData (cgctx);
        if (data != NULL) {
            //offset locates the pixel in the data from x,y.
            //4 for 4 bytes of data per pixel, w is width of one row of data.
            int offset = 4 * ((w * round(point.y)) + round(point.x));
            int alpha =  data[offset];
            int red = data[offset + 1];
            int green = data[offset + 2];
            int blue = data[offset + 3];
            //NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        
        // When finished, release the context
        CGContextRelease(cgctx);
        // Free image data memory for the context
        if (data) { free(data); }
        return color;
    }
}

/**
 *  从image中创建bitmap context
 *
 *  @param inImage 目标image
 *
 *  @return bitmap context
 */
+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef) inImage {
    @autoreleasepool {
        CGContextRef    context = NULL;
        CGColorSpaceRef colorSpace;
        void *          bitmapData;
        int             bitmapByteCount;
        int             bitmapBytesPerRow;
        
        // Get image width, height. We'll use the entire image.
        size_t pixelsWide = CGImageGetWidth(inImage);
        size_t pixelsHigh = CGImageGetHeight(inImage);
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        bitmapBytesPerRow   = (pixelsWide * 4);
        bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
        
        // Use the generic RGB color space.
        colorSpace = CGColorSpaceCreateDeviceRGB();
        
        if (colorSpace == NULL) {
            fprintf(stderr, "Error allocating color space\n");
            return NULL;
        }
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        bitmapData = malloc( bitmapByteCount );
        if (bitmapData == NULL) {
            fprintf (stderr, "Memory not allocated!");
            CGColorSpaceRelease( colorSpace );
            return NULL;
        }
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8,      // bits per component
                            bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
        if (context == NULL) {
            free (bitmapData);
            fprintf (stderr, "Context not created!");
        }
        
        // Make sure and release colorspace before returning
        CGColorSpaceRelease( colorSpace );
        
        return context;
    }
}
@end
