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
package com.flextras.calendar.utils
{
	import com.flextras.utils.DateUtilsExtension;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import com.flexoop.utilities.dateutils.DateUtils;

	// copied the table code from ListEvent.change and modified it 
	/**
	 * This event will dispatch if something has changed inside this component that invalidates the parsed dataProvider.  
	 * The most common cause of this would be if the dateField, dateFunction, or dataProvider have changed.
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
	 */
	[Event(name="change", type="flash.events.Event")]

	/**
	 * This is a class for managing the Calendar's dataProvider and figuring out which data should be displayed on which day.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * 
	 */	
	 public class DataProviderManager extends EventDispatcher
	{ 
	
		 /**
		  *  Constructor.
		  */		 
		public function DataProviderManager()
		{
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Methods
	    //
	    //--------------------------------------------------------------------------

	    //----------------------------------
	    //  clearData
	    //----------------------------------
	    /**
	     * This method wipes out the old dataProviderDictionary and creates a new one.
	     */
	    public function clearData():void{
	    	this._dataProviderDictionary = new Dictionary();
	    }

	    //----------------------------------
	    //  createDataProviderDictionaryKey
	    //----------------------------------
		/**
		 * This is an internal function that will create the key used in the dataDictionary.  
		 * The format for the key is:  displayYear + "|" + displayMonth + "|" + displayDay.  
		 * The month and day are forced into two digits values, so instead of 1, 01 will be used.  
		 * 
	  	 * @param day This is the day that the key will be created for. 
	  	 * @param month This is the month that we are creating the key for.  If not specified this defaults to the displayMonth. 
	  	 * @param year This is the year that we are creating the key for. If not specified this defaults to the displayYear.
	  	 * 
		 * @return The This returns the key that will be used to store data in the data dictionary.
		 * 
		 */
		protected function createDataProviderDictionaryKey(day:int, month : int = -1, year : int = -1):String{
		    if(month == -1){
		    	month = new Date().getMonth();
		    }
		    if(year == -1){
		    	year = new Date().getFullYear();
		    }
	
		    var results : String = '';
		    results += year.toString() + '|';
	
			// if month is a single digit month, add a zero in
			if(month <= 9){
				results += '0';	
			}
		    results += month.toString() + '|';
	
			// if day is a single digit day, add a zero in to force it to take 2 characters
			if(day <= 9){
				results += '0';	
			}
		    results += day.toString();
		    
		    return results;
	
		    
		}    
	    
	    //----------------------------------
	    //  getData
	    //----------------------------------
	    /**
	     * This method returns the data that should be displayed on a specific date.  
		 * 
	     * @param date The date argument specifies the date we want the data for.
		 * @param recreateifMissing If set to true, will reparse the dataProvider looking for data on that date if no data exists.  If set to false this will return an empty ArrayCollection.  The default is true.
 	     * @param recreateIfEmpty If set to true, will parse the dataProvider looking for data on that date if no data exists.  If this is set to false it will not reparse the dataProvider looking for data.  The default is false.
	     * @return recreateifMissing
	     * 
	     */
	    public function getData(date:Date, recreateifMissing : Boolean = true, recreateIfEmpty : Boolean = false):ArrayCollection{

			var results : ArrayCollection ;

			var key : String = createDataProviderDictionaryKey(date.date, date.month, date.fullYear);

			if (!this.dataProviderDictionary.hasOwnProperty(key)){
				if(recreateifMissing == true){
					this.parseDateRange(date, date);
					return getData(date, false, false);
				}
			} else {
				results = this.dataProviderDictionary[key];
				if((results.length == 0) && (recreateIfEmpty == true)){
					this.parseDateRange(date, date);
					return getData(date, false, false);
				}
			}
	    	
	    	return results;
	    }

	   /**
	     *  This method returns the date of the item used to decide which date an item in the dataProvider represents.  
		 * It is calculated based on the dateField and dateFunction properties, and is conceptually similar to itemToLabel in 
		 * the ListBase class.
		 * If the method cannot convert the parameter to a Date object, it returns today's date.
	     *
	     *  @param data This is the object to be parsed.
	     *
	     *  @return This returns the date which determines where the item will be displayed. 
	     */
	    public function itemToDate(data:Object):Date
	    {
	        if (data == null)
	            return new Date();
	
	        if (this.dateFunction != null)
	            return this.dateFunction(data);
	
	        if (data is XML)
	        {
	            try
	            {
	                if (data[this.dateField].length() != 0)
	                    data = data[this.dateField];
	                //by popular demand, this is a default XML labelField
	                //else if (data.@label.length() != 0)
	                //  data = data.@label;
	            }
	            catch(e:Error)
	            {
	            }
	        }
	        else if (data is Object)
	        {
	            try
	            {
	                if (data[this.dateField] != null)
	                    data = data[this.dateField];
	            }
	            catch(e:Error)
	            {
	            }
	        }
	
	        if (data is Date)
	            return data as Date;
	
	        try
	        {
	            return data as Date;
	        }
	        catch(e:Error)
	        {
	        }
	
	        return new Date();
	    }


	    //----------------------------------
	    //  parseDateRange
	    //----------------------------------
	    /**
	     * This method parses the dataProvider into smaller pieces that represent a single day for each date in the date range. 
	     * 
	     * @param startDate This is the date where we start parsing.
	     * @param endDate This is the date where we stop parsing.
	     * @param recreate If this is set to true will recreate data for days that already have data; if set to false will not recreate the data.  The default is false.
	     * 
	     */
	    public function parseDateRange(startDate:Date, endDate:Date, recreate : Boolean = false):void{
	    	// verify that this works; and be sure that start day and end day are included
	    	// For example: 
	    	//    if 11/1/2009 to 11/30/2009 should return 30 not 28 or 29. 
	    	//    if 11/1/2009 to 11/1/2009 should return 1, not 0
	    	var daysToProcess : int = DateUtils.dateDiff(DateUtils.DAY_OF_MONTH,startDate, endDate)+1;

			var key : String;

			for (var dayIncrement : int=0; dayIncrement < daysToProcess; dayIncrement++){
				var dateToProcess : Date = new Date(startDate.fullYear,startDate.month, startDate.date + dayIncrement) ;
				key = createDataProviderDictionaryKey(dateToProcess.date, dateToProcess.month, dateToProcess.fullYear);
				if(this.dataProviderDictionary.hasOwnProperty(key) && (recreate == true)){
					this.dataProviderDictionary[key] = new ArrayCollection([]);
				} else if (!this.dataProviderDictionary.hasOwnProperty(key)) {
					this.dataProviderDictionary[key] = new ArrayCollection([]);
				} // else key already exists do not change it 
				
			}

			// populate each Collection by looping over the dataProvider 
			for each (var item : Object in this.dataProvider){

				var tempDate : Date = this.itemToDate(item);
				// if the date of the current item is between the start and end date; add it to it's appropriate place
//	Differing times appear to screw up this condition ; but we don't care about times so go ahead and modify it to just compare year, month, and date
				//				if((tempDate >= startDate) && (tempDate <= endDate)){
				if( ( tempDate &&
					
					( (tempDate.fullYear >= startDate.fullYear) && 
					(tempDate.month >= startDate.month) && 
					(tempDate.date >= startDate.date) )
					&&
					( (tempDate.fullYear <= endDate.fullYear) && 
						(tempDate.month <= endDate.month) && 
						(tempDate.date <= endDate.date) ) )
					
					){
					key =createDataProviderDictionaryKey(tempDate.date, tempDate.month, tempDate.fullYear);   
					// be sure not to add duplicates into the dataProvider 
					if(!ArrayCollection(this.dataProviderDictionary[key]).contains(item)){
						ArrayCollection(this.dataProviderDictionary[key]).addItem(item);
					}
				}
			}


	    } 
		
		/**
		 * @private
		 * this function is executed whenever the dataProvider, dateField, or dateFuntion change
		 * It clears out the existing data
		 */
		protected function change():void{
			this.clearData();
			this.dispatchEvent(new Event('change'));
		}
		
		/**
		 * This method will force all data to be refreshed.  
		 */
		public function invalidateDataProvider():void{
			this.change();
		}


	    //--------------------------------------------------------------------------
	    //
	    //  Properties
	    //
	    //--------------------------------------------------------------------------
			

	    //----------------------------------
	    //  dataProvider
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dataProvider : Object = null;
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
			this.change();
		}

	    //----------------------------------
	    //  dataProviderDictionary
	    //----------------------------------
	
	    /**
	     *  @private
	     */
		private var _dataProviderDictionary : Dictionary = new Dictionary();
		
	    /**
	     *  This property is storage for the day specific dataProviders created out of the dataProvider property based on the displayMonth and 
	     * displayYear.
	     */
	    public function get dataProviderDictionary():Dictionary
	    { 
	        return _dataProviderDictionary;
	    }

	    //----------------------------------
	    //  dateField
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dateField : String = 'date';
		/**
	     * @copy com.flextras.calendar.Calendar#dateField
		 */
		public function get dateField():String{
			return this._dateField;
		}
		/**
		 * @private
		 */
		public function set dateField(value:String):void{
			this._dateField = value;
			this.change();
		}
		
	    //----------------------------------
	    //  dateFunction
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dateFunction : Function;
		/**
	     * @copy com.flextras.calendar.Calendar#dateFunction  
		 */
		public function get dateFunction():Function{
			return this._dateFunction;
		}
		/**
		 * @private
		 */
		public function set dateFunction(value:Function):void{
			this._dateFunction = value;
			this.change();
		}

	}
}