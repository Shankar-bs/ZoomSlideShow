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
#import "ViewController.h"

#import "MovieDetailController.h"
#import "Movie.h"

#import "ZummSlide.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,ZummSlideDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) ZummSlide *zumSlideView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createMoviesList];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,self.movieListTableView.frame.size.width, 300.0f)];
    headerView.backgroundColor = [UIColor greenColor];
    [self setUpZummSlideForHeader:headerView];
    self.movieListTableView.tableHeaderView = headerView;
    self.movieListTableView.tableHeaderView.contentMode = UIViewContentModeScaleAspectFit;
    self.movieListTableView.tableHeaderView.frame = CGRectMake(0.0, 0.0,self.movieListTableView.frame.size.width, 300.0f);
    self.movieListTableView.tableHeaderView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------------------------------------------Initilisers methods--------------------------------------------------------------------

- (void)setUpZummSlideForHeader:(UIView *)headerView
{
    _zumSlideView = [[ZummSlide alloc] initWithFrame:headerView.bounds];
    _zumSlideView.animationDuration = 3.5f;
    _zumSlideView.timeIntervell = 5.0f;
    _zumSlideView.zoomDepth     = 2.5f;
    _zumSlideView.zummDelegate = self;
    [headerView addSubview:_zumSlideView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_zumSlideView startSlideShow];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_zumSlideView stopSlideShow];
}

- (void)createMoviesList
{
    Movie *quantum = [[Movie alloc] initMoivieTitle:@"Quantum of solace" description:@"Quantum of Solace is the twenty-second James Bond film produced by Eon Productions, and is the direct sequel to the 2006 film Casino Royale. Directed by Marc Forster, it features Daniel Craig's second performance as James Bond. In the film, Bond seeks revenge for the death of his lover, Vesper Lynd, and is assisted by Camille Montes (Olga Kurylenko), who is plotting revenge for the murder of her family. The trail eventually leads them to wealthy businessman Dominic Greene (Mathieu Amalric), a member of the Quantum organisation, who intends to stage a coup d'état in Bolivia to seize control of that country's water supply." withIndex:0];
    
    Movie *avatar = [[Movie alloc] initMoivieTitle:@"Avatar" description:@"Avatar (marketed as James Cameron's Avatar) is a 2009 American epic science fiction film directed, written, produced, and co-edited by James Cameron, and starring Sam Worthington, Zoe Saldana, Stephen Lang, Michelle Rodriguez, and Sigourney Weaver. The film is set in the mid-22nd century, when humans are colonizing Pandora, a lush habitable moon of a gas giant in the Alpha Centauri star system, in order to mine the mineral unobtanium, a room-temperature superconductor.The expansion of the mining colony threatens the continued existence of a local tribe of Na'vi – a humanoid species indigenous to Pandora. The film's title refers to a genetically engineered Na'vi body with the mind of a remotely located human that is used to interact with the natives of Pandora." withIndex:1];
    
    Movie *bolt = [[Movie alloc] initMoivieTitle:@"Bolt" description:@"Bolt is a 2008 American computer animated road-comedy-adventure film produced by Walt Disney Animation Studios and released by Walt Disney Pictures. It is the studio's 48th animated feature. Directed by Chris Williams and Byron Howard, the film stars the voices of John Travolta, Miley Cyrus, Malcolm McDowell, Diedrich Bader, Nick Swardson, Greg Germann, Susie Essman and Mark Walton. The film's plot centers on a small white dog named Bolt who, having spent his entire life on the set of a television series, thinks that he has super powers. When he believes that his human, Penny, has been kidnapped, he sets out on a cross-country journey to rescue her." withIndex:2];
    
    Movie *ironMan = [[Movie alloc] initMoivieTitle:@"Iron Man" description:@"Iron Man is a 2008 American superhero film featuring the Marvel Comics character of the same name, produced by Marvel Studios and distributed by Paramount Pictures.1 It is the first film in the Marvel Cinematic Universe. The film was directed by Jon Favreau, with a screenplay by Mark Fergus & Hawk Ostby and Art Marcum & Matt Holloway. It stars Robert Downey Jr., Terrence Howard, Jeff Bridges, Shaun Toub and Gwyneth Paltrow. In Iron Man, Tony Stark, an industrialist and master engineer, builds a powered exoskeleton and becomes the technologically advanced superhero Iron Man." withIndex:3];
    
    Movie *darkKnight = [[Movie alloc] initMoivieTitle:@"The Dark Knight" description:@"The Dark Knight is a 2008 superhero film directed, produced, and co-written by Christopher Nolan. Featuring the DC Comics character Batman, the film is the second part of Nolan's The Dark Knight Trilogy and a sequel to 2005's Batman Begins, starring an ensemble cast including Christian Bale, Michael Caine, Heath Ledger, Gary Oldman, Aaron Eckhart, Maggie Gylenhaal and Morgan Freeman. In the film, Bruce Wayne/Batman (Bale), James Gordon (Oldman) and Harvey Dent (Eckhart) form an alliance to dismantle organised crime in Gotham City, but are menaced by a criminal mastermind known as the Joker who seeks to undermine Batman's influence and create chaos." withIndex:4];
    self.movies = [NSArray arrayWithObjects:quantum,avatar,bolt,ironMan,darkKnight, nil];
}

#pragma mark -----------------------------------------------Table view datasource and delegate methods--------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    Movie *movie = self.movies[indexPath.row];
    cell.textLabel.text = movie.movieTitle;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieDetailController *detailController = [self.storyboard  instantiateViewControllerWithIdentifier:@"MovieDetailContoller"];
    detailController.selectedMovie = self.movies[indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

#pragma mark -----------------------------------------------Zumm slide delgate methods--------------------------------------------------------------------

- (NSInteger)numberOfImagesForZomSlideShow
{
    return 25;
}

- (UIImage *)imageForSlideShowForZomSlideShowView:(ZummSlide *)zomView AtIndex:(NSInteger)index
{
    UIImage *image = nil;
    image = [self getRandomImageFromIndex:index];
    return image;
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

#pragma mark -----------------------------------------------Helpers methods--------------------------------------------------------------------

- (UIImage *)getRandomImageFromIndex:(NSInteger)index
{
    NSInteger randIndex =  arc4random_uniform(25);
    NSLog(@"randIndex:%ld",(long)randIndex);
    NSString *path = nil;
    if(randIndex < 25)
    {
        CGFloat   randIndex =  arc4random_uniform(25);
        CGFloat   num = ((randIndex / 25) * 10)/2;
        NSInteger divIndex =   floor(num);
        NSInteger randSerialIndex = arc4random_uniform(5);
        NSString *imageName = [NSString stringWithFormat:@"%ld_%ld",(long)divIndex,(long)randSerialIndex];
        NSLog(@"imageName:%@",imageName);
        path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        return [UIImage imageWithContentsOfFile:path];
    }
    else
    {
        path = [[NSBundle mainBundle] pathForResource:@"0_0" ofType:@"jpg"];
        return [UIImage imageWithContentsOfFile:path];
    }
}

@end
