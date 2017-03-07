package org.techfusion.controller {

	// Import PureMVC Classes
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.techfusion.events.LoginViewEvent;
	import org.techfusion.model.proxies.AsteriskManagerInterfaceProxy;
	
	public class DisconnectCommand extends SimpleCommand implements ICommand {
		public function DisconnectCommand() {
		}
		
		override public function execute(notification:INotification):void {
			// Debug
			trace("DisconnectCommand ==> Executing Disconnect Command");
			
			// Retrieve LoginViewEvent Object
			var loginViewEvent:LoginViewEvent = notification.getBody() as LoginViewEvent;
			
			// Retrieve Proxy
			var mgrTopologyProxy:AsteriskManagerInterfaceProxy = facade.retrieveProxy(AsteriskManagerInterfaceProxy.NAME) as AsteriskManagerInterfaceProxy;
			
			// do Logout
			mgrTopologyProxy.manLogOff();
			
			// do Disconnect
			mgrTopologyProxy.doDisconnect();
		}
	}
}