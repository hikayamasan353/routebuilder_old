unit SWITCH1;

interface


var laenge, xdev1, xdev2, winkel1, winkel2, radius1, radius2:real;
var yg1, yg2, yf1, yf2, mg, mf, ag, sx, sy, flg, me, ma:real;
var gleisr1: array[0..21,1..2,1..2] of real;
var gleisr2: array[0..21,1..2,1..2] of real;
var gleisl1: array[0..21,1..2,1..2] of real;
var gleisl2: array[0..21,1..2,1..2] of real;
var schiener1: array[1..21,1..2] of real;
var schiener2: array[1..21,1..2] of real;
var schienel1: array[1..21,1..2] of real;
var schienel2: array[1..21,1..2] of real;
var schotterr1:array[0..20,1..2] of real;
var schotterl1:array[0..20,1..2] of real;
var radr: array[1..10,1..2,1..2] of real;
var radl: array[1..10,1..2,1..2] of real;
var radlend: array[1..8,1..2] of real;
var schwellen:array[0..20,1..3] of real;
var punkt: array[1..8,1..2] of real;
var fluegel: array[1..8,1..2] of real;
var oberraufh, oberlaufh: array[1..20] of real;
var oberfahr, obertrag:real;
var oberrjn, oberljn:char;
var p:integer; {verschieben auf 25m}
var sprache:char;
var filename:string;
var textur1,textur2,textur3: string; // schotter,schwellen,weiche1b  (u)

radlx, radly, radlenker:real;
var i,j,k,l,a,b,herz:integer;
var f:text;
var name:string;
var richtung,radlenk,janein:char;

procedure schnittpunkt(yg1,yg2,yf1,yf2:real);
procedure berechnen;
procedure schreiben1;
procedure schreiben2;

implementation

procedure schnittpunkt(yg1,yg2,yf1,yf2:real);
begin
mg:=(yg2-yg1)/5;
mf:=(yf2-yf1)/5;
sx:=(yf1-yg1)/(mg-mf);
sy:=(mg*yf1-mf*yg1)/(mg-mf);
end;



procedure berechnen;
var i,j:integer;
begin


{Verschieben auf 25m}

p:=0;
if me<>0 then
  i:=round(laenge+me)
  else
  i:=round(laenge);

while i>25 do
 begin
 i:=i-5;
 p:=p-5;
 end;








  
winkel1:=(arctan(xdev1/laenge)*180/pi);
winkel2:=(arctan(xdev2/laenge)*180/pi);
if xdev1<>0 then
radius1:=laenge*360/(winkel1*4*pi)
else radius1:=999999;
if xdev2<>0 then
radius2:=laenge*360/(winkel2*4*pi)
else radius2:=999999;


for i:=0 to 50 do
  begin
  gleisr1[i,1,1]:=999;
  gleisr1[i,2,1]:=999;
  gleisl2[i,1,1]:=999;
  gleisl2[i,2,1]:=999;
  end;

for i:=0 to round(laenge/5) do
  begin
  gleisr1[i,1,2]:=(sin(winkel1*i/(laenge/5)*pi/180)/cos(winkel1*i/(laenge/5)*pi/180))*i*5+0.8;
  gleisr1[i,2,2]:=gleisr1[i,1,2]-0.08;
  gleisr2[i,1,2]:=gleisr1[i,2,2]-1.44;
  gleisr2[i,2,2]:=gleisr2[i,1,2]-0.08;
  {for j:=1 to 2 do
  writeln;}
  end;

for i:=0 to round(laenge/5) do
  begin
  gleisl1[i,1,2]:=(sin(winkel2*i/(laenge/5)*pi/180)/cos(winkel2*i/(laenge/5)*pi/180))*i*5+0.8;
  gleisl1[i,2,2]:=gleisl1[i,1,2]-0.08;
  gleisl2[i,1,2]:=gleisl1[i,2,2]-1.44;
  gleisl2[i,2,2]:=gleisl2[i,1,2]-0.08;
 { for j:=1 to 2 do
  writeln;  }
  end;

j:=0;
for i:=0 to round(laenge/5) do
  begin
  gleisr1[i,1,1]:=j;
  gleisr1[i,2,1]:=j;
  gleisr2[i,1,1]:=j;
  gleisr2[i,2,1]:=j;
  gleisl1[i,1,1]:=j;
  gleisl1[i,2,1]:=j;
  gleisl2[i,1,1]:=j;
  gleisl2[i,2,1]:=j;
  j:=j+5;
end;

  {Schotterbett}
for i:=0 to round(laenge/5) do
  begin
  schotterr1[i,1]:=gleisl1[i,1,2]+0.55;
  schotterr1[i,2]:=gleisl1[i,1,2]+2;
  schotterl1[i,1]:=gleisr2[i,2,2]-2;
  schotterl1[i,2]:=gleisr2[i,2,2]-0.55;
  end;

{Schwellen}
for i:=0 to round(laenge/5) do
  begin
  schwellen[i,1]:=schotterl1[i,2];
  schwellen[i,3]:=schotterr1[i,1];
  schwellen[i,2]:=(schotterr1[i,1]+schotterl1[i,2])/2;
  end;


{Weichenzungen}
if richtung='r' then
  begin
  gleisr1[2,1,2]:=gleisr1[2,1,2]-0.05;
  gleisr1[2,2,2]:=gleisr1[2,2,2]-0.05;
  gleisr1[1,1,2]:=gleisr1[1,1,2]-0.1;
  gleisr1[1,2,2]:=gleisr1[1,2,2]-0.1;
  gleisr1[0,1,2]:=gleisr1[0,1,2]-0.19;
  gleisr1[0,2,2]:=gleisr1[0,2,2]-0.15;
  end
  else
  begin
  gleisl2[2,1,2]:=gleisl2[2,1,2]+0.05;
  gleisl2[2,2,2]:=gleisl2[2,2,2]+0.05;
  gleisl2[1,1,2]:=gleisl2[1,1,2]+0.1;
  gleisl2[1,2,2]:=gleisl2[1,2,2]+0.1;
  gleisl2[0,1,2]:=gleisl2[0,1,2]+0.15;
  gleisl2[0,2,2]:=gleisl2[0,2,2]+0.19;
  end;

{HerzstÅckbereich}
i:=0;
while gleisr1[i,2,2]>gleisl2[i,2,2] do
i:=i+1;

schnittpunkt(gleisl2[i-1,2,2],gleisl2[i,2,2],gleisr1[i-1,2,2]-0.08,gleisr1[i,2,2]-0.08);
punkt[1,1]:=sx+(i-1)*5;
punkt[1,2]:=sy;
schnittpunkt(gleisl2[i-1,2,2],gleisl2[i,2,2],gleisr1[i-1,2,2],gleisr1[i,2,2]);
punkt[2,1]:=sx+(i-1)*5;;
punkt[2,2]:=sy;
schnittpunkt(gleisl2[i-1,1,2],gleisl2[i,1,2],gleisr1[i-1,2,2],gleisr1[i,2,2]);
punkt[3,1]:=sx+(i-1)*5;;
punkt[3,2]:=sy;
schnittpunkt(gleisl2[i-1,1,2],gleisl2[i,1,2],gleisr1[i-1,2,2]-0.08,gleisr1[i,2,2]-0.08);
punkt[4,1]:=sx+(i-1)*5;;
punkt[4,2]:=sy;

