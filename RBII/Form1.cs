using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Tao.OpenGl;
using Tao.Sdl;
using OpenBve;

namespace RouteBuilder
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            simpleOpenGlControl1.InitializeContexts();
        }



        private void aboutRouteBuilderIIToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AboutBox1 box=new AboutBox1();
            box.Show();
        }

        private void tsbtn_open_Click(object sender, EventArgs e)
        {
            open_file.ShowDialog();
        }

        private void tsbtn_save_Click(object sender, EventArgs e)
        {
            save_file.ShowDialog();
        }

        private void simpleOpenGlControl1_Load(object sender, EventArgs e)
        {

        }





    }
}
