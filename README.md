# multistream

Create an iOS app that:
* Loads a list of videos from https://s3.amazonaws.com/livelike-webs/interviews/video_list.json
* Plays a video, and gives the user the opportunity switch to another video.
* Switching should be quick. ie, no backing out to another view.

## notes:

* I did not write any unit tests.
* I did not debug error states as fully as I would have liked (eg, airplane mode).
* When the stream stalls, there's no indication.
* There's no particular handling of the case when the stream gets to the end.
* I only tested briefly on iPad.
* I've included some "spinners" (Activity views) to indicate loading and so on, but these can be touchy on iOS, and I didn't have a chance to fully test them.
* There are a few other misc other issues.

## Compile and run

* I included a full XCode peoject which should compile and run on the simulator as usual with minimal or no changes.
  * You may have to tweak the signing team in the project settings.
* To run on a device, you'll need to setup a provisioning profile and so on, as usual.
