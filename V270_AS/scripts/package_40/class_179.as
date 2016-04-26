package package_40
{
   import com.waterworld.comm.class_74;
   import com.waterworld.core.GlobalProperties;
   import package_108.BattlePiratesJSONRemoteProcedureCall;
   
   class class_179 extends class_74
   {
      
      private static const const_2261:String = "rockets/getCurrent";
      
      private static const const_2558:String = "rockets/scrap";
      
      private static const const_3718:String = "rockets/prepare";
      
      private static const const_4172:String = "rockets/unprepare";
      
      private static const const_981:String = "rockets/build";
      
      private static const const_4606:String = "rockets/updateBuild";
       
      function class_179()
      {
         super();
      }
      
      static function getCurrent(param1:Function, param2:Function = null) : void
      {
         var _loc3_:String = var_6;
         _loc3_ = _loc3_ + "rockets/getCurrent";
         commonRequest(_loc3_,"",[],param1,param2);
      }
      
      static function scrap(param1:int, param2:Function, param3:Function = null) : void
      {
         var _loc4_:String = var_6;
         _loc4_ = _loc4_ + "rockets/scrap";
         commonRequest(_loc4_,"",[["rocketId",param1]],param2,param3);
      }
      
      static function prepare(param1:int, param2:Function, param3:Function = null) : void
      {
         var _loc4_:String = var_6;
         _loc4_ = _loc4_ + "rockets/prepare";
         commonRequest(_loc4_,"",[["rocketId",param1]],param2,param3);
      }
      
      static function unprepare(param1:int, param2:Function, param3:Function = null) : void
      {
         var _loc4_:String = var_6;
         _loc4_ = _loc4_ + "rockets/unprepare";
         commonRequest(_loc4_,"",[["rocketId",param1]],param2,param3);
      }
      
      static function build(param1:int, param2:Number, param3:Function, param4:Function = null) : void
      {
         var _loc5_:String = var_6;
         _loc5_ = _loc5_ + "rockets/build";
         commonRequest(_loc5_,"",[["itemCode",param1],["completeTime",param2],["startTime",GlobalProperties.gameTime]],param3,param4);
      }
      
      static function buildInstant(param1:int, param2:Number, param3:int, param4:Function, param5:Function = null) : void
      {
         var _loc6_:String = var_6;
         _loc6_ = _loc6_ + "rockets/instantBuild";
         commonRequest(_loc6_,"",[["itemCode",param1],["completeTime",param2],["startTime",GlobalProperties.gameTime],["expectedGold",param3]],param4,param5);
      }
      
      static function update(param1:int, param2:Number, param3:Function, param4:Function = null) : void
      {
         var _loc5_:String = var_6;
         _loc5_ = _loc5_ + "rockets/updateBuild";
         commonRequest(_loc5_,"",[["rocketId",param1],["completeTime",param2]],param3,param4);
      }
      
      static function speedup(param1:int, param2:int, param3:int, param4:Function, param5:Function = null) : void
      {
         var _loc6_:String = var_6;
         _loc6_ = _loc6_ + "rockets/speedup";
         commonRequest(_loc6_,"",[["rocketId",param1],["seconds",param2],["expectedGold",param3]],param4,param5);
      }
      
      private static function commonRequest(param1:String, param2:String, param3:Array, param4:Function, param5:Function = null, param6:Boolean = true) : void
      {
         url = param1;
         id = param2;
         args = param3;
         onSuccess = param4;
         onFailure = param5;
         load = param6;
         onSuccessInternal = function(param1:BattlePiratesJSONRemoteProcedureCall):void
         {
            var _loc5_:* = null;
            var _loc2_:* = undefined;
            var _loc3_:* = null;
            if(!param1.isError)
            {
               if(onSuccess != null)
               {
                  _loc5_ = param1.data.data?param1.data.data:null;
                  _loc2_ = new Vector.<class_225>();
                  var _loc7_:* = 0;
                  var _loc6_:* = _loc5_;
                  for each(var _loc4_ in _loc5_)
                  {
                     _loc3_ = new class_225();
                     _loc3_.init(_loc4_);
                     _loc2_.push(_loc3_);
                  }
                  onSuccess(_loc2_);
               }
            }
            else if(onFailure != null)
            {
               onFailure(param1);
            }
         };
         if(load)
         {
            loadRequest(url,"Y9U653YU641VUU3U1U6Z497075076655",args,id,onSuccessInternal,onFailure);
         }
         else
         {
            sendRequest(url,"Y9U653YU641VUU3U1U6Z497075076655",args,id,onSuccessInternal,onFailure);
         }
      }
   }
}
