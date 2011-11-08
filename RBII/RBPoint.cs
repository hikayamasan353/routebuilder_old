using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace RouteBuilder
{
    public class RBPoint
    {
        
        public Double_Point point;
        public double height; //point height
        public long id; //point ID
        public bool secondary;
        public bool turned;

        public RBPoint(Double_Point p, double h, bool _sec)
        {
            this.point = p;
            this.height = h;
            this.id = 0;
        }

        public RBPoint(RBPoint p)
        {
            point = p.point;
            height = p.height;
            id = 0;
            secondary = p.secondary;
        }

        public RBPoint Create_from_comma_string(string s)
        {
            return null;
        }

        public RBPoint(XmlNode node)
        {
            this.id = (long)Tools.Xml.GetDouble(node["id"]);
            this.point.x = Tools.Xml.GetDouble(node["x"]);
            this.point.y = Tools.Xml.GetDouble(node["y"]);
            this.height = Tools.Xml.GetDouble(node["height"]);
            this.secondary = Convert.ToBoolean((int)Tools.Xml.GetDouble(node["secondary"]));
        }

        
    }
}
