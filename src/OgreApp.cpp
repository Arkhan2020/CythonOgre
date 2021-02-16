#include "OgreApp.h"

namespace CythonOgre {

OgreApp::OgreApp() : ApplicationContext{"CythonOgreTestApp"} {
}

bool OgreApp::keyPressed(KeyboardEvent const & evt) {
	if (evt.keysym.sym == SDLK_ESCAPE)
	{
		getRoot()->queueEndRendering();
		return true;
	}
	else
		return false;  // key not processed
}

void OgreApp::setup() {
	ApplicationContext::setup();
	addInputListener(this);  // register for input events

	SceneManager * scene = getRoot()->createSceneManager();
	scene->setAmbientLight(ColourValue{0.5, 0.5, 0.5});

	// register our scene with the RTSS
	RTShader::ShaderGenerator * shadergen =
		RTShader::ShaderGenerator::getSingletonPtr();
	shadergen->addSceneManager(scene);

	SceneNode * root_node = scene->getRootSceneNode();

	// without light we would just get a black screen
	Light * light = scene->createLight("MainLight");
	SceneNode * light_node = root_node->createChildSceneNode();
	light_node->setPosition(20, 80, 50);
	light_node->attachObject(light);

	// create camera so we can observe scene
	Camera * camera = scene->createCamera("MainCamera");
	camera->setNearClipDistance(5);  // specific to this sample
	camera->setAutoAspectRatio(true);
	SceneNode * camera_node = root_node->createChildSceneNode();
	camera_node->setPosition(0, 0, 140);
	camera_node->lookAt(Vector3{0, 0, -1}, Node::TS_PARENT);
	camera_node->attachObject(camera);

	getRenderWindow()->addViewport(camera);  // render into the main window

	// finally something to render
	Entity * ent = scene->createEntity("ogrehead.mesh");
	SceneNode * node = root_node->createChildSceneNode();
	node->attachObject(ent);
}

void OgreApp::run() {
	initApp();
	getRoot()->getRenderSystem()->_initRenderTargets();
	getRoot()->clearEventTimes();

	// Infinite loop, until broken out of by frame listeners
	// or break out by calling queueEndRendering()
	while (!getRoot()->endRenderingQueued()) {
		if (!getRoot()->renderOneFrame()) {
			break;
		}
	}

	closeApp();
}

} // namespace CythonOgre
