import traceback

from Ogre cimport OgreApp

cimport cpython.ref as cpy_ref
from cython.operator import dereference
from cpython.ref cimport PyObject
from libcpp.string cimport string

cdef class PyOgreApp:
    cdef OgreApp* thisptr
    def __cinit__(self):
       self.thisptr = new OgreApp(<cpy_ref.PyObject*>self)
    def __dealloc__(self):
       if self.thisptr:
           del self.thisptr
    def get_title(self): # This is the function called from C++
        return "Hello"
    def getTitle(self): # This is the function that calls C++ code
       return self.thisptr.getTitle().decode('UTF-8')
    def startApp(self):
       return self.thisptr.startApp()
    def stopApp(self):
       return self.thisptr.stopApp()
    def run(self):
       return self.thisptr.run()

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
app.run()
app.stopApp()
