package package_108
{
   import flash.net.URLVariables;
   import package_221.MD5;
   import flash.net.URLLoader;
   import package_21.class_330;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.HTTPStatusEvent;
   
   public class AbstractRemoteProcedureCall extends Object
   {
      
      public static var var_5864:Boolean = false;
      
      private static const const_175:RegExp = new RegExp(",\\\"h\\\":\\\"(\\w+)\\\",\\\"hn\\\":(\\d+)");
       
      protected var var_376:String;
      
      protected var var_4172:String;
      
      protected var var_1691:URLVariables;
      
      protected var var_3394:String;
      
      protected var _onSuccess:Function;
      
      protected var _onFailure:Function;
      
      protected var var_3382:String;
      
      protected var var_4999:Boolean;
      
      protected var var_5854:Boolean;
      
      protected var var_261:URLLoader;
      
      protected var var_10;
      
      protected var var_176;
      
      protected var var_4298:String = "";
      
      protected var var_2698:int = 0;
      
      public function AbstractRemoteProcedureCall(param1:String, param2:Array, param3:String, param4:Function, param5:Function, param6:String, param7:String, param8:Boolean, param9:Boolean, param10:int = 3)
      {
         super();
         this.var_376 = param1;
         this.var_4172 = param3;
         this.var_3394 = param6;
         this._onSuccess = param4;
         this._onFailure = param5;
         this.var_3382 = param7;
         this.var_4999 = param8;
         this.var_5854 = param9;
         this.var_2698 = param10;
         if(this.var_4999)
         {
            this.var_1691 = getHashedData(this.var_3382,param2);
         }
         else
         {
            this.var_1691 = param2 != null?createLoaderVars(this.var_3382,param2):null;
         }
         if(this.var_376 != null && this.var_376.indexOf("null") != 0)
         {
            this.doCall();
         }
      }
      
      public static function getHashedData(param1:String, param2:Array) : URLVariables
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc3_:String = "";
         var _loc7_:URLVariables = new URLVariables();
         if(param2 != null && param2.length > 0)
         {
            _loc4_ = param2.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = param2[_loc5_];
               _loc3_ = _loc3_ + _loc6_[1];
               _loc7_[_loc6_[0]] = _loc6_[1];
               _loc5_++;
            }
         }
         var _loc8_:int = Math.random() * 9999999;
         var _loc9_:String = getHash(param1,_loc3_,_loc8_);
         _loc7_.hn = _loc8_;
         _loc7_.h = _loc9_;
         return _loc7_;
      }
      
      public static function getHashedObject(param1:String, param2:Array) : Object
      {
         var _loc3_:* = null;
         var _loc7_:Object = {};
         var _loc6_:String = getHashedData(param1,param2).toString();
         var _loc5_:Array = _loc6_.split("&");
         var _loc9_:* = 0;
         var _loc8_:* = _loc5_;
         for each(var _loc4_ in _loc5_)
         {
            _loc3_ = _loc4_.split("=");
            _loc7_[_loc3_[0]] = _loc3_[1];
         }
         return _loc7_;
      }
      
      public static function getHash(param1:String, param2:String, param3:int) : String
      {
         return MD5.hash(getSalt(param1) + param2 + getNum(param3));
      }
      
      public static function getSalt(param1:String) : String
      {
         var _loc4_:* = 0;
         var _loc2_:int = param1.length - 1;
         var _loc3_:Array = [];
         do
         {
            _loc4_ = 90 - param1.charAt(_loc2_).charCodeAt(0) + 97;
            if(_loc4_ == 139)
            {
               _loc4_ = _loc4_ - 91;
            }
            else if(_loc4_ >= 130)
            {
               _loc4_ = _loc4_ - 81;
            }
            _loc3_.unshift(String.fromCharCode(_loc4_));
            _loc2_--;
         }
         while(_loc2_ >= 0);
         
         return _loc3_.join("");
      }
      
      public static function verifyHash(param1:String, param2:String) : Boolean
      {
         var _loc4_:Array = param1.match(const_175);
         if(!(_loc4_ && _loc4_.length == 3))
         {
            return false;
         }
         var _loc7_:String = _loc4_[1];
         var _loc6_:String = _loc4_[2];
         var _loc5_:String = param1.replace(const_175,"");
         var _loc3_:String = MD5.hash(getSalt(param2) + _loc5_ + getNum(parseInt(_loc6_)));
         if(_loc7_ !== _loc3_)
         {
            return false;
         }
         return true;
      }
      
      protected static function getNum(param1:int) : int
      {
         return param1 * (param1 % 11);
      }
      
      protected static function createLoaderVars(param1:String, param2:Array) : URLVariables
      {
         var _loc11_:* = 0;
         var _loc5_:* = null;
         var _loc9_:int = Math.random() * 9999999;
         var _loc12_:int = _loc9_ * (_loc9_ % 11);
         var _loc7_:Array = [];
         var _loc4_:int = param2.length;
         _loc11_ = 0;
         while(_loc11_ < _loc4_)
         {
            if(param2[_loc11_] != null)
            {
               _loc7_.push({
                  "n":param2[_loc11_],
                  "v":param2[_loc11_ + 1]
               });
            }
            _loc11_ = _loc11_ + 2;
         }
         _loc7_.sortOn("n");
         var _loc14_:* = 0;
         var _loc13_:* = _loc7_;
         for each(var _loc8_ in _loc7_)
         {
            var param1:String = param1 + (_loc8_.v);
         }
         param1 = param1 + (_loc12_);
         var _loc10_:String = MD5.hash(param1);
         var _loc3_:URLVariables = new URLVariables();
         var _loc6_:int = _loc7_.length;
         _loc11_ = 0;
         while(_loc11_ < _loc6_)
         {
            _loc5_ = _loc7_[_loc11_];
            _loc3_[_loc5_.n] = _loc5_.v;
            _loc11_++;
         }
         _loc3_.hn = _loc9_;
         _loc3_.h = _loc10_;
         return _loc3_;
      }
      
      public function get data() : Object
      {
         return this.var_10;
      }
      
      public function get isError() : Boolean
      {
         return this.var_10 == null;
      }
      
      public function get error() : *
      {
         return this.var_176;
      }
      
      public function get url() : String
      {
         return this.var_376;
      }
      
      public function get urlVariables() : String
      {
         return this.var_1691.toString();
      }
      
      public function get statusEventLog() : String
      {
         return var_4298;
      }
      
      protected function doCall() : void
      {
         class_330.startLoadTime(this.var_4172);
         this.var_261 = new URLLoader();
         if(this.var_3394 == "GET")
         {
            if(this.var_376.indexOf("?") > 0)
            {
               this.var_376 = this.var_376 + "&";
            }
         }
         var _loc1_:URLRequest = new URLRequest(this.var_376);
         if(var_1691 != null)
         {
            _loc1_.data = this.var_1691;
         }
         _loc1_.method = this.var_3394;
         this.var_261.addEventListener("complete",this.handleLoadComplete);
         this.var_261.addEventListener("ioError",this.handleIOError);
         this.var_261.addEventListener("securityError",this.handleSecurityError);
         this.var_261.addEventListener("httpStatus",this.handleStatus);
         this.var_261.load(_loc1_);
      }
      
      protected function stopListening() : void
      {
         this.var_261.removeEventListener("complete",this.handleLoadComplete);
         this.var_261.removeEventListener("ioError",this.handleIOError);
         this.var_261.removeEventListener("securityError",this.handleSecurityError);
         this.var_261.removeEventListener("httpStatus",this.handleStatus);
      }
      
      protected function handleLoadComplete(param1:Event) : void
      {
         this.stopListening();
         class_330.stopLoadTime(this.var_4172);
         this.var_10 = this.var_261.data;
         if(this._onSuccess != null)
         {
            this._onSuccess(this);
         }
         this._onSuccess = null;
         this._onFailure = null;
      }
      
      protected function handleIOError(param1:IOErrorEvent) : void
      {
         this.stopListening();
         var _loc2_:* = §§dup(this).var_2698 - 1;
         §§dup(this).var_2698--;
         if(_loc2_ > 0)
         {
            this.doCall();
         }
         else
         {
            this.var_176 = param1;
            if(this._onFailure != null)
            {
               this._onFailure(this);
            }
         }
      }
      
      protected function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         this.stopListening();
         var _loc2_:* = §§dup(this).var_2698 - 1;
         §§dup(this).var_2698--;
         if(_loc2_ > 0)
         {
            this.doCall();
         }
         else
         {
            this.var_176 = param1;
            if(this._onFailure != null)
            {
               this._onFailure(this);
            }
         }
      }
      
      protected function handleStatus(param1:HTTPStatusEvent) : void
      {
         var_4298 = §§dup().var_4298 + ("HTTPStatusEvent: " + param1.status + "\n");
      }
   }
}
