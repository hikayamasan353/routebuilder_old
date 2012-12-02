using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace RouteBuilder
{
    /// <summary>
    /// Represents a ground texture list in RouteBuilder
    /// </summary>
    public class RBGroundTextureList : List<string>
    {
        public string fn;

        public RBGroundTextureList()
        {
            
        }





    }

    public class RBTrackTextureList : List<string>
    {
    }

    /// <summary>
    /// Represents a wall list in RouteBuilder
    /// </summary>
    public class RBWallList : List<string>
    {
        public string fn;

        public RBWallList()
        {

        }
    }

    /// <summary>
    /// Represents a platform list in RouteBuilder
    /// </summary>
    public class RBPlatformList : List<string>
    {
        public string fn;

        public RBPlatformList()
        {

        }
    }





    /// <summary>
    /// Represents a station in RouteBuilder
    /// </summary>
    public class RBStation : List<string>
    {
        public string stationname;
        public string arrivalsound;
        public string departuresound;
        public bool exported;
        public DoorSide doorside;
        public System system;
        public int minstoptime;
        public int passalarm;
        public int forcedredsignal;

        public RBStation(string name)
        {
            this.stationname = name;
            doorside = DoorSide.N;
            this.system = System.ATS;
            this.arrivalsound = "";
            this.departuresound = "";
            this.passalarm = 0;
            this.forcedredsignal = 0;
        }


        /// <summary>
        /// Defines where doors should be opened
        /// </summary>
        public enum DoorSide
        {
            L,//left
            N,//no
            R,//right
            B//both

        }

        /// <summary>
        /// Defines what safety system would be used
        /// </summary>
        public enum System
        {
            ATS,
            ATC
        }

        /// <summary>
        /// Converts lettered door side values to numbered
        /// </summary>
        /// <param name="ds">The lettered door side value</param>
        /// <returns>The numbered door side value</returns>
        public int DoorSideToInt(DoorSide ds)
        {
            switch (ds)
            {
                case DoorSide.L:
                    return -1;
                case DoorSide.N:
                    return 0;
                case DoorSide.R:
                    return 1;
                case DoorSide.B:
                    return 0;
            }
            return 0;
        }

        /// <summary>
        /// Converts lettered system values to numbered
        /// </summary>
        /// <param name="s">The lettered system value</param>
        /// <returns>The numbered system value</returns>
        public int SystemToInt(System s)
        {
            switch (s)
            {
                case System.ATS:
                    return 0;
                case System.ATC:
                    return 1;
            }
            return 0;
        }



    }







    /// <summary>
    /// An export script.
    /// </summary>
    public class RBExport
    {
        protected bool fsmooth;
        protected List<string> groundtexturelist;
        protected List<string> tracktexturelist;
        protected List<string> walllist;



        protected List<string> usedtrackobjects;
        protected List<string> usedgrounds;
        protected List<string> usedwalls;
        protected List<string> usedbackgrounds;
        protected List<string> usedfreeobj;
        protected List<string> usedplatforms;
        protected List<string> usedroofs;
        protected List<string> usedpoles;

        protected List<string> header;

        protected int startindex;
        protected int nextindex;


        public RBExport(bool smooth)
        {
            this.fsmooth = smooth;

        }


        /// <summary>
        /// Exports a route header section to CSV format
        /// </summary>
        /// <param name="exportinterface">The route code</param>
        public void ExportHeaderCSV(List<string> exportinterface)
        {
            //exportinterface.Add(";made with RouteBuilder");
            exportinterface.Add("With Route"); 

        }

        /// <summary>
        /// Exports a route header section to RW format
        /// </summary>
        /// <param name="exportinterface">The route code</param>
        public void ExportHeaderRW(List<string> exportinterface)
        {
            exportinterface.Add("[Route]");
        }

        /// <summary>
        /// Exports a route train section to CSV format
        /// </summary>
        /// <param name="exportinterface">The route code</param>
        /// <param name="train">The train name</param>
        public void ExportTrainCSV(List<string> exportinterface, string train)
        {
            exportinterface.Add("With Train");
            exportinterface.Add(".Folder " + train); //add folder of train

        }

        /// <summary>
        /// Exports a route train section to RW format
        /// </summary>
        /// <param name="exportinterface">The route code</param>
        /// <param name="train">The train name</param>
        public void ExportTrainRW(List<string> exportinterface, string train)
        {
            exportinterface.Add("[Train]");//start section
            exportinterface.Add("Folder=" + train);//add folder key

        }


        public void ExportObjectsCSV(List<string> exportinterface)
        {
            int i;
            int j;
            int maxobjid;


            exportinterface.Add("With Structure");

            //export ground texture objects
            for (i = 0; i < groundtexturelist.Count; i++)
            {
                exportinterface.Add(".ground(" + groundtexturelist.IndexOf(groundtexturelist[i]) + ") " + groundtexturelist[i]);
            }

            //export rail texture objects
            for (i = 0; i < tracktexturelist.Count; i++)
            {
                exportinterface.Add(".rail(" + tracktexturelist.IndexOf(tracktexturelist[i]) + ") " + tracktexturelist[i]);
            }

            //export walls and dikes

            for (i = 0; i < walllist.Count; i++)
            {

            }



        }




    }
}