schnittpunkt(gleisl2[i-1,1,2],gleisl2[i,1,2],gleisr1[i-1,2,2],gleisr1[i,2,2]);
punkt[5,1]:=sx+(i-1)*5;
punkt[5,2]:=sy;
schnittpunkt(gleisl2[i-1,1,2],gleisl2[i,1,2],gleisr1[i-1,1,2],gleisr1[i,1,2]);
punkt[6,1]:=sx+(i-1)*5;;
punkt[6,2]:=sy;
schnittpunkt(gleisl2[i-1,1,2]+0.08,gleisl2[i,1,2]+0.08,gleisr1[i-1,1,2],gleisr1[i,1,2]);
punkt[7,1]:=sx+(i-1)*5;;
punkt[7,2]:=sy;
schnittpunkt(gleisl2[i-1,1,2]+0.08,gleisl2[i,1,2]+0.08,gleisr1[i-1,2,2],gleisr1[i,2,2]);
punkt[8,1]:=sx+(i-1)*5;;
punkt[8,2]:=sy;

{FlÅgelschienen}
schnittpunkt(gleisl2[i-1,2,2],gleisl2[i,2,2],gleisr1[i-1,2,2]-0.08,gleisr1[i,2,2]-0.08);
fluegel[3,1]:=sx+(i-1)*5;
fluegel[3,2]:=sy;

schnittpunkt(gleisl2[i-1,2,2],gleisl2[i,2,2],gleisr1[i-1,2,2]-0.16,gleisr1[i,2,2]-0.16);
fluegel[4,1]:=sx+(i-1)*5-0.1;
fluegel[4,2]:=sy+0.02;   

flg:=laenge/25;
mg:=(gleisr1[i,2,2]-gleisr1[i-1,2,2])/5;
ag:=gleisr1[i-1,2,2];
fluegel[2,1]:=punkt[1,1]+flg;
fluegel[2,2]:=mg*(punkt[1,1]+flg-gleisr1[i-1,2,1])+ag-0.08;

fluegel[1,1]:=fluegel[2,1];
fluegel[1,2]:=fluegel[2,2]-0.08;

schnittpunkt(gleisl2[i-1,1,2]+0.08,gleisl2[i,1,2]+0.08,gleisr1[i-1,1,2],gleisr1[i,1,2]);
fluegel[7,1]:=sx+(i-1)*5;
fluegel[7,2]:=sy;

schnittpunkt(gleisl2[i-1,1,2]+0.16,gleisl2[i,1,2]+0.16,gleisr1[i-1,1,2],gleisr1[i,1,2]);
fluegel[8,1]:=sx+(i-1)*5-0.1;                                                        
fluegel[8,2]:=sy-0.02;   

flg:=laenge/25;
mg:=(gleisl2[i,1,2]-gleisl2[i-1,1,2])/5;
ag:=gleisl2[i-1,1,2];
fluegel[6,1]:=punkt[7,1]+flg;
fluegel[6,2]:=mg*(punkt[7,1]+flg-gleisl2[i-1,1,1])+ag+0.08;

fluegel[5,1]:=fluegel[6,1];
fluegel[5,2]:=fluegel[6,2]+0.08;


for j:=round(laenge/5) downto i do
  begin
  gleisr1[j+2,1,1]:=gleisr1[j,1,1];
  gleisr1[j+2,1,2]:=gleisr1[j,1,2];
  gleisr1[j+2,2,1]:=gleisr1[j,2,1];
  gleisr1[j+2,2,2]:=gleisr1[j,2,2];

  gleisl2[j+2,1,1]:=gleisl2[j,1,1];
  gleisl2[j+2,1,2]:=gleisl2[j,1,2];
  gleisl2[j+2,2,1]:=gleisl2[j,2,1];
  gleisl2[j+2,2,2]:=gleisl2[j,2,2];
  end;

gleisr1[i,1,1]:=punkt[7,1];
gleisr1[i,1,2]:=punkt[7,2];
gleisr1[i,2,1]:=punkt[8,1];
gleisr1[i,2,2]:=punkt[8,2];

gleisr1[i+1,1,1]:=punkt[6,1];
gleisr1[i+1,1,2]:=punkt[6,2];
gleisr1[i+1,2,1]:=punkt[5,1];
gleisr1[i+1,2,2]:=punkt[5,2];

gleisl2[i,1,1]:=punkt[4,1];
gleisl2[i,1,2]:=punkt[4,2];
gleisl2[i,2,1]:=punkt[1,1];
gleisl2[i,2,2]:=punkt[1,2];

gleisl2[i+1,1,1]:=punkt[3,1];
gleisl2[i+1,1,2]:=punkt[3,2];
gleisl2[i+1,2,1]:=punkt[2,1];
gleisl2[i+1,2,2]:=punkt[2,2];


{3D-Schienen}

for i:=0 to round(laenge/5+herz) do
  begin
  schiener1[i,1]:=gleisr1[i,2,1];
  schiener1[i,2]:=gleisr1[i,2,2]+0.04;
  end;

i:=round(laenge/5)+herz;
while frac(gleisr1[i,2,1])=0 do
i:=i-1;
schiener1[i,1]:=punkt[2,1];
schiener1[i,2]:=punkt[2,2]+0.04;

for i:=0 to round(laenge/5+herz) do
  begin
  schienel2[i,1]:=gleisl2[i,1,1];
  schienel2[i,2]:=gleisl2[i,1,2]-0.04;
  end;

i:=round(laenge/5)+herz;
while frac(gleisl2[i,2,1])=0 do
i:=i-1;
schienel2[i,1]:=punkt[6,1];
schienel2[i,2]:=punkt[6,2]-0.04;

for i:=0 to round(laenge/5) do
  begin
  schiener2[i,1]:=gleisr2[i,1,1];
  schiener2[i,2]:=gleisr2[i,1,2]-0.04;
  schienel1[i,1]:=gleisl1[i,1,1];
  schienel1[i,2]:=gleisl1[i,1,2]-0.04;
  end;

{Radlenker}
if (radlenk='j') or (radlenk='y') then
begin
{
radlenker:=radlenker-(2*laenge/50);
}
radlenker:=1.5+laenge/25;
{Radlenker links}

for i:=1 to 10 do
  begin
  radl[i,1,1]:=999;
  radl[i,1,2]:=999;
  radl[i,2,1]:=999;
  radl[i,2,2]:=999;
  end;

radl[1,1,1]:=fluegel[1,1]-((fluegel[1,1]-fluegel[4,1])/2);
i:=0;
while radl[1,1,1]>gleisr2[i,1,1] do
i:=i+1;

