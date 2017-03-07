package org.techfusion.controller {
	
	// Import Model Classes
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.techfusion.model.proxies.AsteriskManagerInterfaceProxy;
	import org.puremvc.as3.patterns.command.SimpleCommand;	
	
	public class LogoutCommand extends SimpleCommand implements ICommand {
		public function LogoutCommand() {
		}
		
		override public function execute(notification:INotification):void {
			// Debug
			trace("LogoutCommand ==> Executing Logout Command");
			
			// Retrieve Proxy
			var mgrTopologyProxy:AsteriskManagerInterfaceProxy = facade.retrieveProxy(AsteriskManagerInterfaceProxy.NAME) as AsteriskManagerInterfaceProxy;
			
			// do Logout
			mgrTopologyProxy.manLogOff();
			
			// do Disconnect
			mgrTopologyProxy.doDisconnect();
		}
	}
}