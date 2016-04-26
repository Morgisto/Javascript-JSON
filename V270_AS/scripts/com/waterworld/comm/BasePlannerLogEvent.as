package com.waterworld.comm
{
   import package_59.BPLogEvent;
   
   public class BasePlannerLogEvent extends BPLogEvent
   {
       
      public function BasePlannerLogEvent(param1:Object)
      {
         super();
         this.addNameValuePair("tag","base_planner");
         this.addNameValuePair("final_configuration",param1);
      }
   }
}
