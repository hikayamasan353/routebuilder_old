using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RouteBuilder
{
    public class RBSignal
    {
        public int type; /*
                          * Japanese type signals:
                          * 2 - 2-aspect R-Y
                          * -2 - 2-aspect R-G
                          * 3 - 3-aspect R-Y-G
                          * 4 - 4-aspect R-YY-Y-G
                          * -4 - 4-aspect R-Y-YG-G
                          * 5 - 5-aspect R-YY-Y-YG-G
                          * -5 - 5-aspect R-Y-YG-G-GG
                          * 6 - 6-aspect R-YY-Y-YG-G-GG
                          */
        public RBConnection connection;
        public int connectionid;
        public int direction; //-1/+1
        public string name;
        public double x;
        public double y;
        public bool relay;


    }
}
