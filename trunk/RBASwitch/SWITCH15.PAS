program switch5;
uses crt, bogen, switch1,dkweiche,ekreuz,ekreuzw;
var waswillstdu:integer;
    nochmal:char;

begin
clrscr;
writeln;
writeln;
textcolor(lightblue);
writeln('      ‹€€€€€€‹   ﬂ€€ﬂ    ﬂ€€ﬂ   ﬂ€€ﬂ   €€€€€€€€€€   ‹€€€€€€‹   ﬂ€€ﬂ    ﬂ€€ﬂ');
writeln('     €€      ﬂ    €€      €€     €€    ﬂ   €€   ﬂ   €€     ﬂ    €€      €€');
writeln('     €€           €€      €€     €€        €€       €€          €€      €€');
writeln('     ﬂ€€€€€€€‹    €€  €€  €€     €€        €€       €€          €€€€€€€€€€');
writeln('            €€    €€  €€  €€     €€        €€       €€          €€      €€');
writeln('     ‹      €€    €€  €€  €€     €€        €€       €€     ‹    €€      €€');
writeln('     ﬂ€€€€€€€ﬂ    ﬂ€€€ﬂﬂ€€€ﬂ    ‹€€‹       €€       ﬂ€€€€€€ﬂ   ‹€€‹    ‹€€‹');
writeln;
textcolor(lightgray);
writeln('===============================================================================');          
textcolor(lightblue);
writeln('                         Version 1.5 - 08.05.2002                   ');
writeln;
writeln('                           (c) 2002 RÅdiger HÅlsmann               ');
writeln;
writeln('                    http://home.t-online.de/home/r.hulsmann        ');
textcolor(lightgray);
writeln('===============================================================================');          
writeln;
repeat;
writeln('Sprache/language ("d"=Deutsch/"e"=English):');
readln(sprache);
if (sprache<>'e') and (sprache<>'d') then
  writeln('Bitte wÑhlen Sie "d" oder "e". Please choose "e" or "d".');
  writeln;
until (sprache='e') or (sprache='d');
language:=sprache;
langue:=sprache;
langage:=sprache;
lingo:=sprache;

repeat;
repeat;
clrscr;
if sprache='d' then
  begin
  writeln('Was mîchten Sie erstellen?');
  writeln;
  writeln('1. Weiche');
  writeln('2. Bogen');
  writeln('3. Kreuzung');
  writeln('4. Einfache Kreuzungsweiche');
  writeln('5. Doppelte Kreuzungsweiche');
  writeln;
  writeln('6. Programm beenden');
  end
  else
  begin
  writeln('What would you like to create?');
  writeln;
  writeln('1. Switch');
  writeln('2. Curve');
  writeln('3. Crossing');
  writeln('4. Single slip switch');
  writeln('5. Double slip switch');
  writeln;
  writeln('6. Exit program');
  end;
readln(waswillstdu);
until (waswillstdu>=1) or (waswillstdu<=6);

if waswillstdu=1 then
  begin

begin
ma:=0;
me:=0;
herz:=2;
clrscr;
repeat;
  if sprache='d' then
  writeln('Bitte WeichenlÑnge eingeben (in Metern):')
  else
  writeln('Please enter the length of the switch (in meters):');
  readln(laenge);
  if frac(laenge/5)<>0 then
  if sprache='d' then
  writeln('Die LÑnge muss ein Produkt von 5 sein.')
  else
  writeln('The length has to be a product of 5.');
  writeln;
  until frac(laenge/5)=0;

if sprache='d' then
writeln('Bitte X-Abweichung des rechten Stranges eingeben ("-"=links, "0"=gerade, in m):')
else
writeln('Please enter x-offset of the right branch ("-"=left, "0"=straight, in m):');
readln(xdev2);
writeln;

repeat;
if sprache='d' then
writeln('Bitte X-Abweichung des linken Stranges eingeben ("-"=links, "0"=gerade, in m):')
else
writeln('Please enter x-offset of the left branch ("-"=left, "0"=straight, in m):');
readln(xdev1);
if xdev1>=xdev2 then
begin
writeln;
if sprache='d' then
writeln('Die Abweichung des linken Stranges muss geringer sein als die des rechten.')
else
writeln('The left branch must have a lower x-offset than the right one.');

