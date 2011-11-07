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
        }




        // system
        internal enum Platform { Windows, Linux, Mac }
        internal static Platform CurrentPlatform = Platform.Windows;
        internal static bool CurrentlyRunOnMono = false;
        internal static FileSystem FileSystem = null;
        internal enum ProgramType { OpenBve, ObjectViewer, RouteViewer, Other }
        internal const ProgramType CurrentProgramType = ProgramType.RouteViewer;

        // members
        private static bool Quit = false;
        private static int LastTicks = int.MaxValue;
        internal static bool CpuReducedMode = false;
        internal static bool CpuAutomaticMode = true;
        private static int ReducedModeEnteringTime = 0;
        private static string CurrentRoute = null;
        internal static bool CurrentlyLoading = false;
        internal static int CurrentStation = -1;
        internal static bool JumpToPositionEnabled = false;
        internal static string JumpToPositionValue = "";

        // keys
        private static bool ShiftPressed = false;
        private static bool ControlPressed = false;
        private static bool AltPressed = false;







        private void workspace_Paint(object sender, PaintEventArgs e)
        {
            //InitWorkspace();
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





    }
}
