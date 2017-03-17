# multistream

Create an iOS app that:
* Loads a list of videos from https://s3.amazonaws.com/livelike-webs/interviews/video_list.json
* Plays a video, and gives the user the opportunity switch to another video.
* Switching should be quick. ie, no backing out to another view.

## notes:

* I did not write any tests.
* The app does not display an error when it fails to load a stream (eg no network connection). I didn't have time to debug this.
* I've included some "spinners" to indicate background work, but these aren't always timed correctly. Eg. in the video doesn't start playing when the spinner stops.
* There are a few other misc other issues.
