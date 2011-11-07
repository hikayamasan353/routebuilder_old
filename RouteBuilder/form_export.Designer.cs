namespace RouteBuilder
{
    partial class form_export
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.label1 = new System.Windows.Forms.Label();
            this.format_select = new System.Windows.Forms.ComboBox();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.button1 = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label10 = new System.Windows.Forms.Label();
            this.subdir_box = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.stops_box = new System.Windows.Forms.CheckedListBox();
            this.label8 = new System.Windows.Forms.Label();
            this.dest_select_box = new System.Windows.Forms.ComboBox();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.start_select_box = new System.Windows.Forms.ComboBox();
            this.routedef_delete_button = new System.Windows.Forms.Button();
            this.routedef_add_button = new System.Windows.Forms.Button();
            this.multiple_routedefs_box = new System.Windows.Forms.CheckedListBox();
            this.label5 = new System.Windows.Forms.Label();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.train_box = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.timetable_box = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripProgressBar1 = new System.Windows.Forms.ToolStripProgressBar();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // tabControl1
            // 
            this.tabControl1.Appearance = System.Windows.Forms.TabAppearance.Buttons;
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Location = new System.Drawing.Point(196, 12);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(362, 385);
            this.tabControl1.TabIndex = 1;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Controls.Add(this.format_select);
            this.tabPage1.Location = new System.Drawing.Point(4, 25);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(354, 356);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "tabPage1";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(6, 12);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(140, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Select route format to export";
            // 
            // format_select
            // 
            this.format_select.FormattingEnabled = true;
            this.format_select.Items.AddRange(new object[] {
            "CSV",
            "RW"});
            this.format_select.Location = new System.Drawing.Point(6, 28);
            this.format_select.Name = "format_select";
            this.format_select.Size = new System.Drawing.Size(142, 21);
            this.format_select.TabIndex = 0;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.button1);
            this.tabPage2.Controls.Add(this.textBox1);
            this.tabPage2.Controls.Add(this.label10);
            this.tabPage2.Controls.Add(this.subdir_box);
            this.tabPage2.Controls.Add(this.label9);
            this.tabPage2.Controls.Add(this.stops_box);
            this.tabPage2.Controls.Add(this.label8);
            this.tabPage2.Controls.Add(this.dest_select_box);
            this.tabPage2.Controls.Add(this.label7);
            this.tabPage2.Controls.Add(this.label6);
            this.tabPage2.Controls.Add(this.start_select_box);
            this.tabPage2.Controls.Add(this.routedef_delete_button);
            this.tabPage2.Controls.Add(this.routedef_add_button);
            this.tabPage2.Controls.Add(this.multiple_routedefs_box);
            this.tabPage2.Controls.Add(this.label5);
            this.tabPage2.Controls.Add(this.comboBox1);
            this.tabPage2.Controls.Add(this.label4);
            this.tabPage2.Controls.Add(this.train_box);
            this.tabPage2.Controls.Add(this.label3);
            this.tabPage2.Controls.Add(this.timetable_box);
            this.tabPage2.Controls.Add(this.label2);
            this.tabPage2.Location = new System.Drawing.Point(4, 25);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(354, 356);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "tabPage2";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(185, 299);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(159, 51);
            this.button1.TabIndex = 20;
            this.button1.Text = "EXPORT";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(185, 272);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(159, 20);
            this.textBox1.TabIndex = 19;
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(182, 256);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(147, 13);
            this.label10.TabIndex = 18;
            this.label10.Text = "Route filename without format";
            // 
            // subdir_box
            // 
            this.subdir_box.Location = new System.Drawing.Point(9, 273);
            this.subdir_box.Name = "subdir_box";
            this.subdir_box.Size = new System.Drawing.Size(167, 20);
            this.subdir_box.TabIndex = 17;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(6, 257);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(66, 13);
            this.label9.TabIndex = 16;
            this.label9.Text = "Subdirectory";
            // 
            // stops_box
            // 
            this.stops_box.FormattingEnabled = true;
            this.stops_box.Location = new System.Drawing.Point(185, 172);
            this.stops_box.Name = "stops_box";
            this.stops_box.Size = new System.Drawing.Size(159, 79);
            this.stops_box.TabIndex = 15;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(182, 156);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(34, 13);
            this.label8.TabIndex = 14;
            this.label8.Text = "Stops";
            // 
            // dest_select_box
            // 
            this.dest_select_box.FormattingEnabled = true;
            this.dest_select_box.Location = new System.Drawing.Point(9, 168);
            this.dest_select_box.Name = "dest_select_box";
            this.dest_select_box.Size = new System.Drawing.Size(167, 21);
            this.dest_select_box.TabIndex = 13;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(6, 152);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(60, 13);
            this.label7.TabIndex = 12;
            this.label7.Text = "Destination";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(6, 112);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(63, 13);
            this.label6.TabIndex = 11;
            this.label6.Text = "Start station";
            // 
            // start_select_box
            // 
            this.start_select_box.FormattingEnabled = true;
            this.start_select_box.Location = new System.Drawing.Point(9, 128);
            this.start_select_box.Name = "start_select_box";
            this.start_select_box.Size = new System.Drawing.Size(167, 21);
            this.start_select_box.TabIndex = 10;
            // 
            // routedef_delete_button
            // 
            this.routedef_delete_button.Location = new System.Drawing.Point(90, 86);
            this.routedef_delete_button.Name = "routedef_delete_button";
            this.routedef_delete_button.Size = new System.Drawing.Size(86, 23);
            this.routedef_delete_button.TabIndex = 9;
            this.routedef_delete_button.Text = "Delete";
            this.routedef_delete_button.UseVisualStyleBackColor = true;
            // 
            // routedef_add_button
            // 
            this.routedef_add_button.Location = new System.Drawing.Point(9, 86);
            this.routedef_add_button.Name = "routedef_add_button";
            this.routedef_add_button.Size = new System.Drawing.Size(80, 23);
            this.routedef_add_button.TabIndex = 8;
            this.routedef_add_button.Text = "Add";
            this.routedef_add_button.UseVisualStyleBackColor = true;
            // 
            // multiple_routedefs_box
            // 
            this.multiple_routedefs_box.FormattingEnabled = true;
            this.multiple_routedefs_box.Location = new System.Drawing.Point(185, 59);
            this.multiple_routedefs_box.Name = "multiple_routedefs_box";
            this.multiple_routedefs_box.Size = new System.Drawing.Size(159, 94);
            this.multiple_routedefs_box.TabIndex = 7;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(182, 43);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(127, 13);
            this.label5.TabIndex = 6;
            this.label5.Text = "Multiple Route Definitions";
            // 
            // comboBox1
            // 
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(9, 59);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(167, 21);
            this.comboBox1.TabIndex = 5;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(6, 43);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(83, 13);
            this.label4.TabIndex = 4;
            this.label4.Text = "Route Definition";
            // 
            // train_box
            // 
            this.train_box.FormattingEnabled = true;
            this.train_box.Location = new System.Drawing.Point(185, 19);
            this.train_box.Name = "train_box";
            this.train_box.Size = new System.Drawing.Size(163, 21);
            this.train_box.TabIndex = 3;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(182, 3);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(31, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "Train";
            // 
            // timetable_box
            // 
            this.timetable_box.FormattingEnabled = true;
            this.timetable_box.Location = new System.Drawing.Point(9, 19);
            this.timetable_box.Name = "timetable_box";
            this.timetable_box.Size = new System.Drawing.Size(167, 21);
            this.timetable_box.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 3);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 13);
            this.label2.TabIndex = 0;
            this.label2.Text = "Timetable";
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabel1,
            this.toolStripProgressBar1});
            this.statusStrip1.Location = new System.Drawing.Point(0, 399);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(562, 22);
            this.statusStrip1.TabIndex = 2;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(25, 17);
            this.toolStripStatusLabel1.Text = "Idle";
            // 
            // toolStripProgressBar1
            // 
            this.toolStripProgressBar1.Name = "toolStripProgressBar1";
            this.toolStripProgressBar1.Size = new System.Drawing.Size(100, 16);
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::RouteBuilder.Properties.Resources.rb15;
            this.pictureBox1.Location = new System.Drawing.Point(12, 12);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(178, 335);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            // 
            // form_export
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(562, 421);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.pictureBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.Name = "form_export";
            this.Text = "Export project";
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox format_select;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox train_box;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox timetable_box;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox dest_select_box;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.ComboBox start_select_box;
        private System.Windows.Forms.Button routedef_delete_button;
        private System.Windows.Forms.Button routedef_add_button;
        private System.Windows.Forms.CheckedListBox multiple_routedefs_box;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.TextBox subdir_box;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.CheckedListBox stops_box;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
        private System.Windows.Forms.ToolStripProgressBar toolStripProgressBar1;
    }
}