mg:=(gleisr2[i,1,2]-gleisr2[i-1,1,2])/5;
ag:=gleisr2[i-1,1,2];
radl[1,1,2]:=mg*(radl[1,1,1]-gleisr2[i-1,1,1])+ag+0.08;
radl[1,2,1]:=radl[1,1,1];
radl[1,2,2]:=radl[1,1,2]+0.08;

radlx:=radl[1,1,1]-radlenker;
i:=0;
while radlx>gleisr2[i,1,1] do
i:=i+1;
mg:=(gleisr2[i,1,2]-gleisr2[i-1,1,2])/5;
ag:=gleisr2[i-1,1,2];
radly:=mg*(radlx-gleisr2[i-1,1,1])+ag+0.08;

j:=1;
for i:=round(laenge/5) downto 0 do
  begin
  while (radl[j,1,1]>i*5) and (radlx<i*5) do
    begin
    j:=j+1;
    radl[j,1,1]:=i*5;
    radl[j,1,2]:=gleisr2[i,1,2]+0.08;
    radl[j,2,1]:=i*5;
    radl[j,2,2]:=gleisr2[i,1,2]+0.16;
    end;
  end;

j:=j+1;
radl[j,1,1]:=radlx;
radl[j,1,2]:=radly;
radl[j,2,1]:=radlx;
radl[j,2,2]:=radly+0.08;

for i:=9 downto 1 do
  begin
  radl[i+1,1,1]:=radl[i,1,1];
  radl[i+1,1,2]:=radl[i,1,2];
  radl[i+1,2,1]:=radl[i,2,1];
  radl[i+1,2,2]:=radl[i,2,2];
  end;

radl[1,1,1]:=radl[2,1,1]+laenge/50;
i:=0;
while radl[1,1,1]>gleisr2[i,1,1] do
i:=i+1;

mg:=(gleisr2[i,1,2]-gleisr2[i-1,1,2])/5;
ag:=gleisr2[i-1,1,2];
radl[1,1,2]:=mg*(radl[1,1,1]-gleisr2[i-1,1,1])+ag+0.12;
radl[1,2,1]:=radl[1,1,1];
radl[1,2,2]:=radl[1,1,2]+0.04;

i:=1;
repeat;
i:=i+1;
until radl[i,1,1]=999;

radl[i,1,1]:=radl[i-1,1,1]-laenge/50;
j:=1;
while radl[i,1,1]>gleisr2[j,1,1] do
j:=j+1;
mg:=(gleisr2[j,1,2]-gleisr2[j-1,1,2])/5;
ag:=gleisr2[j-1,1,2];
radl[i,1,2]:=mg*(radl[i,1,1]-gleisr2[j-1,1,1])+ag+0.12;
radl[i,2,1]:=radl[i,1,1];
radl[i,2,2]:=radl[i,1,2]+0.04;

{Radlenker rechts}

for i:=1 to 10 do
  begin
  radr[i,1,1]:=999;
  radr[i,1,2]:=999;
  radr[i,2,1]:=999;
  radr[i,2,2]:=999;
  end;

radr[1,1,1]:=fluegel[5,1]-((fluegel[5,1]-fluegel[8,1])/2);
i:=0;
while radr[1,1,1]>gleisl1[i,1,1] do
i:=i+1;

mg:=(gleisl1[i,1,2]-gleisl1[i-1,1,2])/5;
ag:=gleisl1[i-1,1,2];
radr[1,1,2]:=mg*(radr[1,1,1]-gleisl1[i-1,1,1])+ag-0.16;
radr[1,2,1]:=radr[1,1,1];
radr[1,2,2]:=radr[1,1,2]-0.08;

radlx:=radr[1,1,1]-radlenker;
i:=0;
while radlx>gleisl1[i,1,1] do
i:=i+1;
mg:=(gleisl1[i,1,2]-gleisl1[i-1,1,2])/5;
ag:=gleisl1[i-1,1,2];
radly:=mg*(radlx-gleisl1[i-1,1,1])+ag-0.16;

j:=1;
for i:=round(laenge/5) downto 0 do
  begin
  while (radr[j,1,1]>i*5) and (radlx<i*5) do
    begin
    j:=j+1;
    radr[j,1,1]:=i*5;
    radr[j,1,2]:=gleisl1[i,1,2]-0.16;
    radr[j,2,1]:=i*5;
    radr[j,2,2]:=gleisl1[i,1,2]-0.24;
    end;
  end;

j:=j+1;
radr[j,1,1]:=radlx;
radr[j,1,2]:=radly;
radr[j,2,1]:=radlx;
radr[j,2,2]:=radly-0.08;

for i:=9 downto 1 do
  begin
  radr[i+1,1,1]:=radr[i,1,1];
  radr[i+1,1,2]:=radr[i,1,2];
  radr[i+1,2,1]:=radr[i,2,1];
  radr[i+1,2,2]:=radr[i,2,2];
  end;

radr[1,1,1]:=radr[2,1,1]+laenge/50;
i:=0;
while radr[1,1,1]>gleisl1[i,1,1] do
i:=i+1;

mg:=(gleisl1[i,1,2]-gleisl1[i-1,1,2])/5;
ag:=gleisl1[i-1,1,2];
radr[1,1,2]:=mg*(radr[1,1,1]-gleisl1[i-1,1,1])+ag-0.2;
radr[1,2,1]:=radr[1,1,1];
radr[1,2,2]:=radr[1,1,2]-0.04;

i:=1;
repeat;
i:=i+1;
until radr[i,1,1]=999;


radr[i,1,1]:=radr[i-1,1,1]-laenge/50;
j:=1;
while radr[i,1,1]>gleisl1[j,1,1] do
j:=j+1;
mg:=(gleisl1[j,1,2]-gleisl1[j-1,1,2])/5;
ag:=gleisl1[j-1,1,2];
radr[i,1,2]:=mg*(radr[i,1,1]-gleisl1[j-1,1,1])+ag-0.2;
radr[i,2,1]:=radr[i,1,1];
radr[i,2,2]:=radr[i,1,2]-0.04;
end;


end;
{Prozedurende}



procedure schreiben1;
var i:integer;
begin
assign(f,filename);
rewrite(f);

