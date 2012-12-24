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
package com.flextras.calendar
{
	import mx.controls.Label;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	/**
	 * This class is a default implementation of the IDayDataVO interface for use with the Flextras Calendar class.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.IDayDataVO
	 * @see com.flextras.calendar.Calendar
	 */
	public class DayDataVO implements IDayDataVO
	{
		/**
		 *  Constructor.
		 */
		public function DayDataVO(dayNumber:int, dataProvider : Object, displayedDateObject : Date  )
		{ 
			super();
			this.date = dayNumber;
			this.dataProvider = dataProvider;

			this.displayedDateObject = displayedDateObject;
		}

	    //----------------------------------
	    //  dayNumber
	    //----------------------------------
		private var _dayNumber : int;
	
		/**
		 * @inheritDoc
		 */
		public function get date():int{
			return this._dayNumber;
		}
		/**
		 * @private
		 */
		public function set date(value:int):void{
			this._dayNumber = value;
		}


	    //----------------------------------
	    //  dataProvider
	    //----------------------------------
		private var _dataProvider : Object;
	
		/**
		 * @copy mx.controls.listClasses.ListBase#dataProvider 
		 */
		public function get dataProvider():Object{
			return this._dataProvider;
		}
		/**
		 * @private
		 */
		public function set dataProvider(value:Object):void{
			this._dataProvider = value;
		}

	    //----------------------------------
	    //  displayedDateObject
	    //----------------------------------
		private var _displayedDateObject : Date;
	
		/**
		 * @inheritDoc
		 */
		public function get displayedDateObject():Date{
			return this._displayedDateObject;
		}
		/**
		 * @private
		 */
		public function set displayedDateObject(value:Date):void{
			this._displayedDateObject = value;
		}

	}
}