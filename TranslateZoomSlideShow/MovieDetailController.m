/*
 The MIT License (MIT)
 
 Copyright (c) 2016 Shan
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */
#import "MovieDetailController.h"
#import "ZummSlide.h"

@interface MovieDetailController ()<ZummSlideDelegate>

@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 700.0);
    self.titleLabel.text = self.selectedMovie.movieTitle;
    self.descriptionLabel.text = self.selectedMovie.movieDescription;
    [self setUpSlider];
   
    self.contentScrollView.frame = self.view.bounds;
}

- (void)setUpSlider
{
    _slideShow.animationDuration = 3.5f;
    _slideShow.timeIntervell = 5.0f;
    _slideShow.zoomDepth     = 2.5f;
    _slideShow.zummDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_slideShow startSlideShow];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_slideShow stopSlideShow];
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -----------------------------------------------Zumm slide delgate methods--------------------------------------------------------------------

- (NSInteger)numberOfImagesForZomSlideShow
{
    return self.selectedMovie.posterImages.count;
}

- (UIImage *)imageForSlideShowForZomSlideShowView:(ZummSlide *)zomView AtIndex:(NSInteger)index
{
    NSString *path = nil;
    NSString *imageName = [self.selectedMovie.posterImages objectAtIndex:index];
    path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
}

- (void)showAlert
{
    UIAlertController *alerControl = [UIAlertController alertControllerWithTitle:@"Animation Duration" message:@"Animation Duration Must be less than time intervell" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel action");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK action");
    }];
    [alerControl addAction:cancelAction];
    [alerControl addAction:okAction];
    [self presentViewController:alerControl animated:YES completion:nil];
}

- (void)dealloc
{
    self.slideShow.zummDelegate = nil;
    self.slideShow = nil;
    self.titleLabel = nil;
    self.descriptionLabel = nil;
    self.contentScrollView = nil;
    self.selectedMovie = nil;
}

@end
