using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Xml;

namespace RouteBuilder
{
    public class RBProject
    {
        public string projectname;
        public string projectdescription;
        public string author;
        public string authoremail;
        public string credits;
        public string homepageurl;

        public int vmaxslowsignal;
        public int gauge;

        public List<RBConnection> connections;
        public List<string> default_objects;


        public List<object> dikes;
        public List<object> walls;
        public List<object> backgrounds;
        public List<object> grounds;
        public List<object> freeobj;
        public List<object> trains;
        public List<object> routes;
        public List<RBStation> stations;
        public List<RBPoint> points;
        public List<RBSignal> signals;
        public List<RBTransponder> transponders;



        public RBProject()
        {
            projectname = "";
            projectdescription = "";
            vmaxslowsignal = 40;
            gauge = 1435;

            connections = new List<RBConnection>();

            default_objects = new List<string>();

        }









        public bool LoadfromRBP(string filename)
        {
            /*
             * This method loads the old .rbp files into the new RouteBuilder.
             */
            List<string> projectfile;
            
            int id;
            int i;
            int j;

            string n;
            string v;
            List<string> sl;

            RBConnection connection;
            RBConnection conn;
            RBObject obj;
            RBStation station;
            RBSignal signal;

            if (!File.Exists(filename))
            {
                return false;
            }
            else
            {

                projectfile = new List<string>();

                


                ////Contains project data
                





                //load points
                for (int i2 = 0; i2 < projectfile.Count; i2++)
                {
                    string str1=projectfile[i2].Substring(1, 5);
                    if (str1=="point")
                    {
                        n = projectfile[i2].Substring(1, projectfile[i2].IndexOf('=',i2) - 1);
                        v = projectfile[i2].Substring(n.Length + 2, int.MaxValue);

                    }
                }


                //connections
                for (int i3 = 0; i3 < projectfile.Count; i3++)
                {
                    string str2 = projectfile[i3].Substring(1, 4);
                    if (str2 == "conn")
                    {
                        n = projectfile[i3].Substring(1, projectfile[i3].IndexOf('=', i3) - 1);
                        v = projectfile[i3].Substring(n.Length + 2, int.MaxValue);
                    }
                }




                for (int i2 = 0; i2 < connections.Count; i2++)
                {
                    //connection = connections[i] as RBConnection;

                    ////ground
                    //connection.ground=


                }





            }



            return false;//will be temporary

        }

        public bool LoadfromORP(string filename)
        {
            /*
             * This method loads the new .orp files into the new RouteBuilder
             */
            RBPoint point;
            RBConnection connection;
            RBObject obj;
            RBStation station;
            RBSignal signal;
            RBTransponder transponder;

            if (!File.Exists(filename))
            {
                return false;
            }
            else
            {
                XmlDocument project_orp = new XmlDocument();
                XmlElement e1 = project_orp["ORP"];


                //load summary
                projectname = e1["name"].InnerText;
                author = e1["author"].InnerText;
                authoremail = e1["email"].InnerText;
                gauge = (int)Tools.Xml.GetDouble(e1["gauge"]);
                if (gauge==0)
                {
                    gauge = 1435;
                }


                homepageurl = e1["url"].InnerText;

                projectdescription = e1["url"].InnerText;

                //load points
                XmlElement e2 = e1["Points"];
                for (int i = 0; i < e2.ChildNodes.Count; i++)
                {
                    XmlNode node = e2.ChildNodes[i];
                    point = new RBPoint(node);
                    points.Add(point);
                }

                //load connections
                XmlElement e3 = e1["Connections"];
                for (int i2 = 0; i2 < e3.ChildNodes.Count; i2++)
                {
                    XmlNode node2 = e3.ChildNodes[i2];
                    connection = new RBConnection(node2);



                    connections.Add(connection);
                }

                for (int i3 = 0; i3 < connections.Count; i3++)
                {
                    connection = connections[i3] as RBConnection;
                    
                    //ground
                    connection.ground = connections[i3].ground;

                    //background
                    connection.background = connections[i3].background;

                }




                return true;
            }







        }







    }
}
