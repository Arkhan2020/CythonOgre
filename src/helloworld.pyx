import os
import traceback

from Ogre cimport OgreApp

from cpython.ref cimport PyObject
from cython.operator import dereference
from cpython.ref cimport PyObject
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef class PyOgreApp:
    cdef OgreApp* thisptr
    def __cinit__(self):
       self.thisptr = new OgreApp(<PyObject*>self)
    def __dealloc__(self):
       if self.thisptr:
           del self.thisptr
    def get_title(self): # This is the function called from C++
        return "Hello"
    def getTitle(self): # This is the function that calls C++ code
       return self.thisptr.getTitle().decode('UTF-8')
    def startApp(self, config_dirs = [os.path.realpath(__file__)]):
       cdef vector[string] dirs = [os.path.realpath(dir).encode('UTF-8') for dir in config_dirs]
       return self.thisptr.startApp(dirs)
    def stopApp(self):
       return self.thisptr.stopApp()
    def endRenderingQueued(self):
       return self.thisptr.getRoot().endRenderingQueued()
    def renderOneFrame(self):
       return self.thisptr.getRoot().renderOneFrame()

cdef public api:
    string string_cy_call_fct(object obj, string method, string *error) with gil:
        """Lookup and execute a pure virtual method returning a string"""
        try:
            func = getattr(obj, method.decode('UTF-8'))
            ret_str = func()
            return ret_str.encode('UTF-8')
        except Exception as e:
            error[0] = traceback.format_exc().encode('UTF-8')
        return b""

app = PyOgreApp()
print(app.getTitle())
app.startApp()
while not app.endRenderingQueued():
    if not app.renderOneFrame():
        break
app.stopApp()
