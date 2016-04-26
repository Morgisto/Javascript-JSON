package com.waterworld.comm
{
   import com.waterworld.core.GlobalProperties;
   
   public class class_139 extends class_74
   {
      
      public static const const_4418:String = "api/player/tutorialStage";
      
      public static const const_2275:String = "TCTUS";
      
      public static const const_3208:String = "read";
      
      public static const const_2597:String = "write";
       
      public function class_139()
      {
         super();
      }
      
      public static function saveTutorialStage(param1:int, param2:Function, param3:Function) : void
      {
         loadRequest(GlobalProperties.baseURL + "api/player/tutorialStage","Y9U653YU641VUU3U1U6Z497075076655",[["mode","write"],["tutorialstage",param1]],"TCTUS",param2,param3);
      }
      
      public static function getTutorialStage(param1:Function, param2:Function) : void
      {
         loadRequest(GlobalProperties.baseURL + "api/player/tutorialStage","Y9U653YU641VUU3U1U6Z497075076655",[["mode","read"]],"TCTUS",param1,param2);
      }
   }
}
