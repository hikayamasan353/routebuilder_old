using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace RouteBuilder
{
    public class RBObject : List<string>
    {
        protected string ffolder;
        protected Double_Cube fmaxcube;
        public Double_Point point;
        public int angle;
        public int yoffset;
        public int boundtoconnid;
        public string fobj_filename;
        public string file_extension;


        public Double_Cube max_cube
        {
            get
            {
                return fmaxcube;
            }
        }

        public string folder
        {
            get
            {
                return ffolder;
            }
        }





        public RBObject(string folder, string objectfilename)
        {
            this.angle = 0;
            this.boundtoconnid = 0;
            this.ffolder = folder;
            this.yoffset = 0;
            this.fobj_filename = objectfilename;
        }

        public RBObject(RBObject src)
        {

        }




        public void Reload(bool force)
        {
            string s;
            int j;
            s = ffolder + "\\" + fobj_filename;
            file_extension = Path.GetExtension(s);


        }


        public void Calc_MaxCube()
        {
            int i;
            int p;
            double x; double y; double z;
            string ks;
            double[] coord;

            fmaxcube.x1 = -999;
            fmaxcube.y1 = -999;
            fmaxcube.z1 = -999;
            fmaxcube.x2 = 999;
            fmaxcube.y2 = 999;
            fmaxcube.z2 = 999;



        }


        public void Scale(double f)
        {
            point.x = point.x * f;
            point.y = point.y * f;
        }



        public void Get_bitmap_list(List<string> bitmaps)
        {
            int i;
            bitmaps.Clear();
            bitmaps.Sort();

            for (i = 0; i < bitmaps.Count; i++)
            {
                if (file_extension == ".b3d")
                {
                    
                }
            }
        }



        public string Get_path()
        {
            return ffolder + "\\" + fobj_filename;
        }


        public void Save_as_CSV()
        {

        }





    }
}
