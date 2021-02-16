from Ogre cimport OgreApp

print("Hello, World!")

cdef OgreApp* app_ptr = new OgreApp()
app_ptr.run()
