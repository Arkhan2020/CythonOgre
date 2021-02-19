from cpython.ref cimport PyObject
from libcpp.string cimport string

cdef extern from "Ogre.h":
    pass

cdef extern from "OgreApplicationContext.h":
    pass

cdef extern from "OgreInput.h":
    pass

cdef extern from "OgreRTShaderSystem.h":
    pass

cdef extern from "OgreApp.h" namespace "CythonOgre":
    cdef cppclass OgreApp:
        OgreApp(PyObject *obj) except +
        const string getTitle() except +
        void startApp()
        void stopApp()
        void run()
