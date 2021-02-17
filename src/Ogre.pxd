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
        OgreApp() except +
        void run()
