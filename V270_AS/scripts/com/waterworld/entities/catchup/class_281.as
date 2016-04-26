package com.waterworld.entities.catchup
{
   import com.waterworld.entities.BuildingFoundation;
   import package_10.BaseManager;
   import com.waterworld.core.GlobalProperties;
   
   public class class_281 extends Object
   {
       
      public function class_281()
      {
         super();
      }
      
      public static function catchUp(param1:BuildingFoundation) : Boolean
      {
         var _loc2_:* = false;
         var _loc3_:* = 0;
         if(param1.designBuildEndTime)
         {
            if(param1.hp == param1.hpMax)
            {
               if(param1.isDesignBuildPaused())
               {
                  BaseManager.getInstance().activityQueue.removeActivity("building" + param1._id);
                  _loc2_ = BaseManager.getInstance().activityQueue.addActivity("building" + param1._id,param1);
                  if(_loc2_)
                  {
                     param1.hasWorker();
                     param1.var_331 = true;
                     param1.unPauseDesignBuild();
                  }
               }
               if(param1.var_793 || !param1._buildingProps.var_308)
               {
                  _loc3_ = param1.designBuildEndTime + param1.designBuildPauseDelta - param1.designBuildSpeedUpTime - param1.var_119 - GlobalProperties.gameTime;
                  if(_loc3_ <= 0)
                  {
                     param1.designBuildComplete();
                  }
               }
            }
            else
            {
               param1.addTimeToDesignBuildEndTime(param1.var_119);
               param1.addTimeToDesignBuildStartTime(param1.var_119);
            }
            return true;
         }
         return false;
      }
   }
}
