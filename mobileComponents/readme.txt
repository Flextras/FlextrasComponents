These are simple instructions for how to compile our Mobile Components into a SWC for use in a Flex Mobile Application.  The Mobile Application set includes:

1)	An AutoComplete component, with mobile optimized skins
2)	A DropDownList component, with mobile optimized skins 
3)	A Radio Button Renderer
4)	A Button skin with no rounded corners.

This code has been tested against Adobe Flex 4.5, and is believed to work against later versions such as Adobe Flex 4.6 and Apache Flex 4.8. 

To build this component with Flash Builder, follow these steps:

1)	Create a Flash Builder Library Project
2)	Put the com directory from this repository into the Flash Builder Library Project’s source directory.
3)	In the Library Path add a link to the Flex SDK Mobile.swc.  This should be at [FlexSDKInstallDirectory]\frameworks\themes\Mobile\mobile.swc
4)	In the Library Path add a the SWC containing the Flextras Spark AutoComplete compiled from https://github.com/Flextras/FlextrasComponents/tree/master/autoCompleteComboBox/Spark .  Alternatively you could create a source path pointed at that directory.  
5)	Include design.xml and manifest.xml in project [Optional]
	a.	Bring up project properties on your Library Project
	b.	Select Flex Library Build Path
	c.	Select Assets
	d.	Select design.xml and manifest.xml
6)	Set up namespace URL [Optional]:: 
	a.	Bring up project properties on your Library Project
	b.	Select Flex Library Compiler
	c.	Click Browse next to manifest file; and select the manifest file on your disc
	d.	Enter “http://www.flextras.com/mxml”  in the namespace URL box
7)	From the Project menu select Clean; and your Library Project’s bin directory should have built a SWC.

You will find binary builds, samples, documentation, and support information at www.Flextras.com
