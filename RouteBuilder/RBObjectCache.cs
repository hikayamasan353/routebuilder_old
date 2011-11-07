using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RouteBuilder
{
    public class RBObjectCache : List<string>
    {

        public void AddObject(string s, object obj)
        {
            List<string> s1 = new List<string>();
            s1 = obj as List<string>;
            
        }



    }
}
