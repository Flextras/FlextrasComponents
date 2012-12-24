These are simple instructions for how to compile the Flextras Calendar into a SWC for use in a Flex Application.  This code has been tested against Adobe Flex 4.0, and is believed to work against later versions such as Adobe Flex 4.6 and Apache Flex 4.8.

This Calendar Component makes use of the Flex DateUtils library found at http://flexdateutils.riaforge.org/ .  You will need to download that library in order to compile this Calendar.

To build this component with Flash Builder, follow these steps:
1)	Create a Flash Builder Library Project
2)	Put the com directory from this repository into the Flash Builder Library Project’s source directory.
3)	In the Library Path add the SWC containing the Flex DateUtils library compiled from http://flexdateutils.riaforge.org/ .  Alternatively you could create a source path pointed at a directory including the DateUtils source.  
4)	Exclude the Include Files
	a.	Bring up project properties on your Library Project
	b.	Select  Flex Library Build Path
	c.	Select Classes
	d.	Select “Select classes to include in library”
	e.	Select All by clicking on the com; which should be the root directory
	f.	Unselect the “com/flextras/calendar/inc”
5)	Include design.xml and manifest.xml in project [Optional]
	a.	Bring up project properties on your Library Project
	b.	Select Flex Library Build Path
	c.	Select Assets
	d.	Select design.xml and manifest.xml
6)	Set up namespace URL [Optional]:
	a.	Bring up project properties on your Library Project
	b.	Select Flex Library Compiler
	c.	Click Browse next to manifest file; and select the manifest file on your disc
	d.	Enter “http://www.flextras.com/mxml”  in the namespace URL box
7)	From the Project menu select Clean; and your Library Project’s bin directory should have built a SWC.

You will find binary builds, samples, documentation, and support information at www.Flextras.com