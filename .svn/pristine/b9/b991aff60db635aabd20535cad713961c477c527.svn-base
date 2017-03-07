package org.techfusion.controller {
	
	// Import Model Classes
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class OnMessageCommand extends SimpleCommand implements ICommand {
		
		//*****************************//
		// AMI Response Message DEFINE
		//*****************************//
		
		//** Authentication Related
		private static const AUTHOK:String			= "Authentication accepted";
		private static const UNAUTHOK:String		= "Thanks for all the fish";
		
		//** Peers Related
		private static const PEERSTATUS:String		= "PeerStatus";
		private static const PEERENTRY:String		= "PeerEntry";
		
		//** Queues Related
		private static const QUEUE_JOIN:String		= "Join";
		private static const QUEUE_LEAVE:String		= "Leave";
		private static const QUEUE_PAR:String		= "QueueParams";
		private static const QUEUE_MEM:String		= "QueueMember";
		private static const QUEUE_SUM:String		= "QueueSummary";
		private static const QUEUE_MEMSTATUS:String	= "QueueMemberStatus";
		
		//** Dialplan Debugger Related
		private static const VAR_SET:String			= "VarSet";
		private static const NEW_EXTEN:String		= "Newexten";
		private static const DIAL_ENTRY:String		= "ListDialplan";
		
		//** Channel Related
		private static const DIALSTATUS:String		= "Dial";
		private static const STATUS:String			= "Status";
		private static const HANGSTATUS:String		= "Hangup";
		private static const NEWSTATE:String		= "Newstate";
		private static const NEWCHAN:String			= "Newchannel";
		private static const LOCALBRIDGE:String		= "LocalBridge";
		private static const EXTSTATUS:String		= "ExtensionStatus";
		private static const RTCPTX:String			= "RTCPSent";
		private static const RTCPRX:String			= "RTCPReceived";
		
		//** TCP Connection Related
		private static const PONG:String			= "Pong";
		
		public function OnMessageCommand() {
		}
		
		override public function execute(notification:INotification):void {
			
			// Get XML Event
			var astEvent:XML = notification.getBody() as XML;
			
			// Handle Ping Events
			if(astEvent.child("Ping").length() > 0) {
				sendNotification(ApplicationFacade.PONG, String(astEvent.Timestamp));
				return;
			}
			
			// Check Event Type
			if(astEvent.child("Event").length() > 0) {
				switch(astEvent.child("Event").toString()) {
					case PEERSTATUS:
						sendNotification(ApplicationFacade.PEER_STATUS, astEvent);
						break;
					case PEERENTRY:
						sendNotification(ApplicationFacade.PEER_ENTRY, astEvent);
						break;
					case QUEUE_JOIN:
						sendNotification(ApplicationFacade.QUEUE_JOIN, astEvent);
						break;
					case QUEUE_LEAVE:
						sendNotification(ApplicationFacade.QUEUE_LEAVE, astEvent);
						break;
					case QUEUE_PAR:
						sendNotification(ApplicationFacade.QUEUE_PAR, astEvent);
						break;
					case QUEUE_MEM:
						sendNotification(ApplicationFacade.QUEUE_MEM, astEvent);
						break;
					case QUEUE_MEMSTATUS:
						sendNotification(ApplicationFacade.QUEUE_MEMSTATUS, astEvent);
						break;
					case QUEUE_SUM:
						sendNotification(ApplicationFacade.QUEUE_SUM, astEvent);
						break;
					case VAR_SET:
						sendNotification(ApplicationFacade.VAR_SET, astEvent);
						break;
					case NEW_EXTEN:
						sendNotification(ApplicationFacade.NEW_EXTEN, astEvent);
						break;
					case EXTSTATUS:
						sendNotification(ApplicationFacade.EXT_STATUS, astEvent);
						break;
					case NEWSTATE:
						sendNotification(ApplicationFacade.NEW_STATE, astEvent);
						break;
					case NEWCHAN:
						sendNotification(ApplicationFacade.NEW_CHAN, astEvent);
						break;
					case LOCALBRIDGE:
						sendNotification(ApplicationFacade.LOCAL_BRIDGE, astEvent);
						break;
					case STATUS:
						sendNotification(ApplicationFacade.NEW_EXTEN, astEvent);
						break;
					case DIALSTATUS:
						sendNotification(ApplicationFacade.DIAL, astEvent);
						break;
					case DIAL_ENTRY:
						sendNotification(ApplicationFacade.DIAL_ENTRY, astEvent);
						break;
					case HANGSTATUS:
						sendNotification(ApplicationFacade.HANG, astEvent);
						break;
					case RTCPTX:
						sendNotification(ApplicationFacade.RTCP_TX, astEvent);
						break;
					case RTCPRX:
						sendNotification(ApplicationFacade.RTCP_RX, astEvent);
						break;
					default:
						// Debug Unhandled Asterisk Messages
						// trace("OnMessageCommand ==> Unhandled command: " + astEvent.child("Event").toString() + "\n");
						break;
				}
			} else {
				switch(astEvent.child("Message").toString()) {
					case AUTHOK:
						sendNotification(ApplicationFacade.VALID_LOGIN, astEvent);
						break;
					case UNAUTHOK:
						sendNotification(ApplicationFacade.DISCONNECT, astEvent);
						break;
					default:
						break;
				}
			}
		}
	}
}