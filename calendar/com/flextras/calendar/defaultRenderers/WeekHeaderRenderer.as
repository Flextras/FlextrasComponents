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
	import com.flextras.calendar.ICalendarHeaderDataVO;
	import com.flextras.calendar.IWeekHeader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.flextras.calendar.CalendarChangeEvent;

	
	
	// week header event metadata 
	include "../inc/WeekHeaderEventMetaData.as";
	
	/**
	 * This class is the default header for the Flextras Calendar’s week state.  It will display a next day button, a previous day button, and a string that contains the month and year.
	 * 
	 * @see com.flextras.calendar.Calendar 
	 * @see com.flextras.calendar.WeekDisplay
	 * @see com.flextras.calendar.IWeekHeader
	 * 
	 */
	public class WeekHeaderRenderer extends CalendarHeaderBase implements IWeekHeader
	{
		/**
		 *  Constructor.
		 */
		public function WeekHeaderRenderer()
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
			
			if(this.weekHeaderDataChanged == true){
				this.label.text = this.createLabelText();
				
				this.weekHeaderDataChanged == false;
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
			this.previousButton.toolTip = "Previous Week";
			this.nextButton.toolTip = "Next Week";
		}
		
	
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  weekHeaderData
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property.
		 */
		private var _weekHeaderData:ICalendarHeaderDataVO;
		private var weekHeaderDataChanged : Boolean = false;
		
		[Bindable("weekHeaderDataChange")]
		[Inspectable(environment="none")]
		
		/**
		 *  @inheritDoc
		 */
		public function get weekHeaderData():ICalendarHeaderDataVO
		{
			return _weekHeaderData;
		}
		
		/**
		 *  @private
		 */
		public function set weekHeaderData(value : ICalendarHeaderDataVO):void
		{
			_weekHeaderData = value;
			weekHeaderDataChanged = true;
			
			this.invalidateProperties();
			dispatchEvent(new Event('weekHeaderDataaChange'));
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
			if(!this.weekHeaderData){
				return super.createLabelText();
			}
			return this.weekHeaderData.monthName + this.weekHeaderData.monthSymbol + ' ' + this.weekHeaderData.displayedYear;	
		} 

		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 * This method will dispatch the NEXT_DAY event.
		 * 
		 * @see com.flextras.calendar.CalendarChangeEvent
		 * @see com.flextras.calendar.CalendarChangeEvent#NEXT_DAY
		 */
		override protected function onNextClick(e:MouseEvent):void{
			this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.NEXT_WEEK,false,false));
		}
		/**
		 * @inheritDoc
		 * This method will dispatch the PREVIOUS_DAY event.
		 * 
		 * @see com.flextras.calendar.CalendarChangeEvent
		 * @see com.flextras.calendar.CalendarChangeEvent#PREVIOUS_DAY
		 */
		override protected function onPreviousClick(e:MouseEvent):void{
			this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.PREVIOUS_WEEK,false,false));
		}
		
	
	}
}