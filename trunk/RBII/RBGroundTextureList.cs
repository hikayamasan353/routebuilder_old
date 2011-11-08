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


        public string GetObjectFilenamebyID(int id)
        {
            return this[id];
        }

        public int Get_index_by_ID(int id)
        {
            return this.IndexOf(id.ToString());
        }

        public int Get_ID_by_index(int i)
        {
            if (i < 0) { return 0; }
            else
            {
                return i;
            }
        }


    }
}
