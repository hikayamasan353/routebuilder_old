using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Windows.Forms;
using System.Text;

namespace RouteBuilder
{
    public class RBGroundTextureList : List<string>
    {



        public string filename;


        public RBGroundTextureList()
        {
            filename = Application.StartupPath;

        }



    }
}
