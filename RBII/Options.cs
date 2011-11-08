using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace RouteBuilder
{
    public partial class Options : Form
    {
        public string BVE_Directory;




        public Options()
        {
            InitializeComponent();
        }

        private void btn_browse_Click(object sender, EventArgs e)
        {
            BVE_Dir_Dialog.ShowDialog();
        }

        private void BVE_Dir_Dialog_HelpRequest(object sender, EventArgs e)
        {
            BVE_Dir_Dialog.SelectedPath = BVE_Directory;
        }
    }
}
