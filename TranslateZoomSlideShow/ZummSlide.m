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

#import "ZummSlide.h"


#define  NEXT_INDEX(index, count) (index == (count - 1)) ? index = 0 : (index < (count - 1)) ? (index = ((1 + index) % count)) : 0
#define  BACK_INDEX(index, count) (index ==  0 ) ? (index = (count - 1)) : (index <= (count - 1)) ? index = (index - 1) : 0

#define DEFAULT_TAP_ANIMATION_DURATION 0.3

@interface ZummSlide ()
{
    NSInteger currentImageIndex;
    NSInteger imageCount;
    UIColor  *backgroundColor;
}


@end

@implementation ZummSlide

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self commonSetUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self commonSetUp];
    }
    return self;
}

- (void)awakeFromNib
{
  [self commonSetUp];
}

- (void)commonSetUp
{
    imageCount = 0;
    currentImageIndex = 0;
    _zoomDepth = 0.5f;
    self.currentImage = nil;
    self.nextImage    = nil;
    self.backgroundColor = [UIColor blackColor];
    self.layer.backgroundColor = _backGroundColor.CGColor;

    _frontLayer = [[CALayer alloc] init];
    _frontLayer.backgroundColor = [UIColor clearColor].CGColor;
  
    _backLayer = [[CALayer alloc] init];
    _backLayer.backgroundColor = [UIColor clearColor].CGColor;

    self.layer.masksToBounds = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
    UITapGestureRecognizer *tap       = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    [self.layer addSublayer:_backLayer];
    [self.layer addSublayer:_frontLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _frontLayer.frame = self.bounds;
    _backLayer.frame = self.bounds;
}

#pragma mark ------------------------------------------------------Setters methods--------------------------------------------------------------------

- (void)setTimeIntervell:(NSTimeInterval)inTimeIntervell
{
    _timeIntervell = inTimeIntervell;
}

- (void)setBackGroundColor:(UIColor *)backGroundColor
{
    _backGroundColor = backgroundColor;
    self.layer.backgroundColor = backGroundColor.CGColor;
}

#pragma mark ------------------------------------------------------Instance methods--------------------------------------------------------------------

- (void)startSlideShow
{
    if(self.slideTimer)
    {
        [self.slideTimer invalidate];
        self.slideTimer = nil;
    }
    
    if(_animationDuration  < _timeIntervell)
    {
        imageCount = ([self.zummDelegate respondsToSelector:@selector(numberOfImagesForZomSlideShow)]) ? [self.zummDelegate numberOfImagesForZomSlideShow] : 0;
        currentImageIndex = 0;
        self.currentImage = [self.zummDelegate imageForSlideShowForZomSlideShowView:self AtIndex:0];
        _frontLayer.contents = (id)self.currentImage.CGImage;
        self.slideTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeIntervell target:self selector:@selector(changeImage:) userInfo:@{@"next":[NSNumber numberWithBool:YES],@"duration":[NSNumber numberWithFloat:self.animationDuration]} repeats:YES];
    }
    else
    {
        if([self.zummDelegate respondsToSelector:@selector(showAlert)])
        {
            [self.zummDelegate showAlert];
        }
    }
}

#pragma mark ------------------------------------------------------Starters methods--------------------------------------------------------------------


- (void)changeImage:(NSTimer *)inTimer
{
    NSDictionary *inDictionary = inTimer.userInfo;
    BOOL showNext = [inDictionary[@"next"] boolValue];
    CGFloat duration = [inDictionary[@"duration"] floatValue];
    [self changeImage:showNext withDuration:duration];
}


- (void)stopSlideShow
{
    [self.slideTimer invalidate];
    self.slideTimer = nil;
}

#pragma mark ------------------------------------------------------Timer methods-----------------------------------------------------------------------

- (void)changeImage:(BOOL)next withDuration:(CGFloat)duration
{
    if(self.nextImage != nil)
        self.currentImage = self.nextImage;
    self.nextImage = ([self.zummDelegate respondsToSelector:@selector(imageForSlideShowForZomSlideShowView:AtIndex:)]) ?  [self.zummDelegate imageForSlideShowForZomSlideShowView:self AtIndex:(next)? NEXT_INDEX(currentImageIndex, imageCount) : BACK_INDEX(currentImageIndex, imageCount)]: nil;
    self.backLayer.contents = (id)self.nextImage.CGImage;
    self.frontLayer.contents = (id)self.currentImage.CGImage;
    self.backLayer.transform = CATransform3DMakeScale(_zoomDepth, _zoomDepth, _zoomDepth);
    self.backLayer.opacity = 0.0f;
    self.backLayer.zPosition = -2;
    [self slideImageWithZoom:duration];
}

