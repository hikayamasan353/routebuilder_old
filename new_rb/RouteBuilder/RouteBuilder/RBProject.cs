using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RouteBuilder
{
    public class RBProject
    {
        public string projectname;
        public string author;
        public string description;
        public string authoremail;
        public string projectfilename;

        public int gauge;
        public int vmaxslowsignal;

        public string routefilesdir; //route files directory
        public string routefilessubdir;
        public bool expertmode; //expert mode

        //object lists
        public List<object> dikes; //dikes
        public List<object> walls; //walls
        public List<object> backgrounds; //backgrounds
        public List<object> grounds; //grounds
        public List<object> freeobjects; //freeobjects
        public List<object> trains;
        public List<object> routes;
        public List<object> stations;
        public List<object> points;
        public List<object> grids;

        public List<string> defaultobjects;



        public RBProject()
        {
            this.projectfilename = "";
            this.gauge = 1435;
            this.vmaxslowsignal = 40;


            this.expertmode = false;

            dikes = new List<object>();
            walls = new List<object>();
            freeobjects = new List<object>();
            backgrounds = new List<object>();
            trains = new List<object>();

        }

        public RBProject(string filename, int gauge, int vmss, bool expertmode)
        {
            this.projectfilename = filename;

            this.gauge = gauge;
            this.vmaxslowsignal = vmss;

            this.expertmode = expertmode;
        }

        public RBProject(bool expertmode)
        {
            this.expertmode = expertmode;
        }

        public string SaveToFile()
        {
            string _filename;

        }

    }
}
