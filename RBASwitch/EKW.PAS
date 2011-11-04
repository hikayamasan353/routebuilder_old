unit EKW;

interface

uses mirror;

var gleisa1: array [0..15,1..2,1..2] of real;
    gleisa2: array [0..15,1..2,1..2] of real;
    gleisb1: array [0..15,1..2,1..2] of real;
    gleisb2: array [0..15,1..2,1..2] of real;
    gleis: array[0..5,1..2]of real;
    gleisr1: array[0..5,1..2]of real;
    gleisr2: array[0..5,1..2]of real;
    gleisr3: array[0..5,1..2]of real;
    gleisr4: array[0..5,1..2]of real;
    gleisl1: array[0..5,1..2]of real;
    gleisl2: array[0..5,1..2]of real;
    gleisl3: array[0..5,1..2]of real;
    gleisl4: array[0..5,1..2]of real;
    fluegelsch: array [1..16,1..2] of real;
    radlenk1: array [1..5,1..2,1..2] of real;
    radlenk2: array [1..5,1..2,1..2] of real;
    radlenk3: array [1..4,1..2,1..2] of real;
    radlenk4: array [1..4,1..2,1..2] of real;
    radlenk5: array [1..4,1..2,1..2] of real;
    radlenk6: array [1..4,1..2,1..2] of real;
    radlenk:char;
    schw1: array[1..8,1..2,1..2] of real;
    schw2: array[1..8,1..2,1..2] of real;
    schottr: array[1..8,1..2] of real;
    schottl: array[1..8,1..2] of real;
    laenge, xoff: real;
    a,b,c,i,j,k,zaehl: integer;
    sprech: char;
    dname: string;
    f:text;
    steigung, z:real;
    winkel, radius, xdev, bglaenge, bgstart, bgende:real;
    richtung: integer;
    zunge:real;
    oberjn:char;
    oberaufh:array[1..20] of real;
    p:real;
    xoffchk:real;
    inhalt1, inhalt2:string;
    oberfahr, obertrag:real;

procedure kreuzung1;
procedure gleisbett;
procedure infos;
procedure kreuzung2;
procedure gleisbett2;

implementation

procedure kreuzung1;
begin

repeat;
if sprech='d' then
  writeln('Geben Sie bitte die LÑnge der Kreuzung ein:')
  else
  writeln('Please enter the length of the crossing:');
readln(laenge);
if frac(laenge/5)<>0 then
  begin
  if sprech='d' then
    writeln('Die LÑnge muss ein Produkt von 5 sein.')
    else
    writeln('The length must be a product of 5.');
  writeln;
  end;
until frac(laenge/5)=0;
writeln;

repeat;
if sprech='d' then
  writeln('Geben Sie bitte die X-Abweichung ein:')
  else
  writeln('Please enter the x-offset:');
readln(xoff);
if (xoff<1.75) and (xoff>-1.75) then
  begin
  if sprech='d' then
    writeln('Die X-Abweichung muss mindestens +/-1.75m betragen.')
    else
    writeln('The x-offset has to be at least +/-1.75m.');
  writeln;
  end;
until (xoff<=-1.75) or (xoff>=1.75);
xoffchk:=xoff;
xoff:=abs(xoff);
writeln;



repeat;
if sprech='d' then
begin
  writeln('Welcher Fahrweg ("1"=normales Gleis, geradeaus, "2"=normales Gleis, Abzweig,');
  writeln('"3"=kreuzendes Gleis, geradeaus)?');
  end
else
  begin
  writeln('Direction of travel ("1"=normal track, straight, "2"=normal track, branch,');
  writeln('"3"=crossing track, straight)?');
  end;

readln(richtung);
if (richtung<1) or (richtung>3) then
begin
writeln;
if sprech='d' then
writeln('Wie bitte? Bitte noch einmal eingeben.')
else
writeln('Pardon? Please enter again.');
end;
writeln;
until (richtung>=1) and (richtung<=3);

repeat;
if sprech='d' then
writeln('Soll die Kreuzung Åber Radlenker verfÅgen (j/n)?')
else
writeln('Shall the crossing have guard rails (y/n)?');

readln(radlenk);
if (radlenk<>'j') and (radlenk<>'y') and (radlenk<>'n') then
begin
writeln;
if sprech='d' then
writeln('Wie bitte? Ja oder nein?')
else
writeln('Pardon? Yes or no?');
end;
writeln;
until (radlenk='j') or (radlenk='y') or (radlenk='n');

repeat;
if sprech='d' then
writeln('Soll die Kreuzung eine Oberleitung besitzen (j/n)?')
else
writeln('Shall the crossing have an overhead line (y/n) ?');
readln(oberjn);
if (oberjn<>'j') and(oberjn<>'y') and (oberjn<>'n') then
  begin
  writeln;
  if sprech='d' then
  writeln('Wie bitte? Ja oder nein?')
  else
  writeln('Pardon? Yes or no?');
  writeln;
  end;
  until (oberjn='j') or (oberjn='y') or (oberjn='n');
  writeln;

if oberjn<>'n' then
  begin
  repeat;
  if sprech='d' then
  writeln('Geben Sie bitte die Hîhe des Fahrdrahtes ein (Standard 6m):')
  else
    writeln('Please enter the height of the contact wire (standard 6m):');
  readln(oberfahr);
  if oberfahr<4.5 then
    if sprech='d' then
    writeln('Das dÅrfte ein wenig eng werden. Der Wert muss zwischen 4.5 und 7 m liegen.')
    else
    writeln('This might be a little low. The value has to bee between 4.5 and 7 meters.');

  if oberfahr>7 then
    if sprech='d' then
    writeln('Das dÅrfte zu hoch sein. Der Wert muss zwischen 4.5 und 7 m liegen.')
    else
   writeln('This might be too high. The value has to be between 4.5 and 7 meters.');

  writeln;
  until (oberfahr>4.5) and (oberfahr<7);

  repeat;
  if sprech='d' then
  writeln('Geben Sie bitte die Hîhe des Tragseils ein (Standard 7m):')
  else
  writeln('Please enter the height of the carrying rope (standard 7m:');
  readln(obertrag);
  if obertrag<oberfahr then
    if sprech='d' then
    writeln('Das Tragseil muss oberhalb des Fahrdrahtes liegen.')
    else
    writeln('The carrying rope must be above the contact wire.');
  writeln;
  until oberfahr<obertrag;
  end;



if sprech='d' then
writeln('Bitte geben Sie einen Dateinamen ein (max. 8 Zeichen, ohne Endung):')
else
writeln('Please enter a file name (max. 8 characters, without extension):');
readln(dname);
dname:=concat(dname,'.b3d');

{Berechnung der geraden Gleise:}
for i:=0 to 10 do
  begin
  gleisa1[i,1,1]:=999;
  gleisa1[i,1,2]:=999;
  gleisa1[i,2,1]:=999;
  gleisa1[i,2,2]:=999;
  gleisa2[i,1,1]:=999;
  gleisa2[i,1,2]:=999;
  gleisa2[i,2,1]:=999;
  gleisa2[i,2,2]:=999;
  gleisb1[i,1,1]:=999;
  gleisb1[i,1,2]:=999;
  gleisb1[i,2,1]:=999;
  gleisb1[i,2,2]:=999;
  gleisb2[i,1,1]:=999;
  gleisb2[i,1,2]:=999;
  gleisb2[i,2,1]:=999;
  gleisb2[i,2,2]:=999;
  end;