#pragma mark ------------------------------------------------------Zumm methods--------------------------------------------------------------------
- (void)slideImageWithZoom:(CGFloat)duration
{
    [self.backLayer removeAllAnimations];
    [self.frontLayer removeAllAnimations];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setFromValue:[NSNumber numberWithFloat:1.0f]];
    [animation setToValue:[NSNumber numberWithFloat:_zoomDepth]];
    [animation setRemovedOnCompletion:YES];
    [animation setFillMode:kCAFillModeForwards];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    opacityAnimation.toValue   = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:animation,opacityAnimation, nil];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.duration = duration;
    
    CABasicAnimation *backLayerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CATransform3D trFrom = CATransform3DIdentity;
    CATransform3DScale(trFrom, _zoomDepth, _zoomDepth, _zoomDepth);
    [backLayerAnimation setFromValue:[NSValue valueWithCATransform3D:_backLayer.transform]];
    [backLayerAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [backLayerAnimation setRemovedOnCompletion:YES];
    [backLayerAnimation setFillMode:kCAFillModeForwards];
    
    CABasicAnimation *backOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    backOpacityAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    backOpacityAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    CAAnimationGroup *backGroup = [CAAnimationGroup animation];
    backGroup.animations = [NSArray arrayWithObjects:backLayerAnimation,backOpacityAnimation, nil];
    backGroup.fillMode = kCAFillModeForwards;
    backGroup.removedOnCompletion = NO;
    backGroup.duration = duration;
    
    [_frontLayer  addAnimation:group forKey:@"frontLayerAnimation"];
    [_backLayer   addAnimation:backGroup forKey:@"backLayerAnimation"];
}

- (void)refeshWithAnimation
{
    [self  stopSlideShow];
    [self  startSlideShow];
}

- (void)handlePan:(UIGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
            [self stopSlideShow];
           // frontLayer.speed = 0.0f;
          //  backLayer.speed  = 0.0f;
           // NSLog(@"begin");
            if(_nextImage == nil)
            {
                UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)panGesture;
                CGPoint vel = [pan velocityInView:self];
                if (vel.x > 0)
                    [self changeImage:NO withDuration:_animationDuration];
                else
                    [self changeImage:YES withDuration:_animationDuration];
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)panGesture;
            CGPoint vel = [pan velocityInView:self];
            if (vel.x > 0)
            {
                // user dragged towards the right
                CGFloat x = [pan translationInView:self].x;
                x /= 100.0f;
                CFTimeInterval timeOffset = _frontLayer.timeOffset;
                _frontLayer.timeOffset = x + timeOffset;
                _backLayer.timeOffset  = x + timeOffset;

            }
            else
            {
                // user dragged towards the left
                CGFloat x = [pan translationInView:self].x;
                x /= 100.0f;
                CFTimeInterval timeOffset = _frontLayer.timeOffset;
                timeOffset = MIN(_animationDuration, MAX(0.0, timeOffset - x));
                _frontLayer.timeOffset =  timeOffset;
                _backLayer.timeOffset  =  timeOffset;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
           // NSLog(@"ended");
        {
            CFTimeInterval currentOffset  = _frontLayer.timeOffset;
            if(currentOffset >= _animationDuration)
            {
                _frontLayer.speed = 0.0f;
                _backLayer.speed  = 0.0f;
                _frontLayer.timeOffset = 0.0f;
                _backLayer.timeOffset  = 0.0f;
                UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)panGesture;
                CGPoint vel = [pan velocityInView:self];
                if (vel.x > 0)
                    [self changeImage:NO withDuration:_animationDuration];
                else
                    [self changeImage:YES withDuration:_animationDuration];
                
                //[self changeImage];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
           // NSLog(@"failed");
            break;
        default:
            break;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    [self stopSlideShow];
    _frontLayer.speed      = 1;
    _backLayer.speed       = 1;
    _frontLayer.timeOffset = 0;
    _backLayer.timeOffset  = 0;
    [self changeImage:YES withDuration:DEFAULT_TAP_ANIMATION_DURATION];
}

- (void)dealloc
{
    [self.slideTimer invalidate];
    self.slideTimer = nil;
    self.backGroundColor = nil;
    self.currentImage = nil;
    self.nextImage = nil;
    [_frontLayer removeAllAnimations];
    [_backLayer removeAllAnimations];
    
    self.frontLayer = nil;
    self.backLayer = nil;
}

@end


