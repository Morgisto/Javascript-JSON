package com.waterworld.entities.catchup
{
   import com.waterworld.entities.BuildingGenericProducer;
   
   public class class_409 extends Object
   {
       
      public function class_409()
      {
         super();
      }
      
      public static function catchUp(param1:BuildingGenericProducer) : Boolean
      {
         var _loc2_:* = 0;
         if(param1.isBuildingFunctional())
         {
            if(param1.producing)
            {
               _loc2_ = param1.var_119 / param1.getProductionTime();
               if(_loc2_ == 0)
               {
                  §§dup(param1).countdownProduce--;
                  if(param1.countdownProduce <= 0)
                  {
                     param1.produce(1);
                  }
               }
               else
               {
                  param1.produce(_loc2_);
               }
            }
            else if(param1.stored < param1._buildingProps.capacity[param1.level - 1] && param1.hp > 0)
            {
               param1.startProduction();
            }
            return true;
         }
         return false;
      }
   }
}
