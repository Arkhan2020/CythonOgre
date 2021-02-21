from cpython.ref cimport PyObject
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef extern from "Ogre.h" namespace "Ogre":
    cdef cppclass ColourValue:
        ColourValue(float red, float green, float blue, float alpha)
    cdef cppclass SceneManager:
        void setAmbientLight(const ColourValue &colour)
    cdef cppclass Root:
        bool endRenderingQueued()
        bool renderOneFrame()
        SceneManager* createSceneManager()
        SceneManager* createSceneManager(const string &typeName, const string &instanceName)

cdef extern from "OgreInput.h" namespace "OgreBites":
    ctypedef int Keycode
    cdef struct Keysym:
        Keycode sym
        unsigned short mod
    cdef struct KeyboardEvent:
        int type
        Keysym keysym
        unsigned char repeat

cdef extern from "OgreRTShaderSystem.h" namespace "Ogre::RTShader":
    cdef cppclass ShaderGenerator:
        @staticmethod
        ShaderGenerator* getSingletonPtr()
        void addSceneManager(SceneManager *sceneMgr)

cdef extern from "OgreApplicationContext.h":
    pass

cdef extern from "PyApplicationContext.h" namespace "CythonOgre":
    cdef cppclass PyApplicationContext:
        PyApplicationContext(PyObject *obj) except +
        Root* getRoot()
        void startApp(vector[string] config_dirs)
        void stopApp()
        void run()
