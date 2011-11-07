using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RouteBuilder
{
    public class RBTransponder
    {
        public int type; /*
                          * Japanese ATS transponders
                          * 0 - ATS-SN S-type transponder
                          * 1 - ATS-SN SN-type transponder
                          * 2 - ATS-SN Accidental transponder
                          * 3 - ATS-P pattern renewal transponder
                          * 4 - ATS-P immediate stop transponder
                          */
        public int signal; //the signal reference ID
        public int switchsystem; /*
                                  * -1 - does not switch between ATS-SN and ATS-P
                                  * 0 - does automatically switch to ATS-SN for transponders 0 and 1, and to ATS-P for transponders 3 and 4
                                  */

        public RBConnection connection;






    }
}