gleisa1[0,1,1]:=-0.8;
gleisa1[0,1,2]:=0;
gleisa1[0,2,1]:=-0.72;
gleisa1[0,2,2]:=0;
gleisa1[1,1,1]:=-0.8;
gleisa1[1,1,2]:=laenge;
gleisa1[1,2,1]:=-0.72;
gleisa1[1,2,2]:=laenge;

gleisa2[0,1,1]:=0.72;
gleisa2[0,1,2]:=0;
gleisa2[0,2,1]:=0.8;
gleisa2[0,2,2]:=0;
gleisa2[1,1,1]:=0.72;
gleisa2[1,1,2]:=laenge;
gleisa2[1,2,1]:=0.8;
gleisa2[1,2,2]:=laenge;

gleisb1[0,1,1]:=-xoff-0.8;
gleisb1[0,1,2]:=0;
gleisb1[0,2,1]:=-xoff-0.72;
gleisb1[0,2,2]:=0;
gleisb1[1,1,1]:=xoff-0.8;
gleisb1[1,1,2]:=laenge;
gleisb1[1,2,1]:=xoff-0.72;
gleisb1[1,2,2]:=laenge;

gleisb2[0,1,1]:=-xoff+0.72;
gleisb2[0,1,2]:=0;
gleisb2[0,2,1]:=-xoff+0.8;
gleisb2[0,2,2]:=0;
gleisb2[1,1,1]:=xoff+0.72;
gleisb2[1,1,2]:=laenge;
gleisb2[1,2,1]:=xoff+0.8;
gleisb2[1,2,2]:=laenge;

steigung:=2*xoff/laenge;
gleisa1[1,1,1]:=-0.8;
gleisa1[1,1,2]:=(xoff-0.72-0.8)/steigung;
gleisa1[1,2,1]:=-0.72;
gleisa1[1,2,2]:=(xoff-0.72-0.72)/steigung;
gleisa1[2,1,1]:=-0.8;
gleisa1[2,1,2]:=(xoff-0.64-0.8)/steigung;
gleisa1[2,2,1]:=-0.72;
gleisa1[2,2,2]:=(xoff-0.64-0.72)/steigung;
gleisa1[3,1,1]:=-0.8;
gleisa1[3,1,2]:=(xoff+0.64-0.8)/steigung;
gleisa1[3,2,1]:=-0.72;
gleisa1[3,2,2]:=(xoff+0.64-0.72)/steigung;
gleisa1[4,1,1]:=-0.8;
gleisa1[4,1,2]:=(xoff+0.72-0.8)/steigung;
gleisa1[4,2,1]:=-0.72;
gleisa1[4,2,2]:=(xoff+0.72-0.72)/steigung;
gleisa1[5,1,1]:=-0.8;
gleisa1[5,1,2]:=laenge;
gleisa1[5,2,1]:=-0.72;
gleisa1[5,2,2]:=laenge;

gleisa2[1,1,1]:=0.72;
gleisa2[1,1,2]:=(xoff-0.8+0.72)/steigung;
gleisa2[1,2,1]:=0.8;
gleisa2[1,2,2]:=(xoff-0.8+0.8)/steigung;
gleisa2[2,1,1]:=0.72;
gleisa2[2,1,2]:=(xoff-0.64+0.72)/steigung;
gleisa2[2,2,1]:=0.8;
gleisa2[2,2,2]:=(xoff-0.64+0.8)/steigung;
gleisa2[3,1,1]:=0.72;
gleisa2[3,1,2]:=(xoff+0.64+0.72)/steigung;
gleisa2[3,2,1]:=0.8;
gleisa2[3,2,2]:=(xoff+0.64+0.8)/steigung;
gleisa2[4,1,1]:=0.72;
gleisa2[4,1,2]:=(xoff+0.72+0.72)/steigung;
gleisa2[4,2,1]:=0.8;
gleisa2[4,2,2]:=(xoff+0.72+0.8)/steigung;
gleisa2[5,1,1]:=0.72;
gleisa2[5,1,2]:=laenge;
gleisa2[5,2,1]:=0.8;
gleisa2[5,2,2]:=laenge;


gleisb1[1,1,2]:=(xoff+0.8-0.72)/steigung;
gleisb1[1,1,1]:=gleisb1[1,1,2]*steigung-xoff-0.8;
gleisb1[1,2,2]:=(xoff+0.72-0.72)/steigung;
gleisb1[1,2,1]:=gleisb1[1,2,2]*steigung-xoff-0.72;
gleisb1[2,1,2]:=(xoff+0.8-0.64)/steigung;
gleisb1[2,1,1]:=gleisb1[2,1,2]*steigung-xoff-0.8;
gleisb1[2,2,2]:=(xoff+0.72-0.64)/steigung;
gleisb1[2,2,1]:=gleisb1[2,2,2]*steigung-xoff-0.72;
gleisb1[3,1,2]:=(xoff+0.8+0.64)/steigung;
gleisb1[3,1,1]:=gleisb1[3,1,2]*steigung-xoff-0.8;
gleisb1[3,2,2]:=(xoff+0.72+0.64)/steigung;
gleisb1[3,2,1]:=gleisb1[3,2,2]*steigung-xoff-0.72;
gleisb1[4,1,2]:=(xoff+0.8+0.72)/steigung;
gleisb1[4,1,1]:=gleisb1[4,1,2]*steigung-xoff-0.8;
gleisb1[4,2,2]:=(xoff+0.72+0.72)/steigung;
gleisb1[4,2,1]:=gleisb1[4,2,2]*steigung-xoff-0.72;
gleisb1[5,1,2]:=laenge;
gleisb1[5,1,1]:=gleisb1[5,1,2]*steigung-xoff-0.8;
gleisb1[5,2,2]:=laenge;
gleisb1[5,2,1]:=gleisb1[5,2,2]*steigung-xoff-0.72;

gleisb2[1,1,2]:=(xoff-0.72-0.72)/steigung;
gleisb2[1,1,1]:=gleisb1[1,1,2]*steigung-xoff-0.8;
gleisb2[1,2,2]:=(xoff-0.8-0.72)/steigung;
gleisb2[1,2,1]:=gleisb1[1,2,2]*steigung-xoff-0.72;
gleisb2[2,1,2]:=(xoff-0.72-0.64)/steigung;
gleisb2[2,1,1]:=gleisb1[2,1,2]*steigung-xoff-0.8;
gleisb2[2,2,2]:=(xoff-0.8-0.64)/steigung;
gleisb2[2,2,1]:=gleisb1[2,2,2]*steigung-xoff-0.72;
gleisb2[3,1,2]:=(xoff-0.72+0.64)/steigung;
gleisb2[3,1,1]:=gleisb1[3,1,2]*steigung-xoff-0.8;
gleisb2[3,2,2]:=(xoff-0.8+0.64)/steigung;
gleisb2[3,2,1]:=gleisb1[3,2,2]*steigung-xoff-0.72;
gleisb2[4,1,2]:=(xoff-0.72+0.72)/steigung;
gleisb2[4,1,1]:=gleisb1[4,1,2]*steigung-xoff-0.8;
gleisb2[4,2,2]:=(xoff-0.8+0.72)/steigung;
gleisb2[4,2,1]:=gleisb1[4,2,2]*steigung-xoff-0.72;
gleisb2[5,1,2]:=laenge;
gleisb2[5,1,1]:=gleisb1[5,1,2]*steigung-xoff+0.72;
gleisb2[5,2,2]:=laenge;
gleisb2[5,2,1]:=gleisb1[5,2,2]*steigung-xoff+0.8;

