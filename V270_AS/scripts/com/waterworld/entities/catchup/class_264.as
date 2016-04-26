package com.waterworld.entities.catchup
{
   import com.waterworld.entities.DefensivePlatform;
   
   public class class_264 extends Object
   {
       
      public function class_264()
      {
         super();
      }
      
      public static function catchUp(param1:DefensivePlatform, param2:int) : Boolean
      {
         var _loc3_:* = 0;
         param1.updateTurretVisibility();
         if(param1.buildEndTime)
         {
            if(param1.var_37 > 0)
            {
               param1.addTimeToBuildEndTime(param1.var_37);
               param1.addTimeToBuildStartTime(param1.var_37);
            }
            if(param1.isBuildingFunctional())
            {
               _loc3_ = param1.buildEndTime - (param2 + param1.buildSpeedUpTime + param1.var_119);
               if(_loc3_ <= 0)
               {
                  param1.turretBuildCompleted();
               }
            }
            return true;
         }
         return false;
      }
   }
}
