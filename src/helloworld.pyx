import os
import traceback

from Ogre cimport PyApplicationContext, KeyboardEvent, SceneManager, ShaderGenerator

from cpython.ref cimport PyObject
from cython.operator import dereference
from libc.stdlib cimport calloc, free
from libc.string cimport memcpy
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef class _OgreSceneManager:
    cdef SceneManager* thisptr
    def __cinit__(self):
        self.thisptr = NULL # Set pointer to null on object init

cdef class _OgreShaderGenerator:
    cdef ShaderGenerator* thisptr
    def __cinit__(self):
        self.thisptr = ShaderGenerator.getSingletonPtr()

cdef class _OgreKeyboardEvent:
    cdef KeyboardEvent* thisptr
    def __cinit__(self, event):
        self.thisptr = <KeyboardEvent*>event
    def get_type(self):
        return self.thisptr.type
    def get_repeat(self):
        return self.thisptr.repeat
    def get_keysym_mod(self):
        return self.thisptr.keysym.mod
    def get_keysym_code(self):
        return self.thisptr.keysym.sym

cdef public api:
    string cyfunc_void_void(object obj, string method, string *error) with gil:
        try:
            func = getattr(obj, method.decode('UTF-8'))
            func()
        except Exception as e:
            error[0] = traceback.format_exc().encode('UTF-8')

    string cyfunc_string_void(object obj, string method, string *error) with gil:
        try:
            func = getattr(obj, method.decode('UTF-8'))
            ret_value = func()
            return ret_value.encode('UTF-8')
        except Exception as e:
            error[0] = traceback.format_exc().encode('UTF-8')
        return b""

    bint cyfunc_bool_void(object obj, string method, string *error) with gil:
        try:
            func = getattr(obj, method.decode('UTF-8'))
            ret_value = func()
            return ret_value
        except Exception as e:
            error[0] = traceback.format_exc().encode('UTF-8')
        return 0

    bint cyfunc_bool_KeyboardEvent(object obj, string method, string *error, const KeyboardEvent * event) with gil:
        try:
            func = getattr(obj, method.decode('UTF-8'))
            ret_value = func(_OgreKeyboardEvent(<object>event))
            return ret_value
        except Exception as e:
            error[0] = traceback.format_exc().encode('UTF-8')
        return False

cdef class _OgreApplicationContext:
    cdef PyApplicationContext* thisptr
    def __cinit__(self):
        self.thisptr = new PyApplicationContext(<PyObject*>self)
    def __dealloc__(self):
        if self.thisptr:
            del self.thisptr
    def startApp(self, config_dirs = [os.path.realpath(__file__)]):
        cdef vector[string] dirs = [os.path.realpath(dir).encode('UTF-8') for dir in config_dirs]
        return self.thisptr.startApp(dirs)
    def stopApp(self):
        return self.thisptr.stopApp()
    def endRenderingQueued(self):
        return self.thisptr.getRoot().endRenderingQueued()
    def renderOneFrame(self):
        return self.thisptr.getRoot().renderOneFrame()
    def createSceneManager(self):
        obj = _OgreSceneManager()
        cdef SceneManager* ptr = self.thisptr.getRoot().createSceneManager()
        obj.thisptr = ptr
        return obj
    def setup(self):
        print("Set it up, Baby")
    def key_pressed(self, event):
        print("Key Pressed: " + str(event.get_keysym_code()))
        return 0

class OgreApplicationContext(_OgreApplicationContext):
    pass

#app = OgreApplicationContext()
#app.startApp()
#while not app.endRenderingQueued():
#    if not app.renderOneFrame():
#        break
#app.stopApp()
