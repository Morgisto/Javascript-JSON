package com.waterworld.entities.catchup
{
   import com.waterworld.entities.BuildingFoundation;
   import package_10.BaseManager;
   
   public class class_167 extends Object
   {
       
      public function class_167()
      {
         super();
      }
      
      public static function catchUp(param1:BuildingFoundation, param2:int) : Boolean
      {
         var _loc3_:* = false;
         var _loc4_:* = 0;
         if(param1.upgradeFortificationEndTime)
         {
            if(param1.var_37 > 0)
            {
               param1.addTimeToUpgradeFortificationEndTime(param1.var_37);
               param1.addTimeToUpgradeFortificationStartTime(param1.var_37);
            }
            if(param1.hp == param1.hpMax)
            {
               if(param1.isFortificationPaused())
               {
                  BaseManager.getInstance().activityQueue.removeActivity("building" + param1._id);
                  _loc3_ = BaseManager.getInstance().activityQueue.addActivity("building" + param1._id,param1);
                  if(_loc3_)
                  {
                     param1.unpauseFortification();
                     param1.hasWorker();
                     param1.var_331 = true;
                  }
               }
               if(param1.var_793 || !param1._buildingProps.var_308)
               {
                  _loc4_ = param1.upgradeFortificationEndTime + param1.upgradeFortificationPauseDelta - param1.upgradeFortificationSpeedUpTime - param1.var_119 - param2;
                  if(_loc4_ <= 0)
                  {
                     param1.upgraded(1);
                  }
               }
            }
            return true;
         }
         return false;
      }
   }
}
