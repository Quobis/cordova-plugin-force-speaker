#import "Speaker.h"

@implementation Speaker

- (void)pluginInitialize {
    NSLog(@"Initializing Speaker plugin");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(routeChange:)
                                          name:AVAudioSessionRouteChangeNotification
                                          object:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                                       error:nil];
    NSLog(@"Speaker plugin initialized");
}

- (void)routeChange:(NSNotification*)notification {
    NSLog(@"Audio device route changed!");
    AVAudioSession* session = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *currentRoute = session.currentRoute;
    NSArray<AVAudioSessionPortDescription *> *outputs = currentRoute.outputs;
    if ([outputs count] == 0) {
        return;
    }
    AVAudioSessionPortDescription *output = [outputs objectAtIndex:0];
    NSLog(@"current output name %@ type %@", [output portName], [output portType]);
    if ([[output portType] isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
        NSError* error;
        [session setActive: YES error: nil];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    }
}
@end