{FlÅgelschienen hinten}
fluegelsch[1,1]:=0.56;
fluegelsch[1,2]:=gleisa2[3,1,2]+1.5;
fluegelsch[2,1]:=0.64;
fluegelsch[2,2]:=gleisa2[3,1,2]+1.5;
fluegelsch[3,1]:=0.64;
fluegelsch[3,2]:=(xoff+0.64+0.8)/steigung;
fluegelsch[4,1]:=0.56;
fluegelsch[4,2]:=(xoff+0.56+0.8)/steigung;

fluegelsch[5,1]:=(gleisa2[3,1,2]+1.5)*steigung-xoff-0.64;
fluegelsch[5,2]:=gleisa2[3,1,2]+1.5;
fluegelsch[6,1]:=(gleisa2[3,1,2]+1.5)*steigung-xoff-0.56;
fluegelsch[6,2]:=gleisa2[3,1,2]+1.5;
fluegelsch[7,2]:=(xoff+0.8+0.56)/steigung;
fluegelsch[7,1]:=0.8;
fluegelsch[8,2]:=(xoff+0.8+0.64)/steigung;
fluegelsch[8,1]:=0.8;

{FlÅgelschienen vorne}
fluegelsch[9,1]:=-0.56;
fluegelsch[9,2]:=gleisa1[2,2,2]-1.5;
fluegelsch[10,1]:=-0.64;
fluegelsch[10,2]:=gleisa1[2,2,2]-1.5;
fluegelsch[11,1]:=-0.64;
fluegelsch[11,2]:=(xoff-0.64-0.8)/steigung;
fluegelsch[12,1]:=-0.56;
fluegelsch[12,2]:=(xoff-0.56-0.8)/steigung;

fluegelsch[13,1]:=(gleisa1[2,2,2]-1.5)*steigung-xoff+0.64;
fluegelsch[13,2]:=gleisa1[2,2,2]-1.5;
fluegelsch[14,1]:=(gleisa1[2,2,2]-1.5)*steigung-xoff+0.56;
fluegelsch[14,2]:=gleisa1[2,2,2]-1.5;
fluegelsch[15,2]:=(xoff-0.8-0.56)/steigung;
fluegelsch[15,1]:=-0.8;
fluegelsch[16,2]:=(xoff-0.8-0.64)/steigung;
fluegelsch[16,1]:=-0.8;



{Gleisbîgen}

bgstart:=laenge-((1.15+xoff)*laenge/(2*xoff));
bgende:=(1.15+xoff)*laenge/(2*xoff);

bglaenge:=bgende-bgstart;
xdev:=bgende*steigung-xoff;

winkel:=(arctan(xdev/bglaenge)*180/pi);
  if xdev<>0 then
  radius:=25*360/(winkel*4*pi)
  else radius:=999999;


{Abzweigendes Gleis}

for i:=0 to 5 do
  begin
  gleis[i,1]:=(sin(winkel*i/(5)*pi/180)/cos(winkel*i/(5)*pi/180))*i*bglaenge/5;
  gleis[i,2]:=i*(bglaenge/5)+bgstart;
  gleisr1[i,1]:=gleis[i,1]+0.8;
  gleisr1[i,2]:=i*(bglaenge/5)+bgstart;
  gleisr2[i,1]:=gleis[i,1]+0.72;
  gleisr2[i,2]:=i*(bglaenge/5)+bgstart;
  gleisr3[i,1]:=gleis[i,1]-0.72;
  gleisr3[i,2]:=i*(bglaenge/5)+bgstart;
  gleisr4[i,1]:=gleis[i,1]-0.8;
  gleisr4[i,2]:=i*(bglaenge/5)+bgstart;
  end;

  if (richtung=1) or (richtung=4) then
  begin
    gleisr4[0,1]:=-0.64;
    gleisr4[1,1]:=-0.64;
    gleisr3[0,1]:=-0.56;
    gleisr3[1,1]:=-0.56;
  end;

  if (richtung=3) or (richtung=4) then
  begin
    gleisr4[4,1]:=gleisr4[4,2]*steigung-xoff-0.64;
    gleisr4[5,1]:=gleisr4[5,1]+0.16;
    gleisr3[4,1]:=gleisr3[4,2]*steigung-xoff-0.56;
    gleisr3[5,1]:=gleisr3[5,1]+0.16;
  end;

  gleisr4[0,1]:=gleisr4[0,1]+0.04;
  gleisr4[5,1]:=gleisr4[5,1]+0.04;


{Radlenker Mitte rechts}
radlenk1[1,1,1]:=(laenge/2-1.5)*steigung-xoff+0.64;
radlenk1[1,1,2]:=laenge/2-1.5;
radlenk1[2,1,1]:=(laenge/2-1)*steigung-xoff+0.64;
radlenk1[2,1,2]:=laenge/2-1;
radlenk1[3,1,1]:=0.64;
radlenk1[3,1,2]:=laenge/2;
radlenk1[4,1,1]:=0.64;
radlenk1[4,1,2]:=laenge/2+1;
radlenk1[5,1,1]:=0.64;
radlenk1[5,1,2]:=laenge/2+1.5;

for i:=1 to 5 do
  begin
  radlenk1[i,2,1]:=radlenk1[i,1,1]-0.08;
  radlenk1[i,2,2]:=radlenk1[i,1,2];
  end;

radlenk1[1,1,1]:=radlenk1[1,1,1]-0.04;
radlenk1[5,1,1]:=radlenk1[5,1,1]-0.04;

{Radlenker Mitte links}
radlenk2[1,1,1]:=-0.64;
radlenk2[1,1,2]:=laenge/2-1.5;
radlenk2[2,1,1]:=-0.64;
radlenk2[2,1,2]:=laenge/2-1;
radlenk2[3,1,1]:=-0.64;
radlenk2[3,1,2]:=laenge/2;
radlenk2[4,1,1]:=(laenge/2+1)*steigung-xoff-0.64;
radlenk2[4,1,2]:=laenge/2+1;
radlenk2[5,1,1]:=(laenge/2+1.5)*steigung-xoff-0.64;
radlenk2[5,1,2]:=laenge/2+1.5;

for i:=1 to 5 do
  begin
  radlenk2[i,2,1]:=radlenk2[i,1,1]+0.08;
  radlenk2[i,2,2]:=radlenk2[i,1,2];
  end;

