from cpython.ref cimport PyObject
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef extern from "Ogre.h" namespace "Ogre":
    cdef cppclass Root:
        bool endRenderingQueued()
        bool renderOneFrame()

cdef extern from "OgreInput.h" namespace "OgreBites":
    ctypedef int Keycode
    cdef struct Keysym:
        Keycode sym
        unsigned short mod
    cdef struct KeyboardEvent:
        int type
        Keysym keysym
        unsigned char repeat

cdef extern from "OgreRTShaderSystem.h":
    pass

cdef extern from "OgreApplicationContext.h":
    pass

cdef extern from "PyApplicationContext.h" namespace "CythonOgre":
    cdef cppclass PyApplicationContext:
        PyApplicationContext(PyObject *obj) except +
        Root* getRoot()
        const string getTitle() except +
        void startApp(vector[string] config_dirs)
        void stopApp()
        void run()