if sprache='d' then
  begin
  writeln(f,';Datei automatisch erstellt von SWITCH - (C) 2002 Ruediger Huelsmann');
  writeln(f,';RBASwitch (c) 2003 RouteBuilder Development Team and Ruediger Huelsmann');
  writeln(f);
  writeln(f,';Weichendaten:');
  writeln(f,';Laenge: ',round(laenge));
  writeln(f,';X-Abweichung rechts: ',xdev2:3:3);
  writeln(f,';X-Abweichung links: ',xdev1:3:3);
  write(f,';Abzweigradius rechts: ');
  if radius2<>999999 then
    writeln(f,radius2:3:3)
    else
    writeln(f,'unendlich (geradeaus)');
  write(f,';Abzweigradius links: ');
  if radius1<>999999 then
    writeln(f,radius1:3:3)
    else
    writeln(f,'unendlich (geradeaus)');
  writeln(f,';Winkel rechts: ',winkel2:3:3);
  writeln(f,';Winkel links: ',winkel1:3:3);
  writeln(f,';Richtung: ', richtung);
  write(f,';Radlenker: ');
  if radlenk='n' then
    writeln(f,'nein')
    else
    writeln(f,'ja');
  write(f,';Oberleitung rechts: ');
  if oberrjn='n' then
    writeln(f,'nein')
    else
    writeln(f,'ja');
  write(f,';Oberleitung links: ');
  if oberljn='n' then
    writeln(f,'nein')
    else
    writeln(f,'ja');
  if (oberrjn<>'n') or (oberljn<>'n') then
    begin
    writeln(f,';Hoehe Fahrdraht: ',oberfahr:3:3);
    writeln(f,';Hoehe Tragseil: ',obertrag:3:3);
    end;
  writeln(f);
  end

  else

  begin
  writeln(f,';File automatically generated by SWITCH - (C) 2002 Ruediger Huelsmann');
  writeln(f,';RBASwitch (c) 2003 RouteBuilder Development Team and Ruediger Huelsmann');
  writeln(f);
  writeln(f,';Switch data:');
  writeln(f,';Length: ',round(laenge));
  writeln(f,';X-offset right: ',xdev2:3:3);
  writeln(f,';X-offset left: ',xdev1:3:3);
  write(f,';Turnout radius right: ');
  if radius2<>999999 then
    writeln(f,radius2:3:3)
    else
    writeln(f,'infinite (straight)');
  write(f,';Turnout radius left: ');
  if radius1<>999999 then
    writeln(f,radius1:3:3)
    else
    writeln(f,'infinite (straight)');
  writeln(f,';Angle right: ', winkel2:3:3);
  writeln(f,';Angle left: ',winkel1:3:3);
  writeln(f,';Direction: ', richtung);
  write(f,';Guard rails: ');
  if radlenk='n' then
    writeln(f,'no')
    else
    writeln(f,'yes');
  write(f,';Overhead line right: ');
  if oberrjn='n' then
    writeln(f,'no')
    else
    writeln(f,'yes');
  write(f,';Overhead line left: ');
  if oberljn='n' then
    writeln(f,'no')
    else
    writeln(f,'yes');
  if (oberrjn<>'n') or (oberljn<>'n') then
    begin
    writeln(f,';Height of contact wire: ',oberfahr:3:3);
    writeln(f,';Height of carrying rope: ',obertrag:3:3);
    end;
  end;
  writeln(f);


if sprache='d' then
  writeln(f,';Linkes Gleis, rechte Schiene:')
  else
  writeln(f,';Left track, right rail:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5)+herz do
  begin
  writeln(f,'vertex ',gleisr1[i,1,2]:3:3,', 0, ',gleisr1[i,1,1]+p:3:3);
  writeln(f,'vertex ',gleisr1[i,2,2]:3:3,', 0, ',gleisr1[i,2,1]+p:3:3);
  end;
a:=0;
j:=0;
b:=0;
i := 0;
while i<round((laenge/5)-1)+herz do
  begin
  if (frac(gleisr1[i,1,1])<>0) and (j=0) then
    begin
    a:=a+2;
    j:=1;
    i:=i+1;
    end;
  if i=round(laenge/5-1) then b:=1;
  if (gleisr1[i+1,1,1]>gleisr1[i+2,1,1]) and (b=0) or (gleisr1[i+1,2,1]>gleisr1[i+2,2,1]) and (b=0) then
    begin
    writeln(f,'face ',a+5,',',a+4,',',a,',',a+1);
    b:=1;
    a:=a+2;
    i:=i+1;
    end
  else
    writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
  a:=a+2;
  i:=i+1;
  end;
writeln(f,'color 180,190,200');
writeln(f);

if sprache='d' then
  writeln(f,';Linkes Gleis, linke Schiene:')
  else
  writeln(f,';Left track, left rail:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'vertex ',gleisr2[i,1,2]:3:3,', 0, ',gleisr2[i,1,1]+p:3:3);
  writeln(f,'vertex ',gleisr2[i,2,2]:3:3,', 0, ',gleisr2[i,2,1]+p:3:3);
  end;
a:=0;
for i:=0 to round((laenge/5)-1)do
  begin
  writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
  a:=a+2;
  end;
writeln(f,'color 180,190,200');
writeln(f);

if sprache='d' then
  writeln(f,';Rechtes Gleis, rechte Schiene:')
  else
  writeln(f,';Right track, right rail:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'vertex ',gleisl1[i,1,2]:3:3,', 0, ',gleisl1[i,1,1]+p:3:3);
  writeln(f,'vertex ',gleisl1[i,2,2]:3:3,', 0, ',gleisl1[i,2,1]+p:3:3);
  end;
a:=0;
for i:=0 to round((laenge/5)-1)do
  begin
  writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
  a:=a+2;
  end;
writeln(f,'color 180,190,200');
writeln(f);

if sprache='d' then
  writeln(f,';Rechtes Gleis, linke Schiene:')
  else
  writeln(f,';Right track, left rail:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5)+herz do
  begin
  writeln(f,'vertex ',gleisl2[i,1,2]:3:3,', 0, ',gleisl2[i,1,1]+p:3:3);
  writeln(f,'vertex ',gleisl2[i,2,2]:3:3,', 0, ',gleisl2[i,2,1]+p:3:3);
  end;
a:=0;
j:=0;
b:=0;
i:=0;
while(i<round((laenge/5)-1)+herz) do
  begin
  if (frac(gleisl2[i,1,1])<>0) and (j=0) then
    begin
    a:=a+2;
    j:=1;
    i:=i+1;
    end;
  if i=round(laenge/5-1) then b:=1;
  if (gleisl2[i+1,1,1]>gleisl2[i+2,1,1]) and (b=0) or (gleisl2[i+1,2,1]>gleisl2[i+2,2,1]) and (b=0) then
    begin
    writeln(f,'face ',a+5,',',a+4,',',a,',',a+1);
    b:=1;
    a:=a+2;
    i:=i+1;
    end
  else
    writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
  a:=a+2;
  i:=i+1;
  end;
writeln(f,'color 180,190,200');
writeln(f);

if sprache='d' then
  writeln(f,';Schotterbett rechts:')
  else
  writeln(f,';Ballast right:');
writeln(f);

{Schotterbett}
writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'vertex ',schotterr1[i,1]:3:3,', -0.17, ',round(i*5)+p);
  writeln(f,'vertex ',schotterr1[i,2]:3:3,', -0.4, ',round(i*5)+p);
  end;
a:=0;
for i:=0 to round((laenge/5)-1)do
  begin
  writeln(f,'face ',a+1,',',a,',',a+2,',',a+3);
  a:=a+2;
  end;
writeln(f,'[texture]');
writeln(f,'load '+textur1);
a:=0;
j:=0;
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'coordinates ',a,', ',j,', 0');
  a:=a+1;
  writeln(f,'coordinates ',a,', ',j,', 1');
  j:=j+2;
  a:=a+1;
  end;
writeln(f);

if sprache='d' then
  writeln(f,';Schotterbett links:')
  else
  writeln(f,';Ballast left:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'vertex ',schotterl1[i,1]:3:3,', -0.4, ',round(i*5+p));
  writeln(f,'vertex ',schotterl1[i,2]:3:3,', -0.17, ',round(i*5)+p);
  end;
a:=0;
for i:=0 to round((laenge/5)-1)do
  begin
  writeln(f,'face ',a+1,',',a,',',a+2,',',a+3);
  a:=a+2;
  end;
writeln(f,'[texture]');
writeln(f,'load '+textur1);
a:=0;
j:=0;
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'coordinates ',a,', ',j,', 1');
  a:=a+1;
  writeln(f,'coordinates ',a,', ',j,', 0');
  j:=j+2;
  a:=a+1;
  end;
writeln(f);

if sprache='d' then
  writeln(f,';Schwellen links:')
  else
  writeln(f,';Sleepers left:');
writeln(f);

{Schwellen links}
writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'vertex ',schwellen[i,1]:3:3,', -0.17, ',round(i*5)+p);
  writeln(f,'vertex ',schwellen[i,2]:3:3,', -0.17, ',round(i*5)+p);
  end;
a:=0;
for i:=0 to round((laenge/5)-1)do
  begin
  writeln(f,'face ',a+1,',',a,',',a+2,',',a+3);
  a:=a+2;
  end;
writeln(f,'[texture]');
writeln(f,'load '+textur3);
a:=0;
j:=0;
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'coordinates ',a,', 1.005, ',j);
  a:=a+1;
  writeln(f,'coordinates ',a,', ',1+(schwellen[i,1]-schwellen[i,2])/5.4:3:3,', ',j);
  j:=j-2;
  a:=a+1;
  end;