radlenk2[1,1,1]:=radlenk2[1,1,1]+0.04;
radlenk2[5,1,1]:=radlenk2[5,1,1]+0.04;


{Radlenker Ende rechts}
radlenk3[1,1,1]:=fluegelsch[1,2]*steigung-xoff+0.56;
radlenk3[1,1,2]:=fluegelsch[1,2];
radlenk3[2,1,1]:=(fluegelsch[1,2]-0.5)*steigung-xoff+0.56;
radlenk3[2,1,2]:=fluegelsch[1,2]-0.5;
radlenk3[3,1,1]:=(gleisr1[5,2]+0.8)*steigung-xoff+0.56;
radlenk3[3,1,2]:=gleisr1[5,2]+0.8;
radlenk3[4,1,1]:=(gleisr1[5,2]+0.3)*steigung-xoff+0.56;
radlenk3[4,1,2]:=gleisr1[5,2]+0.3;

for i:=1 to 4 do
  begin
  radlenk3[i,2,1]:=radlenk3[i,1,1]+0.08;
  radlenk3[i,2,2]:=radlenk3[i,1,2];
  end;

radlenk3[1,2,1]:=radlenk3[1,2,1]-0.04;
radlenk3[4,2,1]:=radlenk3[4,2,1]-0.04;

{Radlenker Ende links}
radlenk4[1,1,1]:=-0.64;
radlenk4[1,1,2]:=fluegelsch[1,2];
radlenk4[2,1,1]:=-0.64;
radlenk4[2,1,2]:=fluegelsch[1,2]-0.5;
radlenk4[3,1,1]:=-0.64;
radlenk4[3,1,2]:=gleisr1[5,2]+0.8;
radlenk4[4,1,1]:=-0.64;
radlenk4[4,1,2]:=gleisr1[5,2]+0.3;

for i:=1 to 4 do
  begin
  radlenk4[i,2,1]:=radlenk4[i,1,1]+0.08;
  radlenk4[i,2,2]:=radlenk4[i,1,2];
  end;

radlenk4[1,1,1]:=radlenk4[1,1,1]+0.04;
radlenk4[4,1,1]:=radlenk4[4,1,1]+0.04;

{Radlenker vorne links}
radlenk5[1,1,1]:=(fluegelsch[9,2])*steigung-xoff-0.56;
radlenk5[1,1,2]:=fluegelsch[9,2];
radlenk5[2,1,1]:=(fluegelsch[9,2]+0.5)*steigung-xoff-0.56;
radlenk5[2,1,2]:=fluegelsch[9,2]+0.5;
radlenk5[3,1,1]:=(gleisr1[0,2]-0.8)*steigung-xoff-0.56;
radlenk5[3,1,2]:=gleisr1[0,2]-0.8;
radlenk5[4,1,1]:=(gleisr1[0,2]-0.3)*steigung-xoff-0.56;
radlenk5[4,1,2]:=gleisr1[0,2]-0.3;

for i:=1 to 4 do
  begin
  radlenk5[i,2,1]:=radlenk5[i,1,1]-0.08;
  radlenk5[i,2,2]:=radlenk5[i,1,2];
  end;

radlenk5[1,2,1]:=radlenk5[1,2,1]+0.04;
radlenk5[4,2,1]:=radlenk5[4,2,1]+0.04;

{Radlenker vorne rechts}
radlenk6[1,1,1]:=0.64;
radlenk6[1,1,2]:=fluegelsch[9,2];
radlenk6[2,1,1]:=0.64;
radlenk6[2,1,2]:=fluegelsch[9,2]+0.5;
radlenk6[3,1,1]:=0.64;
radlenk6[3,1,2]:=gleisr1[0,2]-0.8;
radlenk6[4,1,1]:=0.64;
radlenk6[4,1,2]:=gleisr1[0,2]-0.3;

for i:=1 to 4 do
  begin
  radlenk6[i,2,1]:=radlenk6[i,1,1]-0.08;
  radlenk6[i,2,2]:=radlenk6[i,1,2];
  end;

radlenk6[1,1,1]:=radlenk6[1,1,1]-0.04;
radlenk6[4,1,1]:=radlenk6[4,1,1]-0.04;



{Weichenzungen}
{geradeaus, vorne rechts}

for i:=12 downto 1 do
  begin
  gleisa2[i+3,1,1]:=gleisa2[i,1,1];
  gleisa2[i+3,1,2]:=gleisa2[i,1,2];
  gleisa2[i+3,2,1]:=gleisa2[i,2,1];
  gleisa2[i+3,2,2]:=gleisa2[i,2,2];
  end;

gleisa2[1,1,1]:=0.72;
gleisa2[1,1,2]:=bgstart;
gleisa2[2,1,1]:=0.72;
gleisa2[2,1,2]:=bgstart;
gleisa2[3,1,1]:=0.72;
gleisa2[3,1,2]:=laenge/2-1.5;

gleisa2[1,2,1]:=0.8;
gleisa2[1,2,2]:=bgstart;
gleisa2[2,2,1]:=0.76;
gleisa2[2,2,2]:=bgstart;
gleisa2[3,2,1]:=0.8;
gleisa2[3,2,2]:=laenge/2-1.5;

if (richtung=2) or (richtung=3) then
  begin
  gleisa2[2,1,1]:=gleisa2[2,1,1]-0.16;
  gleisa2[2,2,1]:=gleisa2[2,2,1]-0.16;
  end;


{kreuzend, hinten rechts}


gleisb2[8,1,1]:=gleisb2[5,1,1];
gleisb2[8,1,2]:=gleisb2[5,1,2];
gleisb2[8,2,1]:=gleisb2[5,2,1];
gleisb2[8,2,2]:=gleisb2[5,2,2];


gleisb2[7,1,1]:=bgende*steigung-xoff+0.72;
gleisb2[7,1,2]:=bgende;
gleisb2[6,1,1]:=bgende*steigung-xoff+0.56;
gleisb2[6,1,2]:=bgende;
gleisb2[5,1,1]:=(laenge/2+1.5)*steigung-xoff+0.72;
gleisb2[5,1,2]:=laenge/2+1.5;
gleisb2[7,2,1]:=bgende*steigung-xoff+0.8;
gleisb2[7,2,2]:=bgende;
gleisb2[6,2,1]:=bgende*steigung-xoff+0.6;
gleisb2[6,2,2]:=bgende;
gleisb2[5,2,1]:=(laenge/2+1.5)*steigung-xoff+0.8;
gleisb2[5,2,2]:=laenge/2+1.5;

if (richtung=3) or (richtung=4) then
  begin
  gleisb2[6,1,1]:=gleisb2[6,1,1]+0.16;
  gleisb2[6,2,1]:=gleisb2[6,2,1]+0.16;
  end;

end;

procedure gleisbett;
begin

{Schwellen rechts}
schw1[1,1,1]:=1.35;
schw1[1,1,2]:=0;
for i:=0 to 5 do
  begin
  schw1[i+2,1,1]:=gleisr1[i,1]+0.55;
  schw1[i+2,1,2]:=gleisr1[i,2];
  end;
