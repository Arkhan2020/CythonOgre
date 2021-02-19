#include <Ogre.h>
#include <OgreApplicationContext.h>

using namespace Ogre;
using namespace OgreBites;

#define PY_SSIZE_T_CLEAN
#include <Python.h>

#include <string>

namespace CythonOgre {

class OgreApp : public ApplicationContext, public InputListener {
public:
	OgreApp(PyObject *obj);
	virtual ~OgreApp();
	void run();
	void setup() override;
	bool keyPressed(KeyboardEvent const & evt) override;
	virtual std::string getTitle() const;

	void startApp();
	void stopApp();

private:
	PyObject *m_obj;
	std::string callCythonReturnString(std::string) const;

};

} // namespace CythonOgre
