package org.techfusion.controller {
	
	// Import PureMVC Model Classes
	import flash.utils.getQualifiedClassName;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.techfusion.events.AsteriskEvent;
	import org.techfusion.model.proxies.AsteriskManagerInterfaceProxy;
	
	public class AsteriskCommand extends SimpleCommand implements ICommand {
		
		public function AsteriskCommand() {
		}
		
		override public function execute(notification:INotification):void {
			
			// Retrieve Asterisk Command
			var astCmdType:String = notification.getType() as String;
			
			// Retrieve Asterisk Command Body
			var astCmdBody:Object = null;
			if(
				notification.getBody() &&
				getQualifiedClassName(notification.getBody()) != "String" &&
				getQualifiedClassName(notification.getBody()) != "Dictionary" &&
				getQualifiedClassName(notification.getBody()) != "ArrayCollection" 
			) {
				astCmdBody = AsteriskEvent(notification.getBody()).getCommandData() as Object;
			} else {
				astCmdBody = notification.getBody();
			}
			
			// Retrieve Asterisk Proxy
			var asteriskManagerProxy:AsteriskManagerInterfaceProxy = 
				facade.retrieveProxy(AsteriskManagerInterfaceProxy.NAME) as AsteriskManagerInterfaceProxy;
			
			// Check What to Do
			switch(astCmdType) {
				case ApplicationFacade.DOCONF:
					// Hangup Channel
					asteriskManagerProxy.doInitialConfigRequest();
					break;
				case ApplicationFacade.PARK:
					// Hangup Channel
					asteriskManagerProxy.chanPark(String(astCmdBody.channel), String(astCmdBody.retchannel));
					break;
				case ApplicationFacade.HANGUP:
					// Hangup Channel
					asteriskManagerProxy.chanHangup(String(astCmdBody.channel));
					break;
				case ApplicationFacade.TRANSFER:
					// Hangup Channel
					asteriskManagerProxy.chanRedirect(String(astCmdBody.channel), String(astCmdBody.extension), String(astCmdBody.context));
					break;
				case ApplicationFacade.PING:
					asteriskManagerProxy.ping();
					break;
				case ApplicationFacade.GET_CTXS:
					asteriskManagerProxy.getContextes();
					break;
				case ApplicationFacade.GET_CTXIDXS:
					asteriskManagerProxy.getContextIndexes();
					break;
				case ApplicationFacade.GET_CONFIG:
					// Fire UP SIP Peers Query
					asteriskManagerProxy.getConfig();
					break;
				case ApplicationFacade.GET_QUEUES:
					// Retrieve Queues List
					asteriskManagerProxy.getQueues();
					break;
				case ApplicationFacade.GET_QUEUE_STATUS:
					// Retrieve Specific Queue Status
					asteriskManagerProxy.getQueueStatus(String(astCmdBody));
					break;
				case ApplicationFacade.GET_QUEUE_SUMMAR:
					// Retrieve Specific Queue Summary
					asteriskManagerProxy.getQueueSummary(String(astCmdBody));
					break;
				default:
					// Debug
					trace("AsteriskCommand ==> Not Handled: " + astCmdType);
					break;
			}
		}
	}
}