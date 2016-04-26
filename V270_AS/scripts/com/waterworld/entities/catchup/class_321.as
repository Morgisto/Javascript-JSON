package com.waterworld.entities.catchup
{
   import com.waterworld.entities.RocketLaunchPad;
   import com.waterworld.core.GLOBAL;
   import package_40.class_301;
   
   public class class_321 extends Object
   {
       
      public function class_321()
      {
         super();
      }
      
      public static function catchUp(param1:RocketLaunchPad, param2:int) : Boolean
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         if(param1.rocketEndTime)
         {
            if(param1.isBuildingFunctional())
            {
               _loc3_ = param1.rocketEndTime - (param2 + param1.var_119);
               if(_loc3_ <= 0)
               {
                  _loc4_ = GLOBAL.rocketInventory.getLastBuiltRocket();
                  param1.finishRocket(_loc4_.itemCode);
               }
            }
            return true;
         }
         return false;
      }
   }
}
