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
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	/**
	 *  This defines a base header for each state of the Calendar component.  It sets up a next button, forward button, and a 
	 * label.
	 *  
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.defaultRenderers.DayHeaderRenderer 
	 * @see com.flextras.calendar.defaultRenderers.MonthHeaderRenderer 
	 * @see com.flextras.calendar.defaultRenderers.WeekHeaderRenderer 
	 * 
	 */
	public class CalendarHeaderBase extends UIComponent 
	{ 

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
		/**
		 *  Constructor.
		 */
	public function CalendarHeaderBase(){
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
	}

    /** 
    * @private
    */
    override protected function createChildren():void{
    	super.createChildren();
    	
    	// create Button for previous 'whatever'
    	this.previousButton = new Button();
    	this.previousButton.toolTip = "Previous";
    	this.previousButton.label = '<';
    	this.previousButton.addEventListener(MouseEvent.CLICK,onPreviousClick);
    	this.addChild(this.previousButton);

    	// create label for Month and Year display
		this.label = new Label();
		this.label.text = createLabelText();
		this.addChild(this.label);

    	// create button for nextMonth
    	this.nextButton = new Button();
    	this.nextButton.toolTip = "Next";
    	this.nextButton.label = '>';
    	this.nextButton.addEventListener(MouseEvent.CLICK,onNextClick);
    	this.addChild(this.nextButton);
		
    	
    }	

    /** 
    * @private
    */
	override protected function measure():void{
		super.measure();

		// measured width should be sum of width of all children
		this.measuredWidth = this.previousButton.getExplicitOrMeasuredWidth() + 
							this.label.getExplicitOrMeasuredWidth() + 
							this.nextButton.getExplicitOrMeasuredWidth();

		// measured height should be largest height of all children
		this.measuredHeight = Math.max(this.previousButton.getExplicitOrMeasuredHeight(), 
							this.label.getExplicitOrMeasuredHeight(),
							this.nextButton.getExplicitOrMeasuredHeight());


		this.measuredMinWidth = 200;
		this.measuredMinHeight = 22;

	}

	/** 
	 * @private
	 */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    	super.updateDisplayList(unscaledWidth, unscaledHeight);

		// add 1 for padding between buttons
		this.previousButton.setActualSize(this.previousButton.getExplicitOrMeasuredWidth(),this.previousButton.getExplicitOrMeasuredHeight());
    	this.previousButton.x = 0;
    	this.previousButton.y = 0;

		// add 1 for padding between buttons
		this.nextButton.setActualSize(this.nextButton.getExplicitOrMeasuredWidth(),this.nextButton.getExplicitOrMeasuredHeight());
    	this.nextButton.x = unscaledWidth - this.nextButton.width - 1;
    	this.nextButton.y = 0;

    	// find out the available space for the label
    	var spaceBetweenButtons : int = unscaledWidth -  (this.previousButton.width + this.nextButton.width + 2 );

		this.label.setActualSize(this.label.measuredWidth,this.label.getExplicitOrMeasuredHeight());

    	if(spaceBetweenButtons <= this.label.width){
    		// if the space allotted is equal to space needed; place it in th space 
    		this.label.x = this.previousButton.width + 1;
    		if(spaceBetweenButtons < this.label.width){
				// if space allotted is less; place it in space appropriately and shrink size of label 
	    		this.label.width = spaceBetweenButtons;
	    		
	    	}
	    } else {
	    	// if space allotted is larger, we want to center it in the space 
    		this.label.x = this.previousButton.width + 1 + ( (spaceBetweenButtons - this.label.width)/2) ;

    	}


    }

    //--------------------------------------------------------------------------
    //
    //  variables
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  label
    // The header text
    //----------------------------------
    /** 
    * This is a reference to the label used to display the header’s text.  
    */
    protected var label : Label;

    //----------------------------------
    //  nextButton
    //----------------------------------
    /** 
    * This is a reference to the header’s next button.
    */
    protected var nextButton : Button;

    //----------------------------------
    //  previousButton
    //----------------------------------
    /** 
    * This is a reference to the header’s previous button.
    */
    protected var previousButton : Button;


    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	/**
	 * This is a helper function for creating the text that will be displayed in the component's Label.  You can override this method to set the display text on the header.
	 */
    protected function createLabelText():String{
		return '';	
	}
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
	/**
	 * This is the default handler for the previous button's click event.  By default, this does nothing.  You can override this in the child to dispatch a relevant event.  
	 *
	 * @see com.flextras.calendar.CalendarEvent 
	 */
	protected function onPreviousClick(e:MouseEvent):void{

	}
	
	/**
	 * This is the default handler for the next button's click event.  By default, this does nothing.  You can override this in the child to dispatch a relevant event.  
	 * 
	 * @see com.flextras.calendar.CalendarEvent 
	 */
	protected function onNextClick(e:MouseEvent):void{
	 	
	}


	}

}