writeln(f);

if sprache='d' then
  writeln(f,';Schwellen rechts:')
  else
  writeln(f,';Sleepers right:');
writeln(f);

{Schwellen rechts}
writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'vertex ',schwellen[i,3]:3:3,', -0.17, ',round(i*5)+p);
  writeln(f,'vertex ',schwellen[i,2]:3:3,', -0.17, ',round(i*5)+p);
  end;
a:=0;
for i:=0 to round((laenge/5)-1)do
  begin
  writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
  a:=a+2;
  end;
writeln(f,'[texture]');
writeln(f,'load '+textur3);
a:=0;
j:=0;
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'coordinates ',a,', 1.005, ',j);
  a:=a+1;
  writeln(f,'coordinates ',a,', ',1-(schwellen[i,3]-schwellen[i,2])/5.4:3:3,', ',j);
  j:=j-2;
  a:=a+1;
  end;
writeln(f);

if sprache='d' then
  writeln(f,';Fluegelschienen:')
  else
  writeln(f,';Closure rails:');
writeln(f);

{FlÅgelschienen}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  writeln(f,'vertex ',fluegel[i,2]:3:3,', -0.001, ',fluegel[i,1]+p:3:3);
writeln(f,'face 0,1,2,3');
writeln(f,'color 85,50,50');

writeln(f,'[meshbuilder]');
for i:=5 to 8 do
  writeln(f,'vertex ',fluegel[i,2]:3:3,', -0.001, ',fluegel[i,1]+p:3:3);
writeln(f,'face 3,2,1,0');
writeln(f,'color 85,50,50');

