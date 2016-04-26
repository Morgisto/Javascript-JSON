package com.waterworld.comm
{
   import com.waterworld.core.GlobalProperties;
   
   public class class_260 extends class_74
   {
      
      private static const const_2883:String = "rewards/getAll";
      
      private static const const_889:String = "GGRWD";
       
      public function class_260()
      {
         super();
      }
      
      public static function getGlobalRewards(param1:Function, param2:Function) : void
      {
         loadRequest(GlobalProperties.baseURL + "rewards/getAll","Y9U653YU641VUU3U1U6Z497075076655",null,"GGRWD",param1,param2);
      }
   }
}
