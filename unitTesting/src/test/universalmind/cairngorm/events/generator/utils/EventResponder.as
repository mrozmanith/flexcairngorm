package test.universalmind.cairngorm.events.generator.utils
{
	import mx.rpc.IResponder;
	import flash.events.Event;
	import com.universalmind.common.utils.DelayedCall;
	import com.universalmind.cairngorm.events.UMEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.generator.EventUtils;
	
	public class EventResponder {
	
		public var delay          : int   = 1800;	
		public var eventResponses : Array = [];
		
		public function reset():void {
			delay          = 1800;
			eventResponses = [];
		}
		// *************************************************
		// Public Event Handlers
		// *************************************************
		
		public function simulateProcessor_Asynchronously(event:Event):void {
			var handlers : IResponder = EventUtils.getResponderFor(event);
			if (event is UMEvent) {
				var data : Object = (event as UMEvent).data;
				delay = (data != null) ? data.delay : 300;
			}
	
			DelayedCall.schedule(function (responder:IResponder,eventID:String):void {
									
									notifyResponder(responder,eventID);
									
								 },[handlers,event.type],delay);				
		}
				
		public function simulateProcessor_Synchronously(event:Event):void {
		    var responder : IResponder = EventUtils.getResponderFor(event);
		    if (responder != null) responder.result(event.type);
		}
	
	
		/**
		 * When the event is done, let's do something to track completion...
		 * needed for testing
		 */
		public function announceEventDone(info:*):void {
			eventResponses.push(String(info));
		}
	
		// *************************************************
		// Private utility methods
		// *************************************************
		
		private function notifyResponder(responder:IResponder,eventID:String):void {
			if (responder != null) responder.result(eventID);
			else throw new Error("Responder not available for Event: " +eventID);
		}
	}
}