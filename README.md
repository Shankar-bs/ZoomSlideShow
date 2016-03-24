# ZoomSlideShow
zoom slide show we are animating the images and user interaction are provided 
the demo project contains a zoomslide show, and explains how to use in the main project

To use ZoomSlideshow just add ZummSlide.h and ZummSlide.m files to your project and set the delage and implement below delegate methods

- (UIImage *)imageForSlideShowForZomSlideShowView:(ZummSlide *)zomView AtIndex:(NSInteger)index;
- (NSInteger)numberOfImagesForZomSlideShow;
- (void)showAlert; 

method names are self explanatery.