end;
writeln;
until xdev1<xdev2;

repeat;
if sprache='d' then
writeln('Welcher Fahrweg ("r"=rechts, "l"=links) ?')
else
writeln('Which direction of travel ("r"=right, "l"=left) ?');

readln(richtung);
if (richtung<>'r') and (richtung<>'l') then
begin
writeln;
if sprache='d' then
writeln('Wie bitte? Rechts oder links?')
else
writeln('Pardon? Right or left?');
end;
writeln;
until (richtung='r') or (richtung='l');

repeat;
if sprache='d' then
writeln('Soll die Weiche Åber Radlenker verfÅgen (j/n)?')
else
writeln('Shall the switch have guard rails (y/n)?');

readln(radlenk);
if (radlenk<>'j') and (radlenk<>'y') and (radlenk<>'n') then
begin
writeln;
if sprache='d' then
writeln('Wie bitte? Ja oder nein?')
else
writeln('Pardon? Yes or no?');
end;
writeln;
until (radlenk='j') or (radlenk='y') or (radlenk='n');



{AusgleichsstÅcke}

if (laenge<>25) and (laenge<>50) and (laenge<>75) and (laenge<>100) then
  begin
  if sprache='d' then
  writeln('Die Weiche passt mit ',round(laenge),'m LÑnge nicht ins 25m-Raster.')
  else
  writeln('With a length of ',round(laenge),'m, the switch does not fit into the raster.');
  i:=0;
  while i*25<round(laenge) do
    i:=i+1;
  j:=round(i*25-round(laenge));
  repeat;
  if sprache='d' then
    begin
    writeln('Bis zum nÑchsten 25m-Abschnitt stehen noch ',j,'m zur VerfÅgung.');
    writeln('Mîchten Sie diese jetzt hinzufÅgen (j/n)? Hîhere Werte sind ebenfalls mîglich.');
    end else
    begin
    writeln('There are still ',j,'m available up to the next 25m-section.');
    writeln('Do you want to add them now (y/n)? Higher values are also possible.');
    end;
  readln(janein);
  if (janein<>'j') and (janein<>'n') and (janein<>'y') then
  begin
  writeln;
  if sprache='d' then
  writeln('Wie bitte? Ja oder nein?')
  else
  writeln('Pardon? Yes or no?');
  writeln;
  end;
  until (janein='j') or (janein='y') or (janein='n');
  writeln;

  if (janein='j') or (janein='y') then
    begin
    if (xdev1=0) or (xdev2=0) then
      begin
      repeat;
      if sprache='d' then
      writeln('Wieviele Meter sollen am Ende der Weiche hinzugefÅgt werden (5er-Schritte)?')
      else
      writeln('How many meters shall be added at the end of the switch (5m-steps)?');

      readln(me);
      if frac(me/5)<>0 then
        if sprache='d' then
        writeln('Die LÑnge muss ein Produkt von 5 sein.')
        else
        writeln('The length has to be a product of 5.');
      writeln;
      until frac(me/5)=0;
      end
      else
      me:=0;

    repeat;
    if sprache='d' then
    writeln('Wieviele Meter sollen am Anfang der Weiche hinzugefÅgt werden (5er-Schritte)?')
    else
    writeln('How many meters shall be added at the beginning of the switch (5m-steps)?');
    readln(ma);
    if frac(ma/5)<>0 then
     if sprache='d' then
      writeln('Die LÑnge muss ein Produkt von 5 sein.')
      else
      writeln('The length has to be a product of 5.');
    writeln;
    until frac(ma/5)=0;
    end;
  end;

repeat;
if sprache='d' then
writeln('Soll der rechte Strang eine Oberleitung besitzen (j/n)?')
else
writeln('Shall the right branch have an overhead line (y/n)?');
readln(oberrjn);
if (oberrjn<>'j') and (oberrjn<>'y') and (oberrjn<>'n') then
  begin
  writeln;
  if sprache='d' then
  writeln('Wie bitte? Ja oder nein?')
  else
  write('Pardon? Yes or no?');
  writeln;
  end;
  until (oberrjn='j') or (oberrjn='y') or (oberrjn='n');
  writeln;