{3D-Schienen}
writeln(f);
if sprache='d' then
  writeln(f,';Linkes Gleis, rechte 3D-Schiene:')
  else
  writeln(f,';Left track, right 3D-rail:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5)+herz do
  begin
  writeln(f,'vertex ',schiener1[i,2]:3:3,', -0.01, ',schiener1[i,1]+p:3:3);
  writeln(f,'vertex ',schiener1[i,2]:3:3,',-0.17, ',schiener1[i,1]+p:3:3);
  end;
a:=0;
j:=0;
b:=0;
i:=0;
while (i<round((laenge/5)-1)+herz) do
  begin
  if (frac(gleisr1[i,1,1])<>0) and (j=0) then
    begin
    a:=a+2;
    j:=1;
    i:=i+1;
    end;
  if i=round(laenge/5-1) then b:=1;
  if (gleisr1[i+1,1,1]>gleisr1[i+2,1,1]) and (b=0) or (gleisr1[i+1,2,1]>gleisr1[i+2,2,1]) and (b=0) then
    begin
    writeln(f,'face ',a+5,',',a+4,',',a,',',a+1);
    writeln(f,'face ',a+1,',',a,',',a+4,',',a+5);
    b:=1;
    a:=a+2;
    i:=i+1;
    end
  else
    begin
    writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
    writeln(f,'face ',a+1,',',a,',',a+2,',',a+3);
    end;
  a:=a+2;
  i:=i+1;
  end;
writeln(f,'color 85,50,50');
writeln(f);

if sprache='d' then
  writeln(f,';Rechtes Gleis, linke 3D-Schiene:')
  else
  writeln(f,';Right track, left 3D-rail:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5)+herz do
  begin
  writeln(f,'vertex ',schienel2[i,2]:3:3,', -0.01, ',schienel2[i,1]+p:3:3);
  writeln(f,'vertex ',schienel2[i,2]:3:3,',-0.17, ',schienel2[i,1]+p:3:3);
  end;
a:=0;
j:=0;
b:=0;
i:=0;
while(i<round((laenge/5)-1)+herz) do
  begin
  if (frac(gleisl2[i,1,1])<>0) and (j=0) then
    begin
    a:=a+2;
    j:=1;
    i:=i+1;
    end;
  if i=round(laenge/5-1) then b:=1;
  if (gleisl2[i+1,1,1]>gleisl2[i+2,1,1]) and (b=0) or (gleisl2[i+1,2,1]>gleisl2[i+2,2,1]) and (b=0) then
    begin
    writeln(f,'face ',a+5,',',a+4,',',a,',',a+1);
    writeln(f,'face ',a+1,',',a,',',a+4,',',a+5);
    b:=1;
    a:=a+2;
    i:=i+1;
    end
  else
    begin
    writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
    writeln(f,'face ',a+1,',',a,',',a+2,',',a+3);
    end;
  a:=a+2;
  i:=i+1;
  end;
writeln(f,'color 85,50,50');
writeln(f);

if sprache='d' then
  writeln(f,';Rechtes Gleis, rechte 3D-Schiene:')
  else
  writeln(f,';Right track, right 3D-rail:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'vertex ',schienel1[i,2]:3:3,', -0.01, ',schienel1[i,1]+p:3:3);
  writeln(f,'vertex ',schienel1[i,2]:3:3,', -0.17, ',schienel1[i,1]+p:3:3);
  end;
a:=0;
for i:=0 to round((laenge/5)-1)do
  begin
  writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
  writeln(f,'face ',a+1,',',a,',',a+2,',',a+3);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');
writeln(f);

if sprache='d' then
  writeln(f,';Linkes Gleis, linke 3D-Schiene:')
  else
  writeln(f,';Left track, left 3D-rail:');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to round(laenge/5) do
  begin
  writeln(f,'vertex ',schiener2[i,2]:3:3,', -0.01, ',schiener2[i,1]+p:3:3);
  writeln(f,'vertex ',schiener2[i,2]:3:3,', -0.17, ',schiener2[i,1]+p:3:3);
  end;
a:=0;
for i:=0 to round((laenge/5)-1)do
  begin
  writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
  writeln(f,'face ',a+1,',',a,',',a+2,',',a+3);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');
writeln(f);

if sprache='d' then
  writeln(f,';3D-Fluegelschienen:')
  else
  writeln(f,';3D-closure rails:');
writeln(f);


{3D-FlÅgelschienen}
writeln(f,'[meshbuilder]');
writeln(f,'vertex ',fluegel[1,2]+0.04:3:3,', -0.17, ',fluegel[1,1]+p:3:3);
writeln(f,'vertex ',fluegel[1,2]+0.04:3:3,', -0.01, ',fluegel[1,1]+p:3:3);
writeln(f,'vertex ',punkt[4,2]-0.04:3:3,', -0.01, ',punkt[4,1]+p:3:3);
writeln(f,'vertex ',punkt[4,2]-0.04:3:3,', -0.17, ',punkt[4,1]+p:3:3);
writeln(f,'face 0,1,2,3');
writeln(f,'face 3,2,1,0');
writeln(f,'color 85,50,50');
writeln(f);
writeln(f,'[meshbuilder]');
writeln(f,'vertex ',fluegel[5,2]-0.04:3:3,', -0.17, ',fluegel[5,1]+p:3:3);
writeln(f,'vertex ',fluegel[5,2]-0.04:3:3,', -0.01, ',fluegel[5,1]+p:3:3);
writeln(f,'vertex ',punkt[8,2]+0.04:3:3,', -0.01, ',punkt[8,1]+p:3:3);
writeln(f,'vertex ',punkt[8,2]+0.04:3:3,', -0.17, ',punkt[8,1]+p:3:3);
writeln(f,'face 0,1,2,3');
writeln(f,'face 3,2,1,0');
writeln(f,'color 85,50,50');
writeln(f);

if sprache='d' then
  writeln(f,';Radlenker links:')
  else
  writeln(f,';Guard rails left:');
writeln(f);

{Radlenker}
if (radlenk='j') or (radlenk='y') then
begin
writeln(f,'[meshbuilder]');
i:=1;
while radl[i,1,1]<>999 do
  begin
  writeln(f,'vertex ',radl[i,1,2]:3:3,', 0, ',radl[i,1,1]+p:3:3);
  writeln(f,'vertex ',radl[i,2,2]:3:3,', 0, ',radl[i,2,1]+p:3:3);
  i:=i+1;
  end;
i:=1;
a:=0;
while radl[i+1,1,1]<>999 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  i:=i+1;
  end;
writeln(f,'color 85,50,50');
writeln(f);

if sprache='d' then
  writeln(f,';Radlenker rechts:')
  else
  writeln(f,';Guard rails right:');
writeln(f);

writeln(f,'[meshbuilder]');
i:=1;
while radr[i,1,1]<>999 do
  begin
  writeln(f,'vertex ',radr[i,1,2]:3:3,', 0, ',radr[i,1,1]+p:3:3);
  writeln(f,'vertex ',radr[i,2,2]:3:3,', 0, ',radr[i,2,1]+p:3:3);
  i:=i+1;
  end;
i:=1;
a:=0;
while radr[i+1,1,1]<>999 do
  begin
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  i:=i+1;
  end;
writeln(f,'color 85,50,50');
writeln(f);

if sprache='d' then
  writeln(f,';3D-Radlenker links:')
  else
  writeln(f,';3D-Guard rails left:');
writeln(f);

writeln(f,'[meshbuilder]');
i:=1;
while radl[i,1,1]<>999 do
  begin
  writeln(f,'vertex ',radl[i,1,2]:3:3,', 0, ',radl[i,1,1]+p:3:3);
  writeln(f,'vertex ',radl[i,1,2]:3:3,', -0.17, ',radl[i,1,1]+p:3:3);
  i:=i+1;
  end;
i:=1;
a:=0;
while radl[i+1,1,1]<>999 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  i:=i+1;
  end;
writeln(f,'color 85,50,50');
writeln(f);

if sprache='d' then
  writeln(f,';3D-Radlenker rechts:')
  else
  writeln(f,';3D-Guard rails right:');
writeln(f);

writeln(f,'[meshbuilder]');
i:=1;
while radl[i,1,1]<>999 do
  begin
  writeln(f,'vertex ',radr[i,1,2]:3:3,', 0, ',radr[i,1,1]+p:3:3);
  writeln(f,'vertex ',radr[i,1,2]:3:3,', -0.17, ',radr[i,1,1]+p:3:3);
  i:=i+1;
  end;
i:=1;
a:=0;
while radl[i+1,1,1]<>999 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  i:=i+1;
  end;
writeln(f,'color 85,50,50');
//writeln;
end;

end;
{Prozedurende}

procedure schreiben2;
var i:integer;
begin
{AusgleichsstÅck Anfang}


if ma<>0 then
  begin

  writeln(f);
  if sprache='d' then
  writeln(f,';Ausgleichsstueck Anfang:')
  else
  writeln(f,';Compensating piece beginning:');
  writeln(f);

  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -0.800, 0.000, ',p);
  writeln(f,'vertex -0.720, 0.000, ',p);
  writeln(f,'vertex -0.720, 0.000, ',0-ma+p:3:3);
  writeln(f,'vertex -0.800, 0.000, ',0-ma+p:3:3);
  writeln(f,'vertex 0.800, 0.000, ',p);
  writeln(f,'vertex 0.720, 0.000, ',p);
  writeln(f,'vertex 0.720, 0.000, ',0-ma+p:3:3);
  writeln(f,'vertex 0.800, 0.000, ',0-ma+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'face 7,6,5,4');
  writeln(f,'color 180,190,200');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -0.760, -0.170, ',p);
  writeln(f,'vertex -0.760, 0.000, ',p);
  writeln(f,'vertex -0.760, 0.000, ',0-ma+p:3:3);
  writeln(f,'vertex -0.760, -0.170, ',0-ma+p:3:3);
  writeln(f,'vertex 0.760, -0.170, ',p);
  writeln(f,'vertex 0.760, 0.000, ',p);
  writeln(f,'vertex 0.760, 0.000, ',0-ma+p:3:3);
  writeln(f,'vertex 0.760, -0.170, ',0-ma+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'face 3,2,1,0');
  writeln(f,'face 7,6,5,4');
  writeln(f,'face 4,5,6,7');
  writeln(f,'color 85,50,50');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -1.35, -0.170, ',p);
  writeln(f,'vertex 1.35, -0.170, ',p);
  writeln(f,'vertex 1.35, -0.170, ',0-ma+p:3:3);
  writeln(f,'vertex -1.35, -0.170, ',0-ma+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'[texture]');
  writeln(f,'load '+textur2);
  writeln(f,'coordinates 0,-0.02,0');
  writeln(f,'coordinates 1,1.02,0');
  writeln(f,'coordinates 2,1.02, ',ma*0.4:3:3);
  writeln(f,'coordinates 3,-0.02, ',ma*0.4:3:3);
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -2.8, -0.4, ',p);
  writeln(f,'vertex -1.35, -0.170, ',p);
  writeln(f,'vertex -1.35, -0.170, ',0-ma+p:3:3);
  writeln(f,'vertex -2.8, -0.4, ',0-ma+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'[texture]');
  writeln(f,'load '+textur1);
  writeln(f,'coordinates 0,0, ',ma*0.4:3:3);
  writeln(f,'coordinates 1,1, ',ma*0.4:3:3);
  writeln(f,'coordinates 2,1,0');
  writeln(f,'coordinates 3,0,0');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex 2.8, -0.4, ',p);
  writeln(f,'vertex 1.35, -0.170, ',p);
  writeln(f,'vertex 1.35, -0.170, ',0-ma+p:3:3);
  writeln(f,'vertex 2.8, -0.4, ',0-ma+p:3:3);
  writeln(f,'face 3,2,1,0');
  writeln(f,'[texture]');
  writeln(f,'load '+textur1);
  writeln(f,'coordinates 0,0,0');
  writeln(f,'coordinates 1,1,0');
  writeln(f,'coordinates 2,1, ',ma*0.4:3:3);
  writeln(f,'coordinates 3,0, ',ma*0.4:3:3);
  end;

  {AusgleichsstÅck Ende}

if me<>0 then
  begin

  writeln(f);
  if sprache='d' then
  writeln(f,';Ausgleichsstueck Ende:')
  else
  writeln(f,';Compensating piece end:');

  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -0.800, 0.000, ',laenge+me+p:3:3);
  writeln(f,'vertex -0.720, 0.000, ',laenge+me+p:3:3);
  writeln(f,'vertex -0.720, 0.000, ',laenge+p:3:3);
  writeln(f,'vertex -0.800, 0.000, ',laenge+p:3:3);
  writeln(f,'vertex 0.800, 0.000, ',laenge+me+p:3:3);
  writeln(f,'vertex 0.720, 0.000, ',laenge+me+p:3:3);
  writeln(f,'vertex 0.720, 0.000, ',laenge+p:3:3);
  writeln(f,'vertex 0.800, 0.000, ',laenge+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'face 7,6,5,4');
  writeln(f,'color 180,190,200');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -0.760, -0.170, ',laenge+me+p:3:3);
  writeln(f,'vertex -0.760, 0.000, ',laenge+me+p:3:3);
  writeln(f,'vertex -0.760, 0.000, ',laenge+p:3:3);
  writeln(f,'vertex -0.760, -0.170, ',laenge+p:3:3);
  writeln(f,'vertex 0.760, -0.170, ',laenge+me+p:3:3);
  writeln(f,'vertex 0.760, 0.000, ',laenge+me+p:3:3);
  writeln(f,'vertex 0.760, 0.000, ',laenge+p:3:3);
  writeln(f,'vertex 0.760, -0.170, ',laenge+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'face 3,2,1,0');
  writeln(f,'face 7,6,5,4');
  writeln(f,'face 4,5,6,7');
  writeln(f,'color 85,50,50');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -1.35, -0.170, ',laenge+me+p:3:3);
  writeln(f,'vertex 1.35, -0.170, ',laenge+me+p:3:3);
  writeln(f,'vertex 1.35, -0.170, ',laenge+p:3:3);
  writeln(f,'vertex -1.35, -0.170, ',laenge+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'[texture]');
  writeln(f,'load '+textur2);
  writeln(f,'coordinates 0,-0.02,0');
  writeln(f,'coordinates 1,1.02,0');
  writeln(f,'coordinates 2,1.02, ',me*0.4:3:3);
  writeln(f,'coordinates 3,-0.02, ',me*0.4:3:3);
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -2.8, -0.4, ',laenge+me+p:3:3);
  writeln(f,'vertex -1.35, -0.170, ',laenge+me+p:3:3);
  writeln(f,'vertex -1.35, -0.170, ',laenge+p:3:3);
  writeln(f,'vertex -2.8, -0.4, ',laenge+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'[texture]');
  writeln(f,'load '+textur1);
  writeln(f,'coordinates 0,0, ',me*0.4:3:3);
  writeln(f,'coordinates 1,1, ',me*0.4:3:3);
  writeln(f,'coordinates 2,1,0');
  writeln(f,'coordinates 3,0,0');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex 2.8, -0.4, ',laenge+me+p:3:3);
  writeln(f,'vertex 1.35, -0.170, ',laenge+me+p:3:3);
  writeln(f,'vertex 1.35, -0.170, ',laenge+p:3:3);
  writeln(f,'vertex 2.8, -0.4, ',laenge+p:3:3);
  writeln(f,'face 3,2,1,0');
  writeln(f,'[texture]');
  writeln(f,'load '+textur1);
  writeln(f,'coordinates 0,0,0');
  writeln(f,'coordinates 1,1,0');
  writeln(f,'coordinates 2,1, ',me*0.4:3:3);
  writeln(f,'coordinates 3,0, ',me*0.4:3:3);
  end;

  
{Oberleitung rechts}
if (oberrjn='j') or (oberrjn='y') then
  begin

  writeln(f);
  if sprache='d' then
  writeln(f,';Oberleitung rechts:')
  else
  writeln(f,';Overhead line right:');
  writeln(f);

  for i:=0 to round(laenge/5) do
    oberraufh[i]:=(xdev2/laenge)*i*5;
  end;

if (oberrjn='j') or (oberrjn='y') then
begin
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -0.02, ', oberfahr:3:3, ', ',p);
  writeln(f, 'vertex 0.02, ', oberfahr:3:3, ', ',p);
  writeln(f, 'vertex ',xdev2+0.02:3:3, ', ', oberfahr:3:3, ', ', round(laenge)+p);
  writeln(f, 'vertex ',xdev2-0.02:3:3, ', ', oberfahr:3:3, ', ', round(laenge)+p);
  writeln(f,'face 0,1,2,3');
  writeln(f,'color 0,0,0');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -0.01, ', obertrag:3:3, ', ',p);
  writeln(f, 'vertex 0.01, ', obertrag:3:3, ', ',p);
  writeln(f, 'vertex ',xdev2+0.01:3:3, ', ', obertrag:3:3, ', ', round(laenge)+p);
  writeln(f, 'vertex ',xdev2-0.01:3:3, ', ', obertrag:3:3, ', ', round(laenge)+p);
  writeln(f,'face 0,1,2,3');
  writeln(f,'color 0,0,0');
  writeln(f);

  for i:=0 to round(laenge/5) do
    begin
    writeln(f,'[meshbuilder]');
    writeln(f, 'vertex ',oberraufh[i]-0.01:3:3, ', ', obertrag:3:3, ', ', i*5+p);
    writeln(f, 'vertex ',oberraufh[i]+0.01:3:3, ', ', obertrag:3:3, ', ', i*5+p);
    writeln(f, 'vertex ',oberraufh[i]+0.01:3:3, ', ', oberfahr:3:3, ', ', i*5+p);
    writeln(f, 'vertex ',oberraufh[i]-0.01:3:3, ', ', oberfahr:3:3, ', ', i*5+p);
    writeln(f, 'face 0,1,2,3');
    writeln(f,'color 0,0,0');
    end;
end;

{Oberleitung links}
if (oberljn='j')or (oberljn='y') then
  begin

  writeln(f);
  if sprache='d' then
  writeln(f,';Oberleitung links:')
  else
  writeln(f,';Overhead line left:');

  for i:=0 to round(laenge/5) do
    oberlaufh[i]:=(xdev1/laenge)*i*5;
  end;

if (oberljn='j') or (oberljn='y') then
begin
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -0.02, ', oberfahr:3:3, ', ',p);
  writeln(f, 'vertex 0.02, ', oberfahr:3:3, ', ',p);
  writeln(f, 'vertex ',xdev1+0.02:3:3, ', ', oberfahr:3:3, ', ', round(laenge)+p);
  writeln(f, 'vertex ',xdev1-0.02:3:3, ', ', oberfahr:3:3, ', ', round(laenge)+p);
  writeln(f,'face 0,1,2,3');
  writeln(f,'color 0,0,0');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex -0.01, ', obertrag:3:3, ', ',p);
  writeln(f, 'vertex 0.01, ', obertrag:3:3, ', ',p);
  writeln(f, 'vertex ',xdev1+0.01:3:3, ', ', obertrag:3:3, ', ', round(laenge)+p);
  writeln(f, 'vertex ',xdev1-0.01:3:3, ', ', obertrag:3:3, ', ', round(laenge)+p);
  writeln(f,'face 0,1,2,3');
  writeln(f,'color 0,0,0');
  writeln(f);

  for i:=0 to round(laenge/5) do
    begin
    writeln(f,'[meshbuilder]');
    writeln(f, 'vertex ',oberlaufh[i]-0.01:3:3, ', ', obertrag:3:3, ', ', i*5+p);
    writeln(f, 'vertex ',oberlaufh[i]+0.01:3:3, ', ', obertrag:3:3, ', ', i*5+p);
    writeln(f, 'vertex ',oberlaufh[i]+0.01:3:3, ', ', oberfahr:3:3, ', ', i*5+p);
    writeln(f, 'vertex ',oberlaufh[i]-0.01:3:3, ', ', oberfahr:3:3, ', ', i*5+p);
    writeln(f, 'face 0,1,2,3');
    writeln(f,'color 0,0,0');
    end;
end;

{Oberleitungs-ErgÑnzungsstÅcke}
if (oberrjn='j') or (oberljn='j') or (oberrjn='y') or (oberljn='y') then
  begin

  

  if me<>0 then
    begin
    writeln(f);
    if sprache='d' then
    writeln(f,';Oberleitungs-ErgÑnzungsstuecke:')
    else
    writeln(f,';Overhead line compensating pieces:');
    writeln(f);
    writeln(f,'[meshbuilder]');
    writeln(f,'vertex -0.02, ',oberfahr:3:3,', ',laenge+p:3:3);
    writeln(f,'vertex 0.02, ',oberfahr:3:3,', ',laenge+p:3:3);
    writeln(f,'vertex 0.02, ',oberfahr:3:3,', ',laenge+me+p:3:3);
    writeln(f,'vertex -0.02, ',oberfahr:3:3,', ',laenge+me+p:3:3);
    writeln(f,'face 0,1,2,3');
    writeln(f,'color 0,0,0');
    writeln(f);
    writeln(f,'[meshbuilder]');
    writeln(f,'vertex -0.01, ',obertrag:3:3,', ',laenge+p:3:3);
    writeln(f,'vertex 0.01, ',obertrag:3:3,', ',laenge+p:3:3);
    writeln(f,'vertex 0.01, ',obertrag:3:3,', ',laenge+me+p:3:3);
    writeln(f,'vertex -0.01, ',obertrag:3:3,', ',laenge+me+p:3:3);
    writeln(f,'face 0,1,2,3');
    writeln(f,'color 0,0,0');
    
    i:=round(laenge+me);
    repeat;
      writeln(f,'[meshbuilder]');
      writeln(f,'vertex -0.01, ',obertrag:3:3,', ',i+p);
      writeln(f,'vertex 0.01, ',obertrag:3:3,', ',i+p);
      writeln(f,'vertex 0.01, ',oberfahr:3:3,', ',i+p);
      writeln(f,'vertex -0.01, ',oberfahr:3:3,', ',i+p);
      writeln(f,'face 0,1,2,3');
      writeln(f,'color 0,0,0');
      i:=i-5;
    until i=laenge;
    end;

  if ma<>0 then
    begin
    writeln(f);
    writeln(f,'[meshbuilder]');
    writeln(f,'vertex -0.02, ',oberfahr:3:3,', ',0-ma+p:3:3);
    writeln(f,'vertex 0.02, ',oberfahr:3:3,', ',0-ma+p:3:3);
    writeln(f,'vertex 0.02, ',oberfahr:3:3,', ',p);
    writeln(f,'vertex -0.02, ',oberfahr:3:3,', ',p);
    writeln(f,'face 0,1,2,3');
    writeln(f,'color 0,0,0');
    writeln(f);
    writeln(f,'[meshbuilder]');
    writeln(f,'vertex -0.01, ',obertrag:3:3,', ',0-ma+p:3:3);
    writeln(f,'vertex 0.01, ',obertrag:3:3,', ',0-ma+p:3:3);
    writeln(f,'vertex 0.01, ',obertrag:3:3,', ',p);
    writeln(f,'vertex -0.01, ',obertrag:3:3,', ',p);
    writeln(f,'face 0,1,2,3');
    writeln(f,'color 0,0,0');
    
    i:=round(0-ma);
    repeat;
      writeln(f,'[meshbuilder]');
      writeln(f,'vertex -0.01, ',obertrag:3:3,', ',i+p);
      writeln(f,'vertex 0.01, ',obertrag:3:3,', ',i+p);
      writeln(f,'vertex 0.01, ',oberfahr:3:3,', ',i+p);
      writeln(f,'vertex -0.01, ',oberfahr:3:3,', ',i+p);
      writeln(f,'face 0,1,2,3');
      writeln(f,'color 0,0,0');
      i:=i+5;
    until i=0;
    end;
  end;
  close(f);
end;

     


end.