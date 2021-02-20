#include <Ogre.h>
#include <OgreApplicationContext.h>

using namespace Ogre;
using namespace OgreBites;

#define PY_SSIZE_T_CLEAN
#include <Python.h>

#include <string>
#include <vector>

namespace CythonOgre {

class OgreApp : public ApplicationContext, public InputListener {
public:
	OgreApp(PyObject *obj);
	virtual ~OgreApp();
	void setup() override;
	bool keyPressed(KeyboardEvent const & evt) override;
	virtual std::string getTitle() const;

	void startApp(const std::vector<std::string>& config_dirs);
	void stopApp();

private:
	PyObject *m_obj;
	std::string callCythonReturnString(std::string) const;

};

} // namespace CythonOgre
