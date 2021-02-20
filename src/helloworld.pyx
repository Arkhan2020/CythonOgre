import os
import traceback

from Ogre cimport PyApplicationContext, KeyboardEvent

from cpython.ref cimport PyObject
from cython.operator import dereference
from libc.stdlib cimport calloc, free
from libc.string cimport memcpy
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef class _OgreKeyboardEvent:
    cdef KeyboardEvent* _evt
    def __cinit__(self, event):
        self._evt = <KeyboardEvent*>event
    def get_type(self):
        return self._evt.type
    def get_repeat(self):
        return self._evt.repeat
    def get_keysym_mod(self):
        return self._evt.keysym.mod
    def get_keysym_code(self):
        return self._evt.keysym.sym

class OgreKeyboardEvent(_OgreKeyboardEvent):
    pass

cdef public api:
    string cyfunc_string_void(object obj, string method, string *error) with gil:
        try:
            func = getattr(obj, method.decode('UTF-8'))
            ret_value = func()
            return ret_value.encode('UTF-8')
        except Exception as e:
            error[0] = traceback.format_exc().encode('UTF-8')
        return b""

    bool cyfunc_bool_void(object obj, string method, string *error) with gil:
        try:
            func = getattr(obj, method.decode('UTF-8'))
            ret_value = func()
            return ret_value
        except Exception as e:
            error[0] = traceback.format_exc().encode('UTF-8')
        return 0

    bool cyfunc_bool_KeyboardEvent(object obj, string method, string *error, const KeyboardEvent * event) with gil:
        try:
            func = getattr(obj, method.decode('UTF-8'))
            ret_value = func(OgreKeyboardEvent(<object>event))
            return ret_value
        except Exception as e:
            error[0] = traceback.format_exc().encode('UTF-8')
        return 0

cdef class _OgreApplicationContext:
    cdef PyApplicationContext* thisptr
    def __cinit__(self):
       self.thisptr = new PyApplicationContext(<PyObject*>self)
    def __dealloc__(self):
       if self.thisptr:
           del self.thisptr
    def getTitle(self):
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
    # Events called from C++
    def get_title(self):
        return "Hello"
    def key_pressed(self, event):
        print("Key Pressed: " + str(event.get_keysym_code()))
        return 0

class OgreApplicationContext(_OgreApplicationContext):
    def get_title(self):
        return "What"

app = OgreApplicationContext()
print(app.getTitle())
app.startApp()
while not app.endRenderingQueued():
    if not app.renderOneFrame():
        break
app.stopApp()
