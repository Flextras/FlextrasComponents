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
	
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import com.flextras.calendar.CalendarChangeEvent;
	import com.flextras.calendar.IMonthHeader;
	import com.flextras.calendar.ICalendarHeaderDataVO;

	
	// month header event metadata 
	include "../inc/MonthHeaderEventMetaData.as";

	/**
	 * This class is the default header for the Flextras Calendar’s month state.  It will display a next day button, a previous day button, a next year button, a previous year button, and a string that contains the month and year. 
	 * 
	 * 
	 * @see com.flextras.calendar.Calendar 
	 * @see com.flextras.calendar.MonthDisplay
	 * @see com.flextras.calendar.IMonthHeader
	 * 
	 */
	public class MonthHeaderRenderer extends CalendarHeaderBase implements IMonthHeader
	{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function MonthHeaderRenderer()
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
		
		if(this.monthHeaderDataChanged == true){
			this.label.text = this.createLabelText();

			this.monthHeaderDataChanged == false;
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
    	this.previousButton.toolTip = "Previous Month";
    	this.nextButton.toolTip = "Next Month";
    	
    	// create button for previousYear
    	this.previousYearButton = new Button();
    	this.previousYearButton.toolTip = "Previous Year";
    	this.previousYearButton.label = '|<';
    	this.previousYearButton.addEventListener(MouseEvent.CLICK,onPreviousYear);
    	this.addChild(this.previousYearButton);
    	

    	// create button for nextYear 
    	this.nextYearButton = new Button();
    	this.nextYearButton.toolTip = "Next Year";
    	this.nextYearButton.label = '>|';
    	this.nextYearButton.addEventListener(MouseEvent.CLICK,onNextYear);
    	this.addChild(this.nextYearButton);
    	
//		this.invalidateProperties();
 //   	this.invalidateSize();
//    	this.invalidateDisplayList()
    }

    
    /** 
    * @private
    */
	override protected function measure():void{
		super.measure();
		
		// measured width should be sum of width of all children
		this.measuredWidth += this.previousYearButton.getExplicitOrMeasuredWidth() + this.nextYearButton.getExplicitOrMeasuredWidth();

		// measured height should be largest height of all children
		this.measuredHeight = Math.max(this.measuredHeight, this.previousYearButton.getExplicitOrMeasuredHeight(), 
										this.nextYearButton.getExplicitOrMeasuredHeight());
		
	}

    /** 
    * @private
    */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    	super.updateDisplayList(unscaledWidth, unscaledHeight);
    	
		this.previousYearButton.setActualSize(this.previousYearButton.getExplicitOrMeasuredWidth(),this.previousYearButton.getExplicitOrMeasuredHeight());
		
    	this.previousYearButton.x = 0;
    	this.previousYearButton.y = 0;
    	
		// add 1 for padding between buttons
    	this.previousButton.x = this.previousYearButton.width + 1;

		this.nextYearButton.setActualSize(this.nextYearButton.getExplicitOrMeasuredWidth(),this.nextYearButton.getExplicitOrMeasuredHeight());
    	this.nextYearButton.x = unscaledWidth - this.nextYearButton.width;
    	this.nextYearButton.y = 0;
    	
		// add 1 for padding between buttons
    	this.nextButton.x = unscaledWidth - this.nextYearButton.width - this.nextButton.width - 1;
    	
    	// find out the available space for the label
    	var spaceBetweenButtons : int = unscaledWidth -  (this.previousYearButton.width + this.previousButton.width + 
    												this.nextYearButton.width + this.nextButton.width + 2 );
    								
    	// place the month / year label between 				
   		this.label.y = 0; 
		this.label.setActualSize(this.label.measuredWidth,this.label.getExplicitOrMeasuredHeight());

    	if(spaceBetweenButtons <= this.label.width){
    		// if the space allotted is equal to space needed; place it in th space 
    		this.label.x = this.previousYearButton.width + this.previousButton.width + 1;
    		if(spaceBetweenButtons < this.label.width){
				// if space allotted is less; place it in space appropriately and shrink size of label 
	    		this.label.width = spaceBetweenButtons;
	    		
	    	}
	    } else {
	    	// if space allotted is larger, we want to center it in the space 
	    	
    		this.label.x = this.previousYearButton.width + this.previousButton.width + 1 + 
    								( (spaceBetweenButtons - this.label.width)/2) ;

    	}
    	
    }

    //--------------------------------------------------------------------------
    //
    //  variables
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  nextYearButton
    //----------------------------------
    /** 
    * This is a reference to the header’s next year button.
    */
    protected var nextYearButton : Button;


    //----------------------------------
    //  previousYearButton
    //----------------------------------
    /** 
    * This is a reference to the header’s previous year button.
    */
    protected var previousYearButton : Button;


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  monthHeaderData
    // this section of code inspired by Label's data property and then modified 
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property.
     */
    private var _monthHeaderData:ICalendarHeaderDataVO;
    private var monthHeaderDataChanged : Boolean = false;

    [Bindable("monthHeaderDataChange")]
    /**
     *  @inheritDoc
     */
    public function get monthHeaderData():ICalendarHeaderDataVO
    {
        return _monthHeaderData;
    }

    /**
     *  @private
     */
    public function set monthHeaderData(value:ICalendarHeaderDataVO):void
    {
		_monthHeaderData = value;
		monthHeaderDataChanged = true;

		this.invalidateProperties();
        dispatchEvent(new Event('monthHeaderDataChange'));
    }



    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	/**
	 * @inheritDoc  
	 *  
	 * @return A string made up of the monthName + the monthSymbol + a space + the displayYear.	 * 
	 */
	override protected function createLabelText():String{
		if(!this.monthHeaderData){
			return super.createLabelText();
		}
		return this.monthHeaderData.monthName + this.monthHeaderData.monthSymbol + ' ' + this.monthHeaderData.displayedYear;	
	}


    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
	/**
	 * This is the default handler for the previous year button's click event.  This will dispatch the PREVIOUS_YEAR event.
	 * 
	 * @see com.flextras.calendar.CalendarChangeEvent
	 * @see com.flextras.calendar.CalendarChangeEvent#PREVIOUS_YEAR
	 */
    protected function onPreviousYear(e:MouseEvent):void{
    	this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.PREVIOUS_YEAR,false,false));
    }
	/**
	 * @inheritDoc
	 * 
	 * @see com.flextras.calendar.CalendarChangeEvent
	 * @see com.flextras.calendar.CalendarChangeEvent#PREVIOUS_MONTH
	 */
    override protected function onPreviousClick(e:MouseEvent):void{
	    	this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.PREVIOUS_MONTH,false,false));
    }
	/**
	 * @inheritDoc
	 * 
	 * @see com.flextras.calendar.CalendarChangeEvent
	 * @see com.flextras.calendar.CalendarChangeEvent#NEXT_MONTH
	 */
    override protected function onNextClick(e:MouseEvent):void{
    	this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.NEXT_MONTH,false,false));
    }
	/**
	 * This is the default handler for the next year button's click event.  This will dispatch the NEXT_YEAR event.
	 * 
	 * @see com.flextras.calendar.CalendarChangeEvent
	 * @see com.flextras.calendar.CalendarChangeEvent#NEXT_YEAR
	 */
    protected function onNextYear(e:MouseEvent):void{
    	this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.NEXT_YEAR,false,false));
    }

	}
}