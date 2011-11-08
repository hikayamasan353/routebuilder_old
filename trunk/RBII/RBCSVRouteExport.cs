using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using RouteBuilder;

namespace RouteBuilder
{
    public class RBCSVRouteExport
    {
        protected bool fsmooth;
        public RBGroundTextureList ground_texture_list;
        public List<string> wall_list;
        public List<string> background_texture_list;
        public List<string> track_texture_list;
        public List<string> platform_list;
        public List<string> roof_list;
        public List<string> catenary_pole_list;
        public List<string> crack_list;
        public List<string> beacon_list;

        public bool export_comment;


        public List<string> used_track_objects;
        public List<string> used_grounds;
        public List<string> used_walls;
        public List<string> used_dikes;



        protected int obj_count;
        List<object> fpoint_list;
        List<RBConnection> fconnection_list;
        List<RBConnection> primary_connection_list;
        protected int start_index;
        protected int next_index;

        public RBCSVRouteExport(bool smooth)
        {
            fsmooth = smooth;
            fpoint_list = new List<object>();
            fconnection_list = new List<RBConnection>();
            primary_connection_list = new List<RBConnection>();


            ground_texture_list = new RBGroundTextureList();
            background_texture_list = new List<string>();
            track_texture_list = new List<string>();
            platform_list = new List<string>();
            catenary_pole_list = new List<string>();
            wall_list = new List<string>();
            roof_list = new List<string>();
            crack_list = new List<string>();

        }

        public void Export_Header(List<string> export_interface)
        {
            

            obj_count = 0;
            export_interface.Add(";made with RouteBuilder");
            export_interface.Add("with Route");

            if (export_comment == true)
            {
                export_interface.Add(".comment " + "" + "$chr(13)$chr(10)" + "-----------------------" + "$chr(13)$chr(10)" + "Made with RouteBuilder");
            }

            else if (export_comment == false)
            {
                export_interface.Add(".comment " + "$chr(13)$chr(10)" + "-----------------------" + "$chr(13)$chr(10)" + "Made with RouteBuilder");
            }



                    

        }


        public void Export_Train(List<string> export_interface, string train)
        {
            export_interface.Add("with train");
            export_interface.Add(".folder " + train);

            //BVETSS 1.0 support


        }


        public void Export_Signal(List<string> export_interface)
        {
        }


        public void Export_Structure(List<string> export_interface)
        {
            int i;
            int j;

            export_interface.Add("with structure");

            //export grounds
            for (i = 0; i < ground_texture_list.Count; i++)
            {
                export_interface.Add(".ground(" + i + ") " + ground_texture_list.GetObjectFilenamebyID(i));
            }

            for (int i4 = 0; i4 < track_texture_list.Count; i4++)
            {
                export_interface.Add(".rail(" + i4.ToString() + ") " + track_texture_list[i4]);
            }

            //export walls
            for (int i3 = 0; i3 < wall_list.Count; i3++)
            {
                export_interface.Add(".wallL(" + i3.ToString() + ") " + wall_list[i3]);
                export_interface.Add(".dikeL(" + i3.ToString() + ") " + wall_list[i3]);
                export_interface.Add(".wallR(" + i3.ToString() + ") " + wall_list[i3]);
                export_interface.Add(".dikeR(" + i3.ToString() + ") " + wall_list[i3]);

            }

            for (int i2 = 0; i2 < platform_list.Count; i2++)
            {
                bool flag = true;
                if (flag)
                {
                    export_interface.Add(".formCL(" + i2.ToString() + ") " + platform_list[i2] + "CL.b3d");
                    export_interface.Add(".formCR(" + i2.ToString() + ") " + platform_list[i2] + "CR.b3d");
                    export_interface.Add(".formL(" + i2.ToString() + ") " + platform_list[i2] + "L.b3d");
                    export_interface.Add(".formR(" + i2.ToString() + ") " + platform_list[i2] + "R.b3d");
                }
                else
                {
                    export_interface.Add(".formCL(" + i2.ToString() + ") " + platform_list[i2] + "CL.csv");
                    export_interface.Add(".formCR(" + i2.ToString() + ") " + platform_list[i2] + "CR.csv");
                    export_interface.Add(".formL(" + i2.ToString() + ") " + platform_list[i2] + "L.csv");
                    export_interface.Add(".formR(" + i2.ToString() + ") " + platform_list[i2] + "R.csv");
                }
            }

            for (int i5 = 0; i5 < roof_list.Count; i5++)
            {
                bool flag = true;
                if (flag)
                {
                    export_interface.Add(".roofCL(" + i5.ToString() + ") " + roof_list[i5] + "CL.b3d");
                    export_interface.Add(".roofCR(" + i5.ToString() + ") " + roof_list[i5] + "CR.b3d");
                    export_interface.Add(".roofL(" + i5.ToString() + ") " + roof_list[i5] + "L.b3d");
                    export_interface.Add(".roofR(" + i5.ToString() + ") " + roof_list[i5] + "R.b3d");
                }
                else
                {
                    export_interface.Add(".roofCL(" + i5.ToString() + ") " + roof_list[i5] + "CL.csv");
                    export_interface.Add(".roofCR(" + i5.ToString() + ") " + roof_list[i5] + "CR.csv");
                    export_interface.Add(".roofL(" + i5.ToString() + ") " + roof_list[i5] + "L.csv");
                    export_interface.Add(".roofR(" + i5.ToString() + ") " + roof_list[i5] + "R.csv");
                }
            }


            for (int i6 = 0; i6 < crack_list.Count; i6++)
            {
                bool flag = true;
                if (flag)
                {
                    export_interface.Add(".crackL(" + i6.ToString() + ") " + crack_list[i6] + "L.b3d");
                    export_interface.Add(".crackR(" + i6.ToString() + ") " + crack_list[i6] + "R.b3d");
                }
                else
                {
                    export_interface.Add(".crackL(" + i6.ToString() + ") " + crack_list[i6] + "L.csv");
                    export_interface.Add(".crackR(" + i6.ToString() + ") " + crack_list[i6] + "R.csv");
                }
            }

            for (int i7 = 0; i7 < beacon_list.Count; i7++)
            {
                export_interface.Add(".beacon(" + i7.ToString() + ") " + beacon_list[i7]);
            }


        }





    }
}
