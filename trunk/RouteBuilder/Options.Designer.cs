namespace RouteBuilder
{
    partial class Options
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
            this.btn_ok = new System.Windows.Forms.Button();
            this.btn_cancel = new System.Windows.Forms.Button();
            this.tab_general = new System.Windows.Forms.TabPage();
            this.tab_editor = new System.Windows.Forms.TabPage();
            this.tab_export = new System.Windows.Forms.TabPage();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.btn_browse = new System.Windows.Forms.Button();
            this.BVE_Dir_Dialog = new System.Windows.Forms.FolderBrowserDialog();
            this.tabControl1.SuspendLayout();
            this.tab_general.SuspendLayout();
            this.SuspendLayout();
            // 
            // tabControl1
            // 
            this.tabControl1.Appearance = System.Windows.Forms.TabAppearance.Buttons;
            this.tabControl1.Controls.Add(this.tab_general);
            this.tabControl1.Controls.Add(this.tab_editor);
            this.tabControl1.Controls.Add(this.tab_export);
            this.tabControl1.Location = new System.Drawing.Point(12, 12);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(391, 250);
            this.tabControl1.TabIndex = 0;
            // 
            // btn_ok
            // 
            this.btn_ok.Location = new System.Drawing.Point(324, 268);
            this.btn_ok.Name = "btn_ok";
            this.btn_ok.Size = new System.Drawing.Size(75, 23);
            this.btn_ok.TabIndex = 1;
            this.btn_ok.Text = "OK";
            this.btn_ok.UseVisualStyleBackColor = true;
            // 
            // btn_cancel
            // 
            this.btn_cancel.Location = new System.Drawing.Point(243, 268);
            this.btn_cancel.Name = "btn_cancel";
            this.btn_cancel.Size = new System.Drawing.Size(75, 23);
            this.btn_cancel.TabIndex = 2;
            this.btn_cancel.Text = "Cancel";
            this.btn_cancel.UseVisualStyleBackColor = true;
            // 
            // tab_general
            // 
            this.tab_general.Controls.Add(this.btn_browse);
            this.tab_general.Controls.Add(this.label1);
            this.tab_general.Controls.Add(this.textBox1);
            this.tab_general.Location = new System.Drawing.Point(4, 25);
            this.tab_general.Name = "tab_general";
            this.tab_general.Size = new System.Drawing.Size(383, 221);
            this.tab_general.TabIndex = 0;
            this.tab_general.Text = "General";
            this.tab_general.UseVisualStyleBackColor = true;
            // 
            // tab_editor
            // 
            this.tab_editor.Location = new System.Drawing.Point(4, 25);
            this.tab_editor.Name = "tab_editor";
            this.tab_editor.Size = new System.Drawing.Size(383, 221);
            this.tab_editor.TabIndex = 1;
            this.tab_editor.Text = "Editor";
            this.tab_editor.UseVisualStyleBackColor = true;
            // 
            // tab_export
            // 
            this.tab_export.Location = new System.Drawing.Point(4, 25);
            this.tab_export.Name = "tab_export";
            this.tab_export.Size = new System.Drawing.Size(383, 221);
            this.tab_export.TabIndex = 2;
            this.tab_export.Text = "Export";
            this.tab_export.UseVisualStyleBackColor = true;
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(6, 26);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(179, 20);
            this.textBox1.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(3, 10);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(71, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "BVE directory";
            // 
            // btn_browse
            // 
            this.btn_browse.Location = new System.Drawing.Point(191, 26);
            this.btn_browse.Name = "btn_browse";
            this.btn_browse.Size = new System.Drawing.Size(75, 20);
            this.btn_browse.TabIndex = 2;
            this.btn_browse.Text = "Browse...";
            this.btn_browse.UseVisualStyleBackColor = true;
            this.btn_browse.Click += new System.EventHandler(this.btn_browse_Click);
            // 
            // BVE_Dir_Dialog
            // 
            this.BVE_Dir_Dialog.HelpRequest += new System.EventHandler(this.BVE_Dir_Dialog_HelpRequest);
            // 
            // Options
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(415, 303);
            this.Controls.Add(this.btn_cancel);
            this.Controls.Add(this.btn_ok);
            this.Controls.Add(this.tabControl1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.Name = "Options";
            this.Text = "Options";
            this.tabControl1.ResumeLayout(false);
            this.tab_general.ResumeLayout(false);
            this.tab_general.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tab_general;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TabPage tab_editor;
        private System.Windows.Forms.TabPage tab_export;
        private System.Windows.Forms.Button btn_ok;
        private System.Windows.Forms.Button btn_cancel;
        private System.Windows.Forms.Button btn_browse;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.FolderBrowserDialog BVE_Dir_Dialog;
    }
}