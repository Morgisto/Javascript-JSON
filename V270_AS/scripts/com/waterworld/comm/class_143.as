package com.waterworld.comm
{
   public class class_143 extends class_74
   {
      
      private static const const_3177:String = "api/player/joinchats";
      
      private static const const_4131:String = "CCJCI";
      
      private static const const_2430:String = "/ignore/list";
      
      private static const const_4298:String = "CCGIL";
      
      private static const const_3338:String = "/ignore/add";
      
      private static const const_759:String = "CCAIL";
      
      private static const const_4014:String = "/ignore/remove";
      
      private static const const_4432:String = "CCRIL";
       
      public function class_143()
      {
         super();
      }
      
      public static function joinChats(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var _loc4_:Array = [["resource",param1]];
         loadRequest(var_6 + "api/player/joinchats","Y9U653YU641VUU3U1U6Z497075076655",_loc4_,"CCJCI",param2,param3);
      }
      
      public static function getIgnoreList(param1:Function = null, param2:Function = null) : void
      {
         loadRequest(var_6 + "/ignore/list","Y9U653YU641VUU3U1U6Z497075076655",[],"CCGIL",param1,param2);
      }
      
      public static function addUserToIgnoreList(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var _loc4_:Array = [["userid",param1]];
         loadRequest(var_6 + "/ignore/add","Y9U653YU641VUU3U1U6Z497075076655",_loc4_,"CCAIL",param2,param3);
      }
      
      public static function removeUserFromIgnoreList(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var _loc4_:Array = [["userid",param1]];
         loadRequest(var_6 + "/ignore/remove","Y9U653YU641VUU3U1U6Z497075076655",_loc4_,"CCRIL",param2,param3);
      }
   }
}
