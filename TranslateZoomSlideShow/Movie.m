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

#import "Movie.h"

@implementation Movie

- (instancetype)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (instancetype)initMoivieTitle:(NSString *)title description:(NSString *)description  withIndex:(NSInteger)movieIndex
{
    self = [super init];
    if(self)
    {
        self.movieTitle = title;
        self.movieDescription = description;
        self.movieId = movieIndex;
        [self initlisePosters];
    }
    return self;
}

- (void)initlisePosters
{
    _posterImages = [[NSMutableArray alloc] init];
    for(int k = 0;k< 5;k++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%ld_%d",(long)_movieId,k];
        [_posterImages addObject:imageName];
    }
}

@end
