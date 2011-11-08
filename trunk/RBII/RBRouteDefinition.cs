using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RouteBuilder
{
    public class RBRouteDefinition : List<string>
    {
        public int id;
        public string name;


        public string GetTitle()
        {
            return "ID" + id.ToString() + ": " + name;
        }

        public bool Contains_Track(int id)
        {
            return id >= 0;
        }

    }
}
