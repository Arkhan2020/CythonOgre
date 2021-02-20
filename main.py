import helloworld

class Appclass(helloworld.OgreApplicationContext):
	pass

App=Appclass()
App.startApp()
while not App.endRenderingQueued():
    if not App.renderOneFrame():
        break
App.stopApp()