repeat;
if sprache='d' then
writeln('Soll der linke Strang eine Oberleitung besitzen (j/n)?')
else
writeln('Shall the left branch have an overhead line (y/n) ?');
readln(oberljn);
if (oberljn<>'j') and(oberljn<>'y') and (oberljn<>'n') then
  begin
  writeln;
  if sprache='d' then
  writeln('Wie bitte? Ja oder nein?')
  else
  writeln('Pardon? Yes or no?');
  writeln;
  end;
  until (oberljn='j') or (oberljn='y') or (oberljn='n');
  writeln;

if (oberrjn='j') or (oberljn='j') or (oberrjn='y') or (oberljn='y') then
  begin
  repeat;
  if sprache='d' then
  writeln('Geben Sie bitte die Hîhe des Fahrdrahtes ein (Standard 6m):')
  else
    writeln('Please enter the height of the contact wire (standard 6m):');
  readln(oberfahr);
  if oberfahr<4.5 then
    if sprache='d' then
    writeln('Das dÅrfte ein wenig eng werden. Der Wert muss zwischen 4.5 und 7 m liegen.')
    else
    writeln('This might be a little low. The value has to bee between 4.5 and 7 meters.');

  if oberfahr>7 then
    if sprache='d' then
    writeln('Das dÅrfte zu hoch sein. Der Wert muss zwischen 4.5 und 7 m liegen.')
    else
   writeln('This might be too high. The value has to be between 4.5 and 7 meters.');

  writeln;
  until (oberfahr>4.5) and (oberfahr<7);

  repeat;
  if sprache='d' then
  writeln('Geben Sie bitte die Hîhe des Tragseils ein (Standard 7m):')
  else
  writeln('Please enter the height of the carrying rope (standard 7m:');
  readln(obertrag);
  if obertrag<oberfahr then
    if sprache='d' then
    writeln('Das Tragseil muss oberhalb des Fahrdrahtes liegen.')
    else
    writeln('The carrying rope must be above the contact wire.');
  writeln;
  until oberfahr<obertrag;
  end;

if sprache='d' then
writeln('Bitte geben Sie einen Dateinamen ein (max. 8 Zeichen, ohne Endung):')
else
writeln('Please enter a file name (max. 8 characters, without extension):');
readln(filename);
filename:=concat(filename,'.b3d');

  berechnen;
  schreiben1;
  schreiben2;
  clrscr;
  if sprache='d' then
    writeln('Fertig.')
    else
    writeln('Done.');
end;

end;
if waswillstdu=2 then
  begin
  curve;
  clrscr;
  if sprache='d' then
    writeln('Fertig.')
    else
    writeln('Done.');
  end;


  if waswillstdu=3 then
  begin
  createek;
  clrscr;
  if sprache='d' then
    writeln('Fertig.')
    else
    writeln('Done.');
  end;

if waswillstdu=4 then
  begin
  createekw;
  clrscr;
  if sprache='d' then
    writeln('Fertig.')
    else
    writeln('Done.');
  end;

if waswillstdu=5 then
  begin
  createdkw;
  clrscr;
  if sprache='d' then
    writeln('Fertig.')
    else
    writeln('Done.');
  end;


if waswillstdu<>6 then
begin
writeln;
repeat;
if sprache='d' then
  writeln('Ein weiteres Objekt erstellen (j/n)?')
  else
  writeln('Create another object (y/n)?');
  readln(nochmal);
  if (nochmal<>'j') and(nochmal<>'y') and (nochmal<>'n') then
  begin
  writeln;
  if sprache='d' then
  writeln('Wie bitte? Ja oder nein?')
  else
  writeln('Pardon? Yes or no?');
  writeln;
  end;
  until (nochmal='j') or (nochmal='y') or (nochmal='n');
  if nochmal='n' then waswillstdu:=6;
end;

until waswillstdu=6;  



end.