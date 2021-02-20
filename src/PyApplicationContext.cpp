#include "PyApplicationContext.h"

#include "helloworld_api.h"

#include <cstdlib>
#include <iostream>
#include <string>

namespace CythonOgre {

PyApplicationContext::PyApplicationContext(PyObject *obj) : ApplicationContext{"CythonOgreTestApp"}, m_obj(obj) {
    if (import_helloworld()) {
        std::cerr << "Error executing import_helloworld!\n";
        throw std::runtime_error("Error executing import_helloworld");
    } else {
        Py_XINCREF(this->m_obj);
    }
}

PyApplicationContext::~PyApplicationContext() {
    PyGILState_STATE gstate;
    gstate = PyGILState_Ensure();
    Py_XDECREF(this->m_obj);
    PyGILState_Release(gstate);
}

std::string PyApplicationContext::callCythonVoidReturnString(std::string methodName) const {
    if (!this->m_obj) {
        throw std::runtime_error("Python object not set");
    }
    std::string error;
    std::string ret_val = cyfunc_string_void(this->m_obj, methodName, &error);
    if (!error.empty()) {
        throw std::runtime_error(error);
    }
    return ret_val;
}

bool PyApplicationContext::callCythonVoidReturnBool(std::string methodName) const {
    if (!this->m_obj) {
        throw std::runtime_error("Python object not set");
    }
    std::string error;
    bool ret_val = cyfunc_bool_void(this->m_obj, methodName, &error);
    if (!error.empty()) {
        throw std::runtime_error(error);
    }
    return ret_val;
}

std::string PyApplicationContext::getTitle() const {
    return callCythonVoidReturnString("get_title");
}


bool PyApplicationContext::keyPressed(KeyboardEvent const & evt) {
    if (evt.keysym.sym == SDLK_ESCAPE) {
        getRoot()->queueEndRendering();
        return true;
    } else { // key not processed
        return false;
    }
}

void PyApplicationContext::setup() {
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

void PyApplicationContext::startApp(const std::vector<std::string>& config_dirs) {
    //~ Ogre::String configDir = Ogre::StringUtil::standardisePath(".");
    //~ getFSLayer().setConfigPaths({ configDir });
    getFSLayer().setConfigPaths(config_dirs);
    initApp();
    getRoot()->getRenderSystem()->_initRenderTargets();
    getRoot()->clearEventTimes();
}

void PyApplicationContext::stopApp() {
    closeApp();
}

} // namespace CythonOgre
