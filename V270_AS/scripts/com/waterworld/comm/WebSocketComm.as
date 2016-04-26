package com.waterworld.comm
{
   import com.kixeye.logging.KXLogger;
   import com.kixeye.logging.class_72;
   import com.worlize.websocket.WebSocket;
   import flash.utils.Dictionary;
   import flash.system.Security;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import com.worlize.websocket.WebSocketErrorEvent;
   import com.worlize.websocket.WebSocketEvent;
   import com.kixeye.utils.json.ActionJSON;
   import package_108.BattlePiratesJSONRemoteProcedureCall;
   import package_108.class_198;
   import mx.utils.StringUtil;
   
   public class WebSocketComm extends Object
   {
      
      public static const const_3194:int = -1;
      
      public static const const_2989:int = 0;
      
      public static const const_563:int = 1;
      
      public static const const_1470:int = 2;
      
      public static const const_539:String = "normal";
      
      public static const const_4422:String = "test-response";
      
      public static const const_3672:String = "idle";
      
      public static const const_256:Array = ["normal","test-response","idle"];
      
      public static const const_822:String = "close-request";
      
      public static const MESSAGE_TYPE_GET_MAP_OBJECTS_3_REQUEST:String = "world.gmo3-request";
      
      public static const MESSAGE_TYPE_GET_MAP_OBJECTS_3_RESPONSE:String = "world.gmo3-response";
      
      private static const const_3820:int = 0;
      
      private static const const_2783:String = "ws://";
      
      private static const const_4482:String = ":";
      
      private static const const_1717:String = "/";
      
      private static const const_1890:String = "xmlsocket://";
      
      private static const const_1873:String = "843";
      
      private static const const_2749:String = "bp-protocol";
      
      private static const const_4218:String = "443";
      
      private static var _log:KXLogger = class_72.getLoggerForClass(WebSocketComm);
      
      {
         _log = class_72.getLoggerForClass(WebSocketComm);
      }
      
      private var var_2066:String;
      
      private var var_1437:Array;
      
      private var var_1426:int;
      
      private var var_4718:Boolean;
      
      private var var_117:String;
      
      private var var_3060:int;
      
      private var var_5222:int;
      
      private var var_4353:String;
      
      private var var_4330:String;
      
      private var var_5882:String;
      
      private var var_447:int;
      
      private var var_706:WebSocket;
      
      private var var_3262:Dictionary;
      
      private var var_3413:Dictionary;
      
      private const const_1233:int = 0;
      
      private const const_2770:int = 10;
      
      private var var_2972:int = 0;
      
      public function WebSocketComm(param1:Object, param2:String, param3:String)
      {
         var _loc8_:* = 0;
         super();
         var_447 = 0;
         var_1426 = 0;
         var_2066 = param1.host;
         var _loc4_:String = param1.ports?param1.ports:"";
         var_1437 = _loc4_.split(",");
         var _loc6_:int = var_1437.length;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            var_1437[_loc8_] = StringUtil.trim(var_1437[_loc8_]);
            _loc8_++;
         }
         var_4718 = param1.online;
         var_117 = const_256.indexOf(param1.mode) >= 0?param1.mode:"idle";
         var _loc7_:String = param1.sectors;
         var _loc5_:Array = _loc7_.split("-");
         var_3060 = _loc5_.length == 1 || _loc5_.length == 2?_loc5_[0]:0;
         var_5222 = _loc5_.length == 2?_loc5_[1]:var_3060;
         var_4330 = param2;
         var_5882 = param3;
         if(!var_4718 || var_3060 == 0)
         {
            var_447 = -1;
         }
         var_706 = null;
         var_3262 = new Dictionary();
         var_3413 = new Dictionary();
      }
      
      private function getNextPort() : String
      {
         var _loc1_:* = null;
         if(var_1437 && var_1437.length != 0)
         {
            _loc1_ = var_1437[var_1426];
            if(_loc1_ != null && _loc1_.length != 0)
            {
               var_1426 = §§dup().var_1426 + 1;
               if(var_1426 >= var_1437.length)
               {
                  var_1426 = 0;
               }
               return _loc1_;
            }
         }
         return "443";
      }
      
      private function getFullUrl() : String
      {
         var_4353 = "ws://" + var_2066 + ":" + getNextPort() + "/";
         return var_4353;
      }
      
      public function get mode() : String
      {
         return var_117;
      }
      
      public function get status() : int
      {
         return var_447;
      }
      
      public function isEnabledForSector(param1:int) : Boolean
      {
         return var_3060 <= param1 && param1 <= var_5222;
      }
      
      public function loadPolicyFileDefault() : void
      {
         var _loc1_:String = "xmlsocket://" + var_2066 + ":" + "843";
         Security.loadPolicyFile(_loc1_);
      }
      
      public function connect() : void
      {
         if(var_447 != 0)
         {
            return;
         }
         var_447 = 1;
         var _loc1_:String = "origin";
         var_706 = new WebSocket(getFullUrl(),_loc1_,"bp-protocol");
         var_706.addEventListener("ioError",onSocketIoError,false,0,true);
         var_706.addEventListener("securityError",onSecurityError,false,0,true);
         var_706.addEventListener("connectionFail",onConnectionFail,false,0,true);
         var_706.addEventListener("abnormalClose",onAbnormalClose,false,0,true);
         var_706.addEventListener("open",onWebSocketOpen,false,0,true);
         var_706.addEventListener("closed",onWebSocketClosed,false,0,true);
         var_706.addEventListener("message",onWebSocketMessage,false,0,true);
         var_706.connect();
      }
      
      public function getMapObjects(param1:Object, param2:Function, param3:Function) : void
      {
         var_3262["world.gmo3-response"] = param2;
         var_3413["world.gmo3-response"] = param3;
         var _loc5_:Object = {};
         _loc5_.action = "world.gmo3-request";
         _loc5_.params = param1;
         var _loc4_:String = JSON.stringify(_loc5_);
         var_706.sendUTF(_loc4_);
      }
      
      private function onSocketIoError(param1:IOErrorEvent) : void
      {
         _log.logRemote("ERROR.WebSocketComm.onSocketIoError","event.text: " + param1.text);
         manageWebSocketLoggingState();
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         _log.logRemote("ERROR.WebSocketComm.onSecurityError","event.text: " + param1.text);
         manageWebSocketLoggingState();
      }
      
      private function onConnectionFail(param1:WebSocketErrorEvent) : void
      {
         _log.logRemote("ERROR.WebSocketComm.onConnectionFail","event.text: " + param1.text);
         var_447 = 0;
         manageWebSocketLoggingState();
      }
      
      private function onAbnormalClose(param1:WebSocketErrorEvent) : void
      {
         _log.logRemote("ERROR.WebSocketComm.onAbnormalClose","event.text: " + param1.text);
         var_447 = 0;
         manageWebSocketLoggingState();
      }
      
      private function onWebSocketOpen(param1:WebSocketEvent) : void
      {
         var_447 = 2;
      }
      
      private function onWebSocketClosed(param1:WebSocketEvent) : void
      {
         _log.logRemote("ERROR.WebSocketComm.onWebSocketClosed","event.toString(): " + param1.toString());
         var_447 = 0;
         manageWebSocketLoggingState();
      }
      
      private function onWebSocketMessage(param1:WebSocketEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(param1.message.type === "utf8")
         {
            _loc2_ = ActionJSON.decodeJSON(param1.message.var_5550,var_4353);
            _loc3_ = _loc2_.action;
            _loc4_ = _loc2_.params;
            var _loc5_:* = _loc3_;
            if("world.gmo3-response" !== _loc5_)
            {
               _log.logRemote("ERROR.WebSocketComm.onWebSocketMessage","unknown action: " + _loc3_);
            }
            else
            {
               getMapObjects3Response(_loc4_);
            }
         }
         else if(param1.message.type === "binary")
         {
            _log.logRemote("ERROR.WebSocketComm.onWebSocketMessage","ignoring binary message of length: " + param1.message.var_4669.length);
         }
      }
      
      private function manageWebSocketLoggingState() : void
      {
         WebSocket.isLoggingEnabled = var_2972 >= 0 && var_2972 < 10;
         var_2972 = var_2972 + 1;
      }
      
      private function getMapObjects3Response(param1:Object) : void
      {
         var _loc2_:class_198 = new BattlePiratesJSONRemoteProcedureCall(null,null,null,null,null,null,null,false,true);
         _loc2_.replaceJSON(param1);
         if(!param1.isError && var_3262["world.gmo3-response"])
         {
            §§dup(var_3262)["world.gmo3-response"](_loc2_);
         }
         else if(param1.isError && var_3413["world.gmo3-response"])
         {
            §§dup(var_3413)["world.gmo3-response"](_loc2_);
         }
      }
   }
}
