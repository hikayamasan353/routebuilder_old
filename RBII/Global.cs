using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Xml;

using System.Drawing;

namespace RouteBuilder
{


    public class Double_Point
    {
        public double x;
        public double y;

        public Double_Point(double x, double y)
        {
            this.x = x;
            this.y = y;
        }
    }

    public abstract class Double_Rect
    {
        double left;
        double top;
        double right;
        double bottom;

        public Double_Rect(double left, double top, double right, double bottom)
        {
            this.left = left;
            this.top = top;
            this.right = right;
            this.bottom = bottom;
        }

    }

    public abstract class Double_Cube
    {
        public double x1;
        public double y1;
        public double z1;
        public double x2;
        public double y2;
        public double z2;
    }


    public class Tools
    {


        public class Xml
        {
            public static XmlDocument document;

            public static XmlElement AddElement(XmlNode parent, string name)
            {
                return AddElement(parent, name, "");
            }

            public static XmlElement AddElement(XmlNode parent, string name, double value)
            {
                return AddElement(parent, name, value.ToString(double_format));
            }

            public static XmlElement AddElement(XmlNode parent, string name, string text)
            {
                XmlElement newChild = document.CreateElement(name);
                if ((text != "") && (text != null))
                {
                    newChild.InnerText = text;
                }
                parent.AppendChild(newChild);
                return newChild;
            }

            public static double GetDouble(XmlNode element)
            {
                try
                {
                    return double.Parse(element.InnerText, double_format);
                }
                catch
                {
                    return 0.0;
                }
            }

            public static IFormatProvider double_format
            {
                get
                {
                    NumberFormatInfo info = new NumberFormatInfo();
                    info.NumberDecimalSeparator = ".";
                    return info;
                }
            }
        }



        public void Quick_Sort(double[] a, int ilo, int ihi)
        {
            int lo;
            int hi;
            double mid;
            double t;

            lo = ilo;
            hi = ihi;
            mid = a[(lo + hi) / 2];
            while (lo < hi)
            {
                while (a[lo] < mid)
                {
                    lo += 1;
                }
                while (a[hi] > mid)
                {
                    hi -= 1;
                }
                if (lo <= hi)
                {
                    t = a[lo];
                    a[lo] = a[hi];
                    a[hi] = t;
                    lo += 1;
                    hi -= 1;
                }
            }
            if (hi > ilo)
            {
                Quick_Sort(a, ilo, hi);
            }
            else if (lo < ihi)
            {
                Quick_Sort(a, lo, ihi);
            }

        }

        public void Quick_Sort(double[] a)
        {
            
        }

        /*
         * Commented to getting found the code

        public char GetToken(char sourcestr, char stringsep, char token, int tokennum)
        {
            var tokensfound = 0;
            char sourcepos;
            char targetpos;
            bool escaped;
            escaped = false;
            
            tokensfound += 1;
            sourcepos = sourcestr;
            targetpos = token;
            while ((tokensfound <= tokennum))
            {
                if (sourcepos == '"')
                {
                    escaped = !escaped;
                }




                if (tokensfound == tokennum)
                {
                    targetpos = sourcepos;
                    targetpos += 1;
                }
                sourcepos += 1;
            }
            targetpos = "";
            return token;
        }

        public string StrGetToken(string sourcestr, string stringsep, int tokennum)
        {
            return null;
        }

         */

        public double Triangle(Double_Point a, Double_Point p1, Double_Point p2)
        {
            return angle(a, p2) - angle(a, p1);
        }


        public double Distance(Double_Point p1, Double_Point p2)
        {
            return Math.Sqrt(Math.Pow(p1.x - p2.x, 2) + Math.Pow(p1.y - p2.y, 2));
        }


        public double angle(Double_Point p1, Double_Point p2)
        {
            double dx = p2.x - p1.x;
            double dy = p2.y - p1.y;
            if (dx == 0)
            {
                if (dy > 0)
                {
                    return 90;
                }
                else
                {
                    return -90;
                }
            }
            else
            {
                return Math.Round(180 * Math.Atan2(dy, dx) / Math.PI);
            }
        }


        public static Double_Point DoublePoint(double x, double y)
        {
            return new Double_Point(x, y);
        }


        public bool Is_point_in_segment(Double_Point p1, Double_Point p2, Double_Point p3, double l, double a, double b)
        {
            double r;
            double x1;
            double x2;
            double x3;
            double y1;
            double y2;
            double y3;
            double xv;
            double yv;

            
            r = Distance(p1, p2);

            ////Helpers
            x1 = p1.x;
            x2 = p2.x;
            x3 = p3.x;
            y1 = p1.y;
            y2 = p2.y;
            y3 = p3.y;

            xv = (y2 - y1) * 1 / r;
            yv = -(x2 - x1) * 1 / r;
            if (xv == 0)
            {
                xv = 0.00001;
            }
            if (yv == 0)
            {
                yv = 0.00001;
            }

            a = (yv * (x3 - x1) - xv * (y3 - y1)) / (yv * (x2 - x1) - xv * (y2 - y1));
            b = (x3 - x1 - a * (x2 - x1)) / xv;

            return (a >= 0) & (a <= 1.01) & (b >= -1) & (b <= 1);

        }
            






    }





}
