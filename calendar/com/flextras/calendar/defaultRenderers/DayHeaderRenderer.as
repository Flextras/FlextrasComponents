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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.flextras.calendar.IDayHeader;
	import com.flextras.calendar.CalendarChangeEvent;
	import com.flextras.calendar.IDayHeaderDataVO;

	// day header event metadata 
	include "../inc/DayHeaderEventMetaData.as";
	
	/**
	 *  This class is the default header for the Flextras Calendar’s day state.  It will display a next day button, a previous day button, and a localized day string.  
	 *  
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar 
	 * @see com.flextras.calendar.DayDisplay
	 * @see com.flextras.calendar.IDayHeader
	 * 
	 */
	public class DayHeaderRenderer extends CalendarHeaderBase implements IDayHeader
	{
		/**
		 *  Constructor.
		 */
		public function DayHeaderRenderer()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------
		/** 
		 * @private
		 */
		override protected function commitProperties():void{
			
			super.commitProperties();
			
			if(this.dayHeaderDataChanged == true){
				this.label.text = this.createLabelText();
				
				this.dayHeaderDataChanged = false;
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}		
		
		/** 
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			// update children created in paren t
			this.previousButton.toolTip = "Previous Day";
			this.nextButton.toolTip = "Next Day";
		}

		
		//--------------------------------------------------------------------------
		//
		//  variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dayHeaderData
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property.
		 */
		private var _dayHeaderData:IDayHeaderDataVO;
		private var dayHeaderDataChanged : Boolean = false;
		
		[Bindable("dayHeaderDataChange")]
		/**
		 *  @inheritDoc
		 */
		public function get dayHeaderData():IDayHeaderDataVO
		{
			return _dayHeaderData;
		}
		
		/**
		 *  @private
		 */
		public function set dayHeaderData(value:IDayHeaderDataVO):void
		{
			_dayHeaderData = value;
			dayHeaderDataChanged = true;
			
			this.invalidateProperties();
			dispatchEvent(new Event('dayHeaderDataChange'));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * @inheritDoc  
		 *  
		 * @return A string made up of the dayName + space + displayDate. 
		 */
		override protected function createLabelText():String{
			if(!this.dayHeaderData){
				return super.createLabelText();
			}
			return this.dayHeaderData.dayData.displayedDateObject.toLocaleDateString();	
		}

		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 * 
		 * @see com.flextras.calendar.CalendarChangeEvent
		 * @see com.flextras.calendar.CalendarChangeEvent#NEXT_DAY
		 */
		override protected function onNextClick(e:MouseEvent):void{
			this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.NEXT_DAY,false,false));
		}
		/**
		 * @inheritDoc
		 * 
		 * @see com.flextras.calendar.CalendarChangeEvent
		 * @see com.flextras.calendar.CalendarChangeEvent#PREVIOUS_DAY
		 */
		override protected function onPreviousClick(e:MouseEvent):void{
			this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.PREVIOUS_DAY,false,false));
		}
		
	}
}