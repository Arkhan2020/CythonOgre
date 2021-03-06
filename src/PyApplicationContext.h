#include <Ogre.h>
#include <OgreApplicationContext.h>

using namespace Ogre;
using namespace OgreBites;

#define PY_SSIZE_T_CLEAN
#include <Python.h>

#include <string>
#include <vector>

namespace CythonOgre {

class PyApplicationContext : public ApplicationContext, public InputListener {
public:
    PyApplicationContext(PyObject *obj);
    virtual ~PyApplicationContext();
    void setup() override;
    bool keyPressed(KeyboardEvent const & evt) override;

    void startApp(const std::vector<std::string>& config_dirs);
    void stopApp();

private:
    PyObject *m_obj;

    void callCythonVoidReturnVoid(std::string methodName) const;
    std::string callCythonVoidReturnString(std::string) const;
    bool callCythonVoidReturnBool(std::string) const;
    bool callCythonKeyboardEventReturnBool(std::string, KeyboardEvent const & evt) const;
};

} // namespace CythonOgre
