These are simple instructions for how to compile the Spark AutoCompleteComboBox into a SWC for use in a Flex Application.  This code has been tested against Adobe Flex 4.5, and is believed to work against later versions such as Adobe Flex 4.6 and Apache Flex 4.8. 

To build this component with Flash Builder, follow these steps:

1)	Create a Flash Builder Library Project
2)	Put the Spark directory from this repository into the Flash Builder Library Project’s source directory.
3)	Include design.xml and manifest.xml in project [Optional]
	a.	Bring up project properties on your Library Project
	b.	Select Flex Library Build Path
	c.	Select Assets
	d.	Select design.xml and manifest.xml
4)	Set up namespace URL [Optional]: 
	a.	Bring up project properties on your Library Project
	b.	Select Flex Library Compiler
	c.	Click Browse next to manifest file; and select the manifest file on your disc
	d.	Enter “http://www.flextras.com/mxml”  in the namespace URL box
5)	From the Project menu select Clean; and your Library Project’s bin directory should have built a SWC.  

You will find binary builds, samples, documentation, and support information at www.Flextras.com 