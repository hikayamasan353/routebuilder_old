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
        public List<string> ground_texture_list;
        public List<string> wall_list;
        protected List<string> background_texture_list;
        protected List<string> track_texture_list;
        protected List<string> platform_list;
        protected List<string> roof_list;
        protected List<string> catenary_pole_list;

        public bool export_comment;


        public List<string> used_track_objects;
        public List<string> used_grounds;
        public List<string> used_walls;
        public List<string> used_dikes;



        protected int obj_count;
        protected List<RBConnection> fconnection_list;
        protected List<RBConnection> primary_connection_list;
        protected int start_index;
        protected int next_index;

        public RBCSVRouteExport(bool smooth)
        {
            fsmooth = smooth;
            fconnection_list = new List<RBConnection>();

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
                export_interface.Add(".ground(" + ground_texture_list.IndexOf(ground_texture_list[i]) + ")");

            }

            for (int i3 = 0; i3 < wall_list.Count; i3++)
            {

            }

            for (int i2 = 0; i2 < platform_list.Count; i2++)
            {

            }


        }





    }
}