schw1[8,1,1]:=xoff+1.35;
schw1[8,1,2]:=laenge;

for i:=1 to 8 do
  begin
  schw1[i,2,2]:=schw1[i,1,2];
  schw1[i,2,1]:=schw1[i,1,2]*(xoff)/laenge-xoff/2;
  end;

{Schwellen links}
schw2[1,1,1]:=-xoff-1.35;
schw2[1,1,2]:=0;
schw2[2,1,1]:=-1.35;
schw2[2,1,2]:=laenge/2;
schw2[3,1,1]:=-1.35;
schw2[3,1,2]:=laenge;

for i:=1 to 3 do
  begin
  schw2[i,2,2]:=schw2[i,1,2];
  schw2[i,2,1]:=schw2[i,1,2]*(xoff)/laenge-xoff/2;
  end;

{Schotterbett rechts}
for i:=1 to 8 do
  begin
  schottr[i,1]:=schw1[i,1,1]+1.45;
  schottr[i,2]:=schw1[i,1,2];
  end;

{Schotterbett links}
for i:=1 to 3 do
  begin
  schottl[i,1]:=schw2[i,1,1]-1.45;
  schottl[i,2]:=schw2[i,1,2];
  end;



end;



procedure infos;
begin

p:=0;
i:=round(laenge);
while i>25 do
 begin
 i:=i-5;
 p:=p-5;
 end;

{Schreiben des Objektes}

if xoffchk<0 then
assign(f,'temp.txt')
else assign(f,dname);
rewrite(f);

if sprech='d' then
  begin
  writeln(f,';Datei automatisch erstellt von SWITCH - (C) 2002 Ruediger Huelsmann');
  writeln(f);
  writeln(f,';Kreuzungsdaten:');
  writeln(f,';Laenge: ',round(laenge));
  writeln(f,';X-Abweichung: ',xoffchk:3:3);
  write(f,';Abzweigradius: ');
  if radius<>999999 then
    writeln(f,radius:3:3)
    else
    writeln(f,'unendlich (geradeaus)');
  writeln(f,';Winkel: ',winkel:3:3);
  writeln(f,';Richtung: ', richtung);
  write(f,';Radlenker: ');
  if radlenk='n' then
    writeln(f,'nein')
    else
    writeln(f,'ja');
  write(f,';Oberleitung: ');
  if oberjn='n' then
    writeln(f,'nein')
    else
    writeln(f,'ja');
  if (oberjn<>'n') then
    begin
    writeln(f,';Hoehe Fahrdraht: ',oberfahr:3:3);
    writeln(f,';Hoehe Tragseil: ',obertrag:3:3);
    end;
  writeln(f);
  end

  else

  begin
  writeln(f,';File automatically generated by SWITCH - (C) 2002 Ruediger Huelsmann');
  writeln(f);
  writeln(f,';Crossing data:');
  writeln(f,';Length: ',round(laenge));
  writeln(f,';X-offset: ',xoffchk:3:3);
  write(f,';Turnout radius: ');
  if radius<>999999 then
    writeln(f,radius:3:3)
    else
    writeln(f,'infinite (straight)');
  writeln(f,';Angle: ', winkel:3:3);
  writeln(f,';Direction: ', richtung);
  write(f,';Guard rails: ');
  if radlenk='n' then
    writeln(f,'no')
    else
    writeln(f,'yes');
  write(f,';Overhead line: ');
  if oberjn='n' then
    writeln(f,'no')
    else
    writeln(f,'yes');
  if (oberjn<>'n') then
    begin
    writeln(f,';Height of contact wire: ',oberfahr:3:3);
    writeln(f,';Height of carrying rope: ',obertrag:3:3);
    end;
  end;
  writeln(f);

end;
procedure kreuzung2;
begin


{Gleis A, links:}
writeln(f,'[meshbuilder]');
for i:=0 to 8 do
  begin
  if gleisa1[i,1,1]<>999 then
    begin
    writeln(f,'vertex ',gleisa1[i,1,1]:3:3,',0,',gleisa1[i,1,2]+p:3:3);
    writeln(f,'vertex ',gleisa1[i,2,1]:3:3,',0,',gleisa1[i,2,2]+p:3:3);
    end;
  end;

a:=0;
for i:=0 to 7 do
  begin
  if (gleisa1[i+1,1,1]<>999) and (i<>1) and (i<>3) and (i<>6) then
    writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
    a:=a+2;
  end;
writeln(f,'color 180,190,200');

writeln(f);

{Gleis A, rechts:}
writeln(f,'[meshbuilder]');
for i:=0 to 8 do
  begin
  if gleisa2[i,1,1]<>999 then
    begin
    writeln(f,'vertex ',gleisa2[i,1,1]:3:3,',0,',gleisa2[i,1,2]+p:3:3);
    writeln(f,'vertex ',gleisa2[i,2,1]:3:3,',0,',gleisa2[i,2,2]+p:3:3);
    end;
  end;

a:=0;
for i:=0 to 7 do
  begin
  if (gleisa2[i+1,1,1]<>999) and (i<>1) and (i<>4) and (i<>6) then
    writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
    a:=a+2;
  end;
writeln(f,'color 180,190,200');

writeln(f);

{Gleis B, links:}
writeln(f,'[meshbuilder]');
for i:=0 to 8 do
  begin
  if gleisb1[i,1,1]<>999 then
    begin
    writeln(f,'vertex ',gleisb1[i,1,1]:3:3,',0,',gleisb1[i,1,2]+p:3:3);
    writeln(f,'vertex ',gleisb1[i,2,1]:3:3,',0,',gleisb1[i,2,2]+p:3:3);
    end;
  end;

a:=0;
for i:=0 to 7 do
  begin
  if (gleisb1[i+1,1,1]<>999) and (i<>1) and (i<>3) then
    writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
    a:=a+2;
  end;
writeln(f,'color 180,190,200');

writeln(f);

{Gleis B, rechts:}
writeln(f,'[meshbuilder]');
for i:=0 to 8 do
  begin
  if gleisb2[i,1,1]<>999 then
    begin
    writeln(f,'vertex ',gleisb2[i,1,1]:3:3,',0,',gleisb2[i,1,2]+p:3:3);
    writeln(f,'vertex ',gleisb2[i,2,1]:3:3,',0,',gleisb2[i,2,2]+p:3:3);
    end;
  end;

a:=0;
for i:=0 to 7 do
  begin
  if (gleisb2[i+1,1,1]<>999) and (i<>1) and (i<>3) and (i<>6) then
    writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
    a:=a+2;
  end;
writeln(f,'color 180,190,200');

writeln(f);

writeln(f,'[meshbuilder]');
for i:=1 to 8 do
writeln(f,'vertex ',fluegelsch[i,1]:3:3,',0,',fluegelsch[i,2]+p:3:3);
writeln(f,'face 0,1,2,3');

writeln(f,'face 4,5,6,7');

writeln(f,'color 85,50,50');

writeln(f,'[meshbuilder]');
for i:=9 to 16 do
writeln(f,'vertex ',fluegelsch[i,1]:3:3,',0,',fluegelsch[i,2]+p:3:3);
writeln(f,'face 0,1,2,3');

