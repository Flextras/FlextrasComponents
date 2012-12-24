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

package com.flextras.utils {

	import com.flexoop.utilities.dateutils.DateUtils;
	
	import mx.formatters.DateFormatter;

	/** 
	 * This is a Utility class that extends the DatUtils class.  
	 * 
	 * It was built for the Flextras Calendar.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flexoop.utilities.dateutils.DateUtils
	 */
	public class DateUtilsExtension extends DateUtils {
		

		// JH DotComIt 7/30/09 Added
		/**
		 * 
		 * This method determines the number of weeks in a given month is spread out over. 
		 * 
		 * @param date				A date from the month you want to find out how many days it spreads over.
		 * @param firstDayOfWeek	The first day of the week, 0 (Sunday) - 6 (Saturday); 0 is the default.  It will probably be used primarily for localization purposes.
		 * 
		 * @return			This method returns the number of weeks that a month has, either 4, 5, or 6 depending on how the days fall.
		 * 
		 */
		public static function weeksInMonth( date:Date, firstDayOfWeek : int = 0 ):Number {
			var result : int = 0;

			var daysInMonth : int = DateUtils.daysInMonth(date);
			// find the number of days in the first week 
			// number of days in a week [7] - dayoFweek [0-6 depending on the day ]
			var daysInFirstWeek : int = daysInFirstWeekOfMonth(date, firstDayOfWeek);

//			(daysInMonth - daysInFirstWeek)%DaysInWeek = number of days left over 
			var daysInLastWeek : int = ((daysInMonth - daysInFirstWeek)%7 );

			// find the number of full weeks in the month
//			Math.floor(daysInMonth - daysInFirstWeek)/DaysInWeek = number of full weeks in month
//			Add 1 for the leading days.  Even if the trailing days are a full week; it still adds 1
			result += Math.floor( ( (daysInMonth - daysInFirstWeek) /7) )+1;
			
			// if daysInLastWeek is 0 the the modulus gave no remainder which means last week was a full week and it was already counted do nothing, 
			// otherwise add 1
			if(daysInLastWeek != 0){
				result += 1;
			}
			
			return result;
		}
		
		/**
		 * This method calculates the number of the days that are in the first week of the given month.
		 * 
		 * @param date				A date from the month we want to find process.
		 * @param firstDayOfWeek	The first day of the week, 0 (Sunday) - 6 (Saturday); 0 is the default.  It will probably be used primarily for localization purposes.
		 * 
		 * @return This method returns the number of days in the first week of the month, taking into account the first day of the week.  
		 * 
		 */
		public static function daysInFirstWeekOfMonth(date : Date, firstDayOfWeek : int = 0):Number{
			var firstDateOfMonth : Date = new Date(date.fullYear,date.month, 1)
			var result : Number = 1;
			result = 7 - (DateUtils.dayOfWeek(firstDateOfMonth) - firstDayOfWeek);
			if(result >7 ){
				result = result - 7;
			}
			return result;
		}
		

		/**
		 * This function checks to see if the compareDate is between the startDate and endDate.  
		 * 
		 * This converts dates to strings using the toDateString method to check equality.
		 *  
		 * @param startDate This is the start date of the date range. 
		 * @param endDate This is the end date in the date range.
		 * @param compareDate This is the date you want to compare to the startDate and endDate.
		 * 
		 * @return This function returns 1 if the compareDate is between the startDate and endDate.  It returns 0 if the copareDate is not between the startDate and endDate.  
		 * It returns -1 if the compareDate is equal to the startDate or endDate. 
		 * 
		 */
		public static function dateBetween(startDate:Date, endDate:Date, compareDate : Date):int{
			var result : int = 0;
			if((compareDate.toDateString() == startDate.toDateString()) || (compareDate.toDateString() == endDate.toDateString())){
				result = -1;
			} else if ( (startDate < endDate) && (compareDate > startDate) && (compareDate < endDate)){
				result = 1;				
			} else if ( (startDate > endDate) && (compareDate > endDate) && (compareDate < startDate) ){
				result = 1
			}
			return result;
		}

		/**
		 * Gets the week that the month that the given date resides in, taking into account the first day of the week.  
		 * This is intended primarily for display purposes; and may not relate to any date calculation standards.
		 * 
		 * @param date	This is the date for which we want to know which week it resides in. 
		 * @param firstDayOfWeek	The first day of the week, 0 (Sunday) - 6 (Saturday); 0 is the default.  It will probably be used primarily for localization purposes.
		 * 
		 * @return		Returns a number representing the week of the week of the month in which this day falls on, 1 to 6.
		 */
		public static function weekOfMonth( date:Date, firstDayOfWeek : int = 0 ):Number {
			var result : int = 1;
			var firstDayInWeek : int = 1;
			var lastDayInWeek : int = DateUtilsExtension.daysInFirstWeekOfMonth(new Date(date.fullYear, date.month, 1), firstDayOfWeek );
			
			while(result <= 6){
				if((date.date >= firstDayInWeek) && (date.date <= lastDayInWeek)){
					break;
				}
				result += 1;
				firstDayInWeek = lastDayInWeek+1;
				lastDayInWeek = lastDayInWeek+7;
			}
			
			return result;
		}		

		/**
		 * This method gets the first date of the week which the given date is in.
		 * 
		 * @param date	This is the date for which we want to process.
		 * @param firstDayOfWeek	The first day of the week, 0 (Sunday) - 6 (Saturday); 0 is the default.  It will probably be used primarily for localization purposes.
		 * 
		 * @return		This returns a date representing the first day of the week.
		 */
		public static function firstDateOfWeek( date:Date, firstDayOfWeek : int = 0 ):Date {
			// if date.day == firstDayOf Week  return date 
			// do something like this: date.addDay(-date.day)
			var dayIncrement : int = dayOfWeekLocalized(date, firstDayOfWeek);
//			var dayIncrement : int = date.day - firstDayOfWeek;
//			if(dayIncrement < 0){
//				dayIncrement += 7;
//			}
			
			var returnDate : Date = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-dayIncrement,date);
			return returnDate; 
			
		}

		/**
		 * This method gets the first date of the week that is in the specified month.  
		 * In most cases this will be the results of the firstDateOfWeek method.  
		 * However, if we are in the first week of the month, then it may be somewhere in the middle of the week. 
		 * 
		 * @param date	This is the date for which we want to process.
		 * @param firstDayOfWeek	The first day of the week, 0 (Sunday) - 6 (Saturday); 0 is the default.  It will probably be used primarily for localization purposes.
		 * 
		 * @return		This returns a date object representing the first date of the week that also resides in the given month.
		 */
		public static function firstDateOfWeekInMonth( date:Date, firstDayOfWeek : int = 0 ):Date {
			var resultDate : Date =  DateUtilsExtension.firstDateOfWeek(date, firstDayOfWeek);
			if(resultDate.month != date.month){
				resultDate = new Date(date.fullYear, date.month, 1);
			}

			return resultDate;
		}

		/**
		 * @private
		 * not tested 
		 * Gets the last date of the month
		 * 
		 * @param date	The date to check
		 * 
		 * @return		A date object representing the last date o the month
		 */
		public static function lastDateOfMonth( date:Date ):Date {
			// get the first day of the next month
			var _localDate:Date = new Date( date.fullYear, DateUtils.dateAdd( DateUtils.MONTH, 1, date ).month, 1 );
			// subtract 1 day to get the last day of the requested month
			return DateUtils.dateAdd( DateUtils.DAY_OF_MONTH, -1, _localDate );
		}		
		
		
		/**
		 * This method returns the position of the day in a week, with respect to the firstDayOfWeek localization variable. 
		 * 
		 * If firstDayOfWeek is 0; then the week is display 0 (Sunday), 1 (Monday), 2 (Tuesday), 3 (Wednesday), 4 (Thursday), 5 (Friday), 6 (Saturday).  
		 * So, a Sunday would return 0, a Saturday would return 6, and so on.  
		 * 
		 * If firstDayOfWeek is 1; then the week is displayed as 0 (Monday), 1 (Tuesday), 2 (Wednesday), 3 (Thursday), 4 (Friday), 5 (Saturday), 6 (Sunday). 
		 * However, this situation will not change the date.day value.  For display purposes we need a Sunday to return 6, a Saturday to return 5, and so on.
		 * 
		 * This will presumably be used for display purposes.
		 * 
		 * @param date	This is the date to process.
		 * @param firstDayOfWeek	The first day of the week, 0 (Sunday) - 6 (Saturday); 0 is the default.  It will probably be used primarily for localization purposes.
		 * 
		 * @return		This returns a date representing the day’s location on the localized week display.
		 */
		public static function dayOfWeekLocalized( date:Date, firstDayOfWeek : int = 0 ):int {
			var result : int = date.day - firstDayOfWeek;
			if(result < 0){
				result += 7;
			}
			
			return result;
			
		}
		
		/**
		 * @private 
		 * Borrowed from http://userflex.wordpress.com/2008/09/11/as3-date-compare/
		 */
		public static function dateCompare (date1 : Date, date2 : Date) : Number
		{
			var date1Timestamp : Number = date1.getTime ();
			var date2Timestamp : Number = date2.getTime ();
			
			var result : Number = -1;
			
			if (date1Timestamp == date2Timestamp)
			{
				result = 0;
			}
			else if (date1Timestamp > date2Timestamp)
			{
				result = 1;
			}
			
			return result;
		} 
		
		
	}
}