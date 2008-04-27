package test.universalmind.cairngorm.events.generator
{	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.IResponder;

	import flexunit.framework.TestCase;
		
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.universalmind.cairngorm.events.Callbacks;
	import com.universalmind.cairngorm.events.generator.EventGenerator;
	import com.universalmind.cairngorm.events.UMEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.universalmind.common.utils.DelayedCall;

	
	public class EventGeneratorTest extends TestCase {
		
		override public function setUp()   : void {	__tracker = new EventResponder();  	}
		override public function tearDown(): void { 
			__tracker = null; 					
			}
		
		// ********************************************************
		// Tests 
		// *********************************************************  
		
		/**
		 * Testing the eventgenerator with 3 synchronous events dispatched in SEQUENCE
		 */
		public function testSynchInSequence():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Synchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Synchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Synchronously);
			
			__expected  = [ "test1", "test2", "test3" ]; // since dispatched synchronously
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone),
												new UMEvent("test2",eventDone),
												new UMEvent("test3",eventDone)
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_SEQUENCE );
											  
			start(__generator);
		} 
		
		/**
		 * Testing the eventgenerator with 3 synchronous events dispatched in SEQUENCE,
		 * but here we specify the generator finish handler during start()
		 */
		public function testSynchInSequence2():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Synchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Synchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Synchronously);
			
			__expected  = [ "test1", "test2", "test3" ]; // since dispatched synchronously
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone),
												new UMEvent("test2",eventDone),
												new UMEvent("test3",eventDone)
											  ],
											  null,
											  0, 
											  EventGenerator.TRIGGER_SEQUENCE );
											 
			// Specify a responder when starting the generator! 
			start(__generator, new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault));
		} 
		
		
		
		
		
		/**
		 * Testing the eventgenerator with 3 asynchronous events dispatched in SEQUENCE
		 */
		public function testAsynchInSequence():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1", "test2", "test3" ]; // since dispatched synchronously
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:700}),
												new UMEvent("test2",eventDone,false,false,{delay:500}),
												new UMEvent("test3",eventDone,false,false,{delay:300})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_SEQUENCE );
											  
			start(__generator);
		} 


		/**
		 * Testing the eventgenerator with 3 asynchronous events dispatched in Parallel
		 */
		public function testAsynchInParallel_A():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test3", "test2", "test1" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:700}),
												new UMEvent("test2",eventDone,false,false,{delay:500}),
												new UMEvent("test3",eventDone,false,false,{delay:300})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL );
											  
			start(__generator);
		} 


		public function testAsynchInParallel_B():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1", "test2", "test3" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300}),
												new UMEvent("test2",eventDone,false,false,{delay:500}),
												new UMEvent("test3",eventDone,false,false,{delay:700})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL );
											  
			start(__generator);
		} 
		
		public function testAsynchInParallel_C():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1", "test3", "test2" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300}),
												new UMEvent("test2",eventDone,false,false,{delay:700}),
												new UMEvent("test3",eventDone,false,false,{delay:500})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL );
											  
			start(__generator);
		} 


		public function testMixInParallel_A():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Synchronously);	
			__ced.addEventListener("test3",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test2", "test1", "test3" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300}),
												new UMEvent("test2",eventDone,false,false,{delay:700}),
												new UMEvent("test3",eventDone,false,false,{delay:500})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL );
											  
			start(__generator);
		} 

		public function testMixInParallel_B():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Synchronously);	// This forces next event to wait!
			
			__expected  = [ "test3", "test1", "test2" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300}),
												new UMEvent("test2",eventDone,false,false,{delay:700}),
												new UMEvent("test3",eventDone,false,false,{delay:500})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL );
											  
			start(__generator);
		} 


		public function testMixInSequence_A():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Synchronously);	// This forces next event to wait!
			__ced.addEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1", "test2", "test3" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300}),
												new UMEvent("test2",eventDone,false,false,{delay:700}),
												new UMEvent("test3",eventDone,false,false,{delay:500})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_SEQUENCE );
											  
			start(__generator);
		} 


		public function testMixInSequence_B():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Synchronously);	// This forces next event to wait!
			__ced.addEventListener("test3",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1", "test2", "test3" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300}),
												new UMEvent("test2",eventDone,false,false,{delay:700}),
												new UMEvent("test3",eventDone,false,false,{delay:500})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_SEQUENCE );
											  
			start(__generator);
		} 


		public function testSingleSequence_A():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_SEQUENCE );
											  
			start(__generator);
		} 


		public function testSingleSequence_B():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Synchronously);
			
			__expected  = [ "test1" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_SEQUENCE );
											  
			start(__generator);
		} 


		public function testSingleParallel_A():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL  );
											  
			start(__generator);
		} 


		public function testSingleParallel_B():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Synchronously);
			
			__expected  = [ "test1" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300})
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,FAIL_AFTER,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL );
											  
			start(__generator);
		} 
		
		
		public function testNoUMEvent_A():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1", "test2" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300}),
												new NoUMEvent("test2",eventDone,{delay:450}),				// test non-UMEvent CairngormEvent subclass with responder
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,1000,null,onFault),onFault),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL );
											  
			start(__generator);
		} 
		
		/**
		 * Events must be 
		 */
		public function testBadEvent_A():void {
			
			var eventDone : IResponder = new Callbacks(__tracker.announceEventDone, onFault);
						
			__ced.addEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			__ced.addEventListener("test3",__tracker.simulateProcessor_Asynchronously);
			
			__expected  = [ "test1", "test2", "test3" ];
			__generator = new EventGenerator( [
												new UMEvent("test1",eventDone,false,false,{delay:300}),
												new NoUMEvent("test2",eventDone,{delay:450}),				// test non-UMEvent CairngormEvent subclass with responder
												new CairngormEvent("test3")	
											  ],
											  // Add Asynch wrapper for FlexUnit testing...
											  new Callbacks(addAsync(onResults_compareExpected,1000,null,onFault)),
											  0, 
											  EventGenerator.TRIGGER_PARALLEL );
											  
			start(__generator);
		} 
		
		 
		
		// ********************************************************
		// Asynchronous DataService Handlers
		// *********************************************************  

		protected function onFault(event:*):void {
			clearCED();
			fail(event ? String(event) : "Unknown event");
		}
		
		/**
		* Check results of run event batches
		*/
		protected function onResults_compareExpected( event:* ):void {
			clearCED();
						
			assertEquals(__expected.length, __tracker.eventResponses.length );
			assertEquals( __expected[0],	__tracker.eventResponses[0] ); 
			assertEquals( __expected[1],    __tracker.eventResponses[1] ); 
			assertEquals( __expected[2],	__tracker.eventResponses[2] ); 
		}	

		// ********************************************************
		// Private Util Methods
		// *********************************************************  
		/** 
		 * Notify the generator to start dispatching events. This method
		 * Allow asynchronous nature of FlexUnit to configure before dispatching
		 * 
		 * @param generator  Instance of EventGenerator that should be started in 300 ms.
		 */ 
		private function start(generator:EventGenerator, responder:IResponder = null):void {
			
			__tracker.reset();
			 			
			DelayedCall.schedule(    function(generator:EventGenerator):void {
										generator.dispatch(responder);
									 },
									 [__generator],300
								 );
		}
		
		private function clearCED():void {
			__ced.removeEventListener("test1",__tracker.simulateProcessor_Synchronously);
			__ced.removeEventListener("test2",__tracker.simulateProcessor_Synchronously);
			__ced.removeEventListener("test3",__tracker.simulateProcessor_Synchronously);

			__ced.removeEventListener("test1",__tracker.simulateProcessor_Asynchronously);
			__ced.removeEventListener("test2",__tracker.simulateProcessor_Asynchronously);
			__ced.removeEventListener("test3",__tracker.simulateProcessor_Asynchronously);			
		}
		
		private static const FAIL_AFTER : int = 1000000;
		
		private var __ced       : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
		private var __generator : EventGenerator = null;
		private var __tracker   : EventResponder = null;
		
		private var __expected  : Array          = [];
	}
}


import mx.rpc.IResponder;
import flash.events.Event;
import com.universalmind.common.utils.DelayedCall;
import com.universalmind.cairngorm.events.UMEvent;
import com.adobe.cairngorm.control.CairngormEvent;
import com.universalmind.cairngorm.events.generator.EventUtils;
class EventResponder {

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

class NoUMEvent extends CairngormEvent {
	
	public var responder : IResponder = null;
	
	public function NoUMEvent(type:String, responder:IResponder = null, data:Object = null) {
		super(type,false,false);
		
		this.responder = responder;
		this.data      = data;
	}
}