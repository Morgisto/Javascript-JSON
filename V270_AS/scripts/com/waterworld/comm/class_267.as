package com.waterworld.comm
{
   import com.waterworld.core.GlobalProperties;
   
   public class class_267 extends class_74
   {
      
      private static const const_2883:String = "api/bm/getgamedataversions";
      
      private static const const_889:String = "GCGDV";
      
      private static const const_2207:String = "api/bm/getgamedatahash";
      
      private static const const_962:String = "GCGDH";
      
      private static const const_1159:String = "gamedata/get";
      
      private static const const_1815:String = "GCGD";
       
      public function class_267()
      {
         super();
      }
      
      public static function getGameVersions(param1:Function, param2:Function) : void
      {
         loadRequest(GlobalProperties.baseURL + "api/bm/getgamedataversions","Y9U653YU641VUU3U1U6Z497075076655",null,"GCGDV",param1,param2);
      }
      
      public static function getGameDataHash(param1:String, param2:int, param3:Function, param4:Function) : void
      {
         loadRequest(GlobalProperties.baseURL + "api/bm/getgamedatahash","Y9U653YU641VUU3U1U6Z497075076655",[["type",param1],["version",param2]],"GCGDH",param3,param4);
      }
      
      public static function getGameData(param1:Function, param2:Function) : void
      {
         loadRequest(GlobalProperties.baseURL + "gamedata/get","Y9U653YU641VUU3U1U6Z497075076655",null,"GCGD",param1,param2);
      }
   }
}
