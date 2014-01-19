UIImageView-BetterFace
======================

A UIImageView extension to let the picture-cutting with faces showing better

Last update in v0.2_stable : add a UIImage+BetterFace category, so clipping images becomes possible(clap!)

Looking for an Android version? Check this! [https://github.com/beartung/tclip-android]

##Why?

 - Have problems showing the resized image previews? 
 - People in the preview only have chins but not faces?
 - A group photo doesn't look well?

Try UIImageView-BetterFace!

Like this:

![preview](https://raw.github.com/croath/UIImageView-BetterFace/master/doc/preview.png)

##How?

 1. drag `UIImageView+BetterFace.h` and `UIImageView+BetterFace.m` to your project
 2. add CoreImage.framework to your project
 3. import the .h file
 4. add `hack_uiimageview_bf();` to your `main` function
 5. add this:`[anImageView setNeedsBetterFace:YES];`
 6. done
 7. still have problems? clone the project and see the demo.
 
##Too slow?

try set the `fast` property to `YES` to get the faster speed(lower accuracy)

##Known issues

 - ~~it will be slow to render large-size images, and showing the strange animation~~
 - ~~it may take a lot of memory while reusing the UIImageView~~

##Who use BetterFace?

If you're building your applications using UIImageView-BetterFace, please let me know! (add your application name & App Store link here and pullreuqest this README~

##Debugging
Add `BF_DEBUG` to your pre compile macros or `#define BF_DEBUG` to your `prefix.pch` file in order to see turn ON debugging logs on the console.
 
##Other

Any issue and pull request is welcome.
