#include <Ogre.h>
#include <OgreApplicationContext.h>

using namespace Ogre;
using namespace OgreBites;

namespace CythonOgre {

class OgreApp : public ApplicationContext, public InputListener {
public:
	OgreApp();
	~OgreApp() {}
	void run();
	void setup() override;
	bool keyPressed(KeyboardEvent const & evt) override;
};

} // namespace CythonOgre
