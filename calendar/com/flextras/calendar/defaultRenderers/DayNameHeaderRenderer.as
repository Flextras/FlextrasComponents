/*
Copyright 2012 DotComIt, LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Additional Documentation, Samples, and Support may be available at http://www.flextras.com 

*/
package com.flextras.calendar.defaultRenderers
{
	import mx.controls.Label;
	import mx.events.FlexEvent;

	/**
	 * This class is the default dayNameHeaderRenderer used by the Flextras Calendar class.  It is used to display the day of week in the month and week states.  
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.Calendar#dayNames 
	 */
	public class DayNameHeaderRenderer extends Label
	{
		/**
		 *  Constructor.
		 */
		public function DayNameHeaderRenderer()
		{
			super();
			this.addEventListener(FlexEvent.DATA_CHANGE,onDataChange);
		}
		
		/**
		 * @private
		 * The default handler for the dataChange event.  It will convert the data to a string and replace the text of the label.
		 * 
		 * @param event
		 * 
		 */
		protected function onDataChange(event:FlexEvent):void{
			this.text = String(data);
		}
		
	}
}