writeln(f,'face 4,5,6,7');

writeln(f,'color 85,50,50');

{Radlenker Mitte}
writeln(f,'[meshbuilder]');
for i:=1 to 5 do
  begin
  writeln(f,'vertex ',radlenk1[i,1,1]:3:3,',-0.01,',radlenk1[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk1[i,2,1]:3:3,',-0.01,',radlenk1[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 3 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

writeln(f,'[meshbuilder]');
for i:=1 to 5 do
  begin
  writeln(f,'vertex ',radlenk2[i,1,1]:3:3,',-0.01,',radlenk2[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk2[i,2,1]:3:3,',-0.01,',radlenk2[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 3 do
  begin
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

{Radlenker hinten rechts}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  begin
  writeln(f,'vertex ',radlenk3[i,1,1]:3:3,',0,',radlenk3[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk3[i,2,1]:3:3,',0,',radlenk3[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 2 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

{Radlenker hinten links}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  begin
  writeln(f,'vertex ',radlenk4[i,1,1]:3:3,',0,',radlenk4[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk4[i,2,1]:3:3,',0,',radlenk4[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 2 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

{Radlenker vorne links}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  begin
  writeln(f,'vertex ',radlenk5[i,1,1]:3:3,',0,',radlenk5[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk5[i,2,1]:3:3,',0,',radlenk5[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 2 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

{Radlenker vorne rechts}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  begin
  writeln(f,'vertex ',radlenk6[i,1,1]:3:3,',0,',radlenk6[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk6[i,2,1]:3:3,',0,',radlenk6[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 2 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);


{Abzweigendes Gleis}

writeln(f,'[meshbuilder]');
for i:=0 to 5 do
  begin
  writeln(f,'vertex ',gleisr2[i,1]:3:3,', 0, ',gleisr2[i,2]+p:3:3);
  writeln(f,'vertex ',gleisr1[i,1]:3:3,', 0, ',gleisr1[i,2]+p:3:3);
  end;
zaehl:=0;
for i:=0 to 4 do
  begin
  writeln(f,'face ',zaehl+2,', ',zaehl+3,', ',zaehl+1,', ',zaehl);
  zaehl:=zaehl+2;
  end;
writeln(f,'color 180,190,200');
writeln(f);

writeln(f,'[meshbuilder]');
for i:=0 to 5 do
  begin
  writeln(f,'vertex ',gleisr4[i,1]:3:3,', 0, ',gleisr4[i,2]+p:3:3);
  writeln(f,'vertex ',gleisr3[i,1]:3:3,', 0, ',gleisr3[i,2]+p:3:3);
  end;
zaehl:=0;
for i:=0 to 4 do
  begin
  writeln(f,'face ',zaehl+2,', ',zaehl+3,', ',zaehl+1,', ',zaehl);
  zaehl:=zaehl+2;
  end;
writeln(f,'color 180,190,200');
writeln(f);



{3D-Schienen:}
{Gleis A, links:}
writeln(f,'[meshbuilder]');
for i:=0 to 8 do
  begin
  if gleisa1[i,1,1]<>999 then
    begin
    if (i=2) or (i=4) or (i=6) then
      begin
      writeln(f,'vertex ',gleisa1[i,2,1]-0.04:3:3,',0,',gleisa1[i,2,2]+p:3:3);
      writeln(f,'vertex ',gleisa1[i,2,1]-0.04:3:3,',-0.17,',gleisa1[i,2,2]+p:3:3);
      end
    else
      begin
      writeln(f,'vertex ',gleisa1[i,1,1]+0.04:3:3,',0,',gleisa1[i,1,2]+p:3:3);
      writeln(f,'vertex ',gleisa1[i,1,1]+0.04:3:3,',-0.17,',gleisa1[i,1,2]+p:3:3);
      end;
    end;
  end;
a:=0;
for i:=0 to 7 do
  begin
  if (gleisa1[i+1,1,1]<>999) and (i<>1) and (i<>3) and (i<>6) then
    begin
      writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
      writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
    end;
    a:=a+2;
  end;
writeln(f,'color 85,50,50');
writeln(f);


{Gleis A, rechts:}
writeln(f,'[meshbuilder]');
for i:=0 to 8 do
  begin
  if gleisa2[i,1,1]<>999 then
    begin
    if (i=4) or (i=5) or (i=7) then
      begin
      writeln(f,'vertex ',gleisa2[i,2,1]-0.04:3:3,',0,',gleisa2[i,2,2]+p:3:3);
      writeln(f,'vertex ',gleisa2[i,2,1]-0.04:3:3,',-0.17,',gleisa2[i,2,2]+p:3:3);
      end
    else
    begin
      writeln(f,'vertex ',gleisa2[i,1,1]+0.04:3:3,',0,',gleisa2[i,1,2]+p:3:3);
      writeln(f,'vertex ',gleisa2[i,1,1]+0.04:3:3,',-0.17,',gleisa2[i,1,2]+p:3:3);
      end;
    end;
  end;

a:=0;
for i:=0 to 7 do
  begin
  if (gleisa2[i+1,1,1]<>999) and (i<>1) and (i<>4) and (i<>6) then
    begin
      writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
      writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
    end;
    a:=a+2;
  end;
writeln(f,'color 85,50,50');
writeln(f);

{Gleis B, links:}
writeln(f,'[meshbuilder]');
for i:=0 to 8 do
  begin
  if gleisb1[i,1,1]<>999 then
    begin
    if (i=1) or (i=3) then
      begin
      writeln(f,'vertex ',gleisb1[i,2,1]-0.04:3:3,',0,',gleisb1[i,2,2]+p:3:3);
      writeln(f,'vertex ',gleisb1[i,2,1]-0.04:3:3,',-0.17,',gleisb1[i,2,2]+p:3:3);
      end
    else
      begin
      writeln(f,'vertex ',gleisb1[i,1,1]+0.04:3:3,',0,',gleisb1[i,1,2]+p:3:3);
      writeln(f,'vertex ',gleisb1[i,1,1]+0.04:3:3,',-0.17,',gleisb1[i,1,2]+p:3:3);
      end;
    end;
  end;

a:=0;
for i:=0 to 7 do
  begin
  if (gleisb1[i+1,1,1]<>999) and (i<>1) and (i<>3) then
    begin
      writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
      writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
      end;
    a:=a+2;
  end;
writeln(f,'color 85,50,50');
writeln(f);



{Gleis B, rechts:}
writeln(f,'[meshbuilder]');
for i:=0 to 8 do
  begin
  if gleisb2[i,1,1]<>999 then
    begin
    if (i=1) or (i=3) then
      begin
      writeln(f,'vertex ',gleisb2[i,2,1]-0.04:3:3,',0,',gleisb2[i,2,2]+p:3:3);
      writeln(f,'vertex ',gleisb2[i,2,1]-0.04:3:3,',-0.17,',gleisb2[i,2,2]+p:3:3);
      end
    else
      begin
      writeln(f,'vertex ',gleisb2[i,1,1]+0.04:3:3,',0,',gleisb2[i,1,2]+p:3:3);
      writeln(f,'vertex ',gleisb2[i,1,1]+0.04:3:3,',-0.17,',gleisb2[i,1,2]+p:3:3);
      end;
    end;
  end;

a:=0;
for i:=0 to 7 do
  begin
  if (gleisb2[i+1,1,1]<>999) and (i<>1) and (i<>3) and (i<>6) then
    begin
      writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
      writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
    end;
    a:=a+2;
  end;
writeln(f,'color 85,50,50');
writeln(f);


{3D-FlÅgelschienen}
writeln(f,'[meshbuilder]');
writeln(f,'vertex ',fluegelsch[1,1]+0.04:3:3,',0,',fluegelsch[1,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[1,1]+0.04:3:3,',-0.17,',fluegelsch[1,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[4,1]+0.04:3:3,',0,',fluegelsch[4,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[4,1]+0.04:3:3,',-0.17,',fluegelsch[4,2]+p:3:3);

writeln(f,'vertex ',fluegelsch[6,1]-0.04:3:3,',0,',fluegelsch[6,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[6,1]-0.04:3:3,',-0.17,',fluegelsch[6,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[7,1]-0.04:3:3,',0,',fluegelsch[7,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[7,1]-0.04:3:3,',-0.17,',fluegelsch[7,2]+p:3:3);

writeln(f,'vertex ',fluegelsch[9,1]-0.04:3:3,',0,',fluegelsch[9,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[9,1]-0.04:3:3,',-0.17,',fluegelsch[9,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[12,1]-0.04:3:3,',0,',fluegelsch[12,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[12,1]-0.04:3:3,',-0.17,',fluegelsch[12,2]+p:3:3);

writeln(f,'vertex ',fluegelsch[14,1]+0.04:3:3,',0,',fluegelsch[14,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[14,1]+0.04:3:3,',-0.17,',fluegelsch[14,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[15,1]+0.04:3:3,',0,',fluegelsch[15,2]+p:3:3);
writeln(f,'vertex ',fluegelsch[15,1]+0.04:3:3,',-0.17,',fluegelsch[15,2]+p:3:3);

writeln(f,'face 0,2,3,1');
writeln(f,'face 1,3,2,0');
writeln(f,'face 4,6,7,5');
writeln(f,'face 5,7,6,4');
writeln(f,'face 8,10,11,9');
writeln(f,'face 9,11,10,8');
writeln(f,'face 12,14,15,13');
writeln(f,'face 13,15,14,12');
writeln(f,'color 85,50,50');

{3D-Schienen, abzweigendes Gleis rechts:}
writeln(f,'[meshbuilder]');
for i:=0 to 5 do
  begin
    writeln(f,'vertex ',gleisr1[i,1]-0.04:3:3,',0,',gleisr1[i,2]+p:3:3);
    writeln(f,'vertex ',gleisr1[i,1]-0.04:3:3,',-0.17,',gleisr1[i,2]+p:3:3);
  end;
a:=0;
for i:=1 to 5 do
begin
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');
writeln(f);

{3D-Schienen, abzweigendes Gleis links:}
writeln(f,'[meshbuilder]');
for i:=0 to 5 do
  begin
    writeln(f,'vertex ',gleisr3[i,1]-0.04:3:3,',0,',gleisr3[i,2]+p:3:3);
    writeln(f,'vertex ',gleisr3[i,1]-0.04:3:3,',-0.17,',gleisr3[i,2]+p:3:3);
  end;
a:=0;
for i:=1 to 5 do
begin
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');
writeln(f);



{3D-Radlenker Mitte}
writeln(f,'[meshbuilder]');
for i:=1 to 5 do
  begin
  writeln(f,'vertex ',radlenk1[i,1,1]:3:3,',-0.01,',radlenk1[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk1[i,1,1]:3:3,',-0.17,',radlenk1[i,1,2]+p:3:3);
  end;

a:=0;
for i:=0 to 3 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

writeln(f,'[meshbuilder]');
for i:=1 to 5 do
  begin
  writeln(f,'vertex ',radlenk2[i,1,1]:3:3,',-0.01,',radlenk2[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk2[i,1,1]:3:3,',-0.17,',radlenk2[i,1,2]+p:3:3);
  end;

a:=0;
for i:=0 to 3 do
  begin
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

{3D-Radlenker hinten rechts}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  begin
  writeln(f,'vertex ',radlenk3[i,2,1]:3:3,',0,',radlenk3[i,2,2]+p:3:3);
  writeln(f,'vertex ',radlenk3[i,2,1]:3:3,',-0.17,',radlenk3[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 2 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

{3D-Radlenker hinten links}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  begin
  writeln(f,'vertex ',radlenk4[i,1,1]:3:3,',0,',radlenk4[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk4[i,1,1]:3:3,',-0.17,',radlenk4[i,1,2]+p:3:3);
  end;

a:=0;
for i:=0 to 2 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

{3D-Radlenker vorne links}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  begin
  writeln(f,'vertex ',radlenk5[i,2,1]:3:3,',0,',radlenk5[i,2,2]+p:3:3);
  writeln(f,'vertex ',radlenk5[i,2,1]:3:3,',-0.17,',radlenk5[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 2 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

{3D-Radlenker vorne rechts}
writeln(f,'[meshbuilder]');
for i:=1 to 4 do
  begin
  writeln(f,'vertex ',radlenk6[i,1,1]:3:3,',0,',radlenk6[i,1,2]+p:3:3);
  writeln(f,'vertex ',radlenk6[i,1,1]:3:3,',-0.17,',radlenk6[i,1,2]+p:3:3);
  end;

a:=0;
for i:=0 to 2 do
  begin
  writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
  writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
  a:=a+2;
  end;
writeln(f,'color 85,50,50');

writeln(f);

                                        


end;
procedure gleisbett2;
begin

{Schwellen rechts:}
writeln(f,'[meshbuilder]');
for i:=1 to 8 do
  begin
  writeln(f,'vertex ',schw1[i,1,1]:3:3,',-0.17,',schw1[i,1,2]+p:3:3);
  writeln(f,'vertex ',schw1[i,2,1]:3:3,',-0.17,',schw1[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 6 do
  begin
    writeln(f,'face ',a,',',a+1,',',a+3,',',a+2);
    a:=a+2;
  end;
writeln(f,'[texture]');
writeln(f,'load weiche1b.bmp');
a:=0;
b:=round(laenge/2.5);
for i:=0 to 7 do
  begin
  writeln(f,'coordinates ',a,',1.005,',b-schw1[i+1,1,2]/2.5:3:3);
  writeln(f,'coordinates ',a+1,',',0.995-((schw1[i+1,1,1]-schw1[i+1,2,1])/5.4):3:3,',',b-schw1[i+1,1,2]/2.5:3:3);
  a:=a+2;
  end;

writeln(f);

{Schwellen links:}
writeln(f,'[meshbuilder]');
for i:=1 to 3 do
  begin
  writeln(f,'vertex ',schw2[i,1,1]:3:3,',-0.17,',schw2[i,1,2]+p:3:3);
  writeln(f,'vertex ',schw2[i,2,1]:3:3,',-0.17,',schw2[i,2,2]+p:3:3);
  end;

a:=0;
for i:=0 to 1 do
  begin
    writeln(f,'face ',a+2,',',a+3,',',a+1,',',a);
    a:=a+2;
  end;
writeln(f,'[texture]');
writeln(f,'load weiche1b.bmp');
a:=0;
b:=round(laenge/2.5);
for i:=0 to 2 do
  begin
  writeln(f,'coordinates ',a,',1.005,',b-schw2[i+1,1,2]/2.5:3:3);
  writeln(f,'coordinates ',a+1,',',0.995+((schw2[i+1,1,1]-schw2[i+1,2,1])/5.4):3:3,',',b-schw2[i+1,1,2]/2.5:3:3);
  a:=a+2;
  end;

writeln(f);

{Schotterbett rechts}
writeln(f,'[meshbuilder]');
for i:=1 to 8 do
  begin
  writeln(f,'vertex ',schw1[i,1,1]:3:3,', -0.17, ',schw1[i,1,2]+p:3:3);
  writeln(f,'vertex ',schottr[i,1]:3:3,', -0.4, ',schottr[i,2]+p:3:3);
  end;
a:=0;

for i:=0 to 6 do
  begin
  writeln(f,'face ',a+1,',',a,',',a+2,',',a+3);
  a:=a+2;
  end;
writeln(f,'[texture]');
writeln(f,'load schotter1.bmp');
a:=0;
j:=0;
b:=round(laenge/2.5);
for i:=0 to 7 do
  begin
  writeln(f,'coordinates ',a,',',b-schw1[i+1,1,2]/2.5:3:3,',0');
  a:=a+1;
  writeln(f,'coordinates ',a,',',b-schw1[i+1,1,2]/2.5:3:3,',1');
  j:=j+2;
  a:=a+1;
  end;
writeln(f);

{Schotterbett links}

writeln(f,'[meshbuilder]');
for i:=1 to 3 do
  begin
  writeln(f,'vertex ',schw2[i,1,1]:3:3,', -0.17, ',schw2[i,1,2]+p:3:3);
  writeln(f,'vertex ',schottl[i,1]:3:3,', -0.4, ',schottl[i,2]+p:3:3);
  end;
a:=0;

for i:=0 to 1 do
  begin
  writeln(f,'face ',a+3,',',a+2,',',a,',',a+1);
  a:=a+2;
  end;
writeln(f,'[texture]');
writeln(f,'load schotter1.bmp');
a:=0;
j:=0;
b:=round(laenge/2.5);
for i:=0 to 2 do
  begin
  writeln(f,'coordinates ',a,',',b-schw2[i+1,1,2]/2.5:3:3,',0');
  a:=a+1;
  writeln(f,'coordinates ',a,',',b-schw2[i+1,1,2]/2.5:3:3,',1');
  j:=j+2;
  a:=a+1;
  end;
writeln(f);

{Oberleitung}
if (oberjn='j')or (oberjn='y') then
  begin

  if sprech='d' then
  writeln(f,';Oberleitung:')
  else
  writeln(f,';Overhead line:');

  for i:=0 to round(laenge/5) do
    oberaufh[i]:=(2*xoff/laenge)*i*5-xoff;

  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex ',-xoff-0.02:3:3,', ', oberfahr:3:3, ', ',p:3:3);
  writeln(f, 'vertex ',-xoff+0.02:3:3,', ', oberfahr:3:3, ', ',p:3:3);
  writeln(f, 'vertex ',xoff+0.02:3:3, ', ', oberfahr:3:3, ', ', round(laenge)+p:3:3);
  writeln(f, 'vertex ',xoff-0.02:3:3, ', ', oberfahr:3:3, ', ', round(laenge)+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'color 0,0,0');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex ',-xoff-0.01:3:3,', ', obertrag:3:3, ', ',p:3:3);
  writeln(f, 'vertex ',-xoff+0.01:3:3,', ', obertrag:3:3, ', ',p:3:3);
  writeln(f, 'vertex ',xoff+0.01:3:3, ', ', obertrag:3:3, ', ', round(laenge)+p:3:3);
  writeln(f, 'vertex ',xoff-0.01:3:3, ', ', obertrag:3:3, ', ', round(laenge)+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'color 0,0,0');
  writeln(f);

  for i:=0 to round(laenge/5) do
    begin
    writeln(f,'[meshbuilder]');
    writeln(f, 'vertex ',oberaufh[i]-0.01:3:3, ', ', obertrag:3:3, ', ', i*5+p:3:3);
    writeln(f, 'vertex ',oberaufh[i]+0.01:3:3, ', ', obertrag:3:3, ', ', i*5+p:3:3);
    writeln(f, 'vertex ',oberaufh[i]+0.01:3:3, ', ', oberfahr:3:3, ', ', i*5+p:3:3);
    writeln(f, 'vertex ',oberaufh[i]-0.01:3:3, ', ', oberfahr:3:3, ', ', i*5+p:3:3);
    writeln(f, 'face 0,1,2,3');
    writeln(f,'color 0,0,0');
    end;

    writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex ',-0.02:3:3,', ', oberfahr:3:3, ', ',p:3:3);
  writeln(f, 'vertex ',0.02:3:3,', ', oberfahr:3:3, ', ',p:3:3);
  writeln(f, 'vertex ',0.02:3:3, ', ', oberfahr:3:3, ', ', round(laenge)+p:3:3);
  writeln(f, 'vertex ',-0.02:3:3, ', ', oberfahr:3:3, ', ', round(laenge)+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'color 0,0,0');
  writeln(f);
  writeln(f,'[meshbuilder]');
  writeln(f,'vertex ',-0.01:3:3,', ', obertrag:3:3, ', ',p:3:3);
  writeln(f, 'vertex ',0.01:3:3,', ', obertrag:3:3, ', ',p:3:3);
  writeln(f, 'vertex ',0.01:3:3, ', ', obertrag:3:3, ', ', round(laenge)+p:3:3);
  writeln(f, 'vertex ',-0.01:3:3, ', ', obertrag:3:3, ', ', round(laenge)+p:3:3);
  writeln(f,'face 0,1,2,3');
  writeln(f,'color 0,0,0');
  writeln(f);

  for i:=0 to round(laenge/5) do
    oberaufh[i]:=0;

  for i:=0 to round(laenge/5) do
    begin
    writeln(f,'[meshbuilder]');
    writeln(f, 'vertex ',oberaufh[i]-0.01:3:3, ', ', obertrag:3:3, ', ', i*5+p:3:3);
    writeln(f, 'vertex ',oberaufh[i]+0.01:3:3, ', ', obertrag:3:3, ', ', i*5+p:3:3);
    writeln(f, 'vertex ',oberaufh[i]+0.01:3:3, ', ', oberfahr:3:3, ', ', i*5+p:3:3);
    writeln(f, 'vertex ',oberaufh[i]-0.01:3:3, ', ', oberfahr:3:3, ', ', i*5+p:3:3);
    writeln(f, 'face 0,1,2,3');
    writeln(f,'color 0,0,0');
    end;

end;


close(f);

end;




end.