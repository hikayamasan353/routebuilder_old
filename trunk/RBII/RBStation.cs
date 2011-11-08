using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace RouteBuilder
{
    public class RBStation : List<string>
    {
        public string stationname;
        public string arrivalsound;
        public string departuresound;
        public bool exported;

        //---------------------------
        //

        public int passalarm; //0 - no pass alarm, 1 - pass alarm
        public int doorside; //-1 - left, 0 - no, 1 - right, 2 - both
        public int forcedredsignal; //0 - no forced red signal, 1 - forced red signal
        public int peoplecount; //how much people at the station, 0...250
        public int stoptime; // the stop time
        public int system; //0 - ATS, 1 - ATC

        public RBStation(string name)
        {
            this.passalarm = 0;
            this.forcedredsignal = 0;
            this.peoplecount = 100;
            this.stationname = "";
            this.stoptime = 20;
            this.system = 0;
        }


        public void Get_platform_numbers(List<string> platform_numbers)
        {
            int i;
            platform_numbers.Clear();
            for (i = 0; i < platform_numbers.Count; i++)
            {
                platform_numbers.Add(i.ToString());
            }
        }

        public string StationNameExt()
        {
            return stationname + '|' + doorside.ToString() + '|' + peoplecount.ToString();
        }

        public string StationNameExt_ORP()
        {
            return null;
        }


        public int Get_track_ID_by_platform_number(string platform_number)
        {
            return Convert.ToInt32(platform_number);
        }

        public string Get_platform_number_by_track_ID(int id)
        {
            int i;
            for (i = 0; i < this.Count; i++)
            {
                if (this[i] == id.ToString())
                {
                    return this[i];
                    break;
                }
            }
            return "";

        }



        /*
         * Function: SetFromString
         * Author: Uwe Post
         * Purpose: To load stations from old .rbp files
         */
        public bool SetFromString(string s)
        {
            if (this.Count == 0)
            {
                return false;
            }

            return true;
        }



        /*
         * Function: 
         * Author: race
         * Purpose: To save the details to new .orp files
         */
        public string GetAsString_ORP()
        {
            if (this.Count > 0)
            {
                XmlNode node;
                
            }

            return null;
        }




    }
}
