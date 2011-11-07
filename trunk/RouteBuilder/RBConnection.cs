using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace RouteBuilder
{
    public class RBConnection
    {
        private RBPoint FP1;
        private RBPoint FP2;

        public int id;
        public int speedlimit; // speed limit
        public double height; //height above y=0
        public int adhesion; // adhesion
        public int accuracy;
        public int fogR; //fog red intensity
        public int fogG; //fog green intensity
        public int fogB; //fog blue intensity
        public int brightness; //brightness
        public int polespos; //-1 - left, 0 - no, 1 - right
        public bool exported;

        public string polestype; //poles filename
        public string background; //background filename
        public string ground; //ground filename
        public string platformtype; //platform filename
        public string rooftype; //roof filename
        public string dikel; //left dike filename
        public string diker; //right dike filename
        public string walll; //left wall filename
        public string wallr; //right wall filename
        public string crackl; //left crack filename
        public string crackr; //right crack filename
        public string beacon;

        public string markerfilename; //marker filename
        public int markerduration; //marker duration
        public string announcefilename; //announcement sound filename
        public string dopplerfilename; //doppler sound filename

        public int transpondertype;


        public RBConnection(RBPoint p1, RBPoint p2)
        {
            this.FP1 = p1;
            this.FP2 = p2;
            this.speedlimit = 0;
            this.height = 0;
            this.adhesion = 255;
            this.accuracy = 1;
            this.background = "";
            this.brightness = 255;
            this.ground = "";
            this.fogR = 0;
            this.fogG = 0;
            this.fogB = 0;
            this.polespos = 0;
            this.polestype = "";
            this.walll = "";
            this.walll = "";
            this.dikel = "";
            this.diker = "";
            this.rooftype = "";
            this.transpondertype = 0;
            


        }

        //public RBConnection(RBPoint p1,RBPoint p2,int speedlimit,double height,


        public void Create_from_string(string s, List<object> points)
        {
            int i;
            int p1id;
            int p2id;

        }

        public RBConnection(XmlNode items)
        {
            int i;
            int p1id;
            int p2id;

            this.id = (int)Tools.Xml.GetDouble(items["id"]);
            p1id = (int)Tools.Xml.GetDouble(items["p1id"]);
            p2id = (int)Tools.Xml.GetDouble(items["p2id"]);
            this.speedlimit = (int)Tools.Xml.GetDouble(items["limit"]);
            this.height = Tools.Xml.GetDouble(items["height"]);
            this.adhesion = (int)Tools.Xml.GetDouble(items["adhesion"]);
            this.accuracy = (int)Tools.Xml.GetDouble(items["accuracy"]);
            this.background = items["background"].InnerText;
            this.brightness = (int)Tools.Xml.GetDouble(items["brightness"]);
            this.background = items["ground"].InnerText;
            this.fogR = (int)Tools.Xml.GetDouble(items["fogr"]);
            this.fogG = (int)Tools.Xml.GetDouble(items["fogg"]);
            this.fogB = (int)Tools.Xml.GetDouble(items["fogb"]);
            this.markerfilename = items["marker_filename"].InnerText;
            this.markerduration = (int)Tools.Xml.GetDouble(items["marker_duration"]);
            this.announcefilename = items["announce_filename"].InnerText;
            this.dopplerfilename = items["doppler_filename"].InnerText;

            this.platformtype = items["form_type"].InnerText;
            this.rooftype = items["roof_type"].InnerText;

            this.walll = items["wall_left"].InnerText;
            this.wallr = items["wall_right"].InnerText;
            this.dikel = items["dike_left"].InnerText;
            this.diker = items["dike_right"].InnerText;
            this.crackl = items["crack_left"].InnerText;
            this.crackr = items["crack_right"].InnerText;
            this.polestype = items["poles_type"].InnerText;
            this.beacon = items["beacon"].InnerText;

            this.transpondertype = (int)Tools.Xml.GetDouble(items["transponder_type"]);
            
            

        }


        public RBConnection(RBConnection from)
        {
            from = new RBConnection(from.FP1, from.FP2);
        }

        public RBConnection(int p1id, int p2id)
        {
            this.p1.id = p1id;
            this.p2.id = p2id;
        }


        public void CopyProperties(RBConnection from)
        {
            this.accuracy = from.accuracy;
            this.adhesion = from.adhesion;
            this.announcefilename = from.announcefilename;
            this.background = from.background;
            this.brightness = from.brightness;
            this.dikel = from.dikel;
            this.diker = from.diker;
            this.dopplerfilename = from.dopplerfilename;
            this.fogR = from.fogR;
            this.fogG = from.fogG;
            this.fogB = from.fogB;
            this.ground = from.ground;
            this.height = from.height;
            this.markerduration = from.markerduration;
            this.markerfilename = from.markerfilename;
            this.platformtype = from.platformtype;
            this.polespos = from.polespos;
            this.polestype = from.polestype;
            this.rooftype = from.rooftype;
            this.speedlimit = from.speedlimit;
            this.walll = from.walll;
            this.wallr = from.wallr;

        }



        public RBConnection(string s, List<object> points)
        {
            //RBConnection conn = new RBConnection(null, null);
            int i;
            int p1id;
            int p2id;
            



        }






        public RBPoint p1
        {
            get
            {
                return FP1;
            }
        }

        public RBPoint p2
        {
            get
            {
                return FP2;
            }
        }






    }


    public class RBConnection_list : List<RBConnection>
    {


        public int Find_connections_at_point(RBPoint p, List<object> connlist, RBConnection notthis)
        {
            int i;
            connlist.Clear();
            for (i = 0; i < this.Count; i++)
            {
                if (this[i] is RBConnection)
                {
                    if (((this[i] as RBConnection).p1 == p) | ((this[i] as RBConnection).p2 == p))
                    {
                        if ((this[i] as RBConnection) != notthis)
                        {
                            connlist.Add(this[i] as RBConnection);
                        }

                    }

                }
            }
            return connlist.Count;
        }



    }



}
