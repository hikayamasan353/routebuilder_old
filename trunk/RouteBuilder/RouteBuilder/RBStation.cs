using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RouteBuilder
{
    public class RBStation : List<string>
    {
        public string stationname;
        public string arrivalsound;
        public string departuresound;
        public bool exported;
        public int doorside; //-1 - left, 0 - no doors, 1 - right


    }
}
