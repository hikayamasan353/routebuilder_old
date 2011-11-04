unit uRBPoint;

interface

uses sysutils, types, classes, uGlobaldef, uTools,
     math;

const
    TouchNearDistance = 2;
type
    TRBPoint = class
                 public
                 point: TDoublePoint;
                 height: double;
                 id: longint;
                 secondary,turned: boolean;
                 constructor Create(const p: TDoublePoint; _height: double=0; _sec: boolean=false); overload;
                 constructor Create(const p: TRBPoint); overload;
                 constructor CreateFromCommaString(const s: string);
                 function GetAsString(): string;
                 function isNear(p: TDoublePoint; zoom: integer): boolean;
                 procedure Move(xoffset,yoffset,vert: double);
                 procedure Scale(f: double);
                 procedure Turn(turnpoint: TDoublePoint; angle: double);
                 class procedure BezierValue(P1,P2,HP1,HP2:TRBPoint; t,k:double; var PNew: TDoublePoint; var HNew: double);
                 class procedure Interpolate(P1,P2: TRBPoint; t: double; var PNew: TDoublePoint; var HNew: double);
                 class procedure CurveValue(P1,P2,HP1,HP2:TRBPoint; t:double; var PNew: TDoublePoint; var HNew: double);
               end;

implementation

constructor TRBPoint.Create(const p: TDoublePoint; _height: double; _sec: boolean);
begin
  point := p;
  height := _height;
  id    := 0;
  secondary := _sec;
end;

constructor TRBPoint.Create(const p: TRBPoint);
begin
  point := p.point;
  height := p.height;
  id := 0;
  secondary := p.secondary;
end;

constructor TRBPoint.CreateFromCommaString(const s: string);
begin
  Create(doublepoint( strtofloat1(StrGetToken(s,',',2)),strtofloat1(StrGetToken(s,',',3))),strtofloat1(StrGetToken(s,',',4)));
  id := strtointdef(StrGetToken(s,',',1),0);
end;


function TRBPoint.GetAsString: string;
begin
  result := inttostr(id) + ',' + floattostrpoint(point.x) + ',' + floattostrpoint(point.y)+','+
    floattostrpoint(height);
end;

function TRBPoint.isNear(p: TDoublePoint; zoom: integer): boolean;
begin
  result := (sqr(p.x-point.x)+sqr(p.Y-point.y)  <=  sqr(TouchNearDistance*5/zoom));
end;

class procedure TRBPoint.CurveValue(P1,P2,HP1,HP2:TRBPoint; t:double; var PNew: TDoublePoint; var HNew: double);
var perp1,perp2,cent: TDoublePoint;
    rad1,rad2,rad,
    alpha,beta,gamma: double;
begin
  Perpendicular(P1.point,HP1.point,1,perp1);
  Perpendicular(P2.point,HP2.point,1,perp2);
  if Intersection(P1.point,perp1,P2.point,perp2,cent,true) then
  begin
    // bestimme Radien und mittleren Radius
    rad1 := Distance(p1.point,cent);
    rad2 := Distance(p2.point,cent);
    rad := rad1+(tanh((t-0.5)*cHyperbolCurveConst)/2+0.5)*(rad2-rad1);
//    rad  := rad1+t*(rad2-rad1);
    // bestimme Winkel
    alpha := angle(HP1.point,P1.point);
    beta  := angle(p2.point,HP2.point);
    if(abs(alpha-beta)>150) then
    begin
      alpha := angle(P1.point,HP1.point)+180;
      beta  := angle(HP2.point,P2.point)+180;
    end;

    gamma := alpha+t*(beta-alpha);
    // berechne neuen Punkt
    PNew.x := cent.x-rad*sin(gamma*pi/180)*sgn(_last_intersection_i);
    PNew.y := cent.y+rad*cos(gamma*pi/180)*sgn(_last_intersection_i);
//    PNew := cent;
  end
  else
  begin
    PNew.x := P1.point.x + t*(P2.point.x-P1.point.x);
    PNew.y := P1.point.y + t*(P2.point.y-P1.point.y);
  end;
  HNew   := P1.height + t*(P2.height-P1.height);
end;

class procedure TRBPoint.BezierValue(P1,P2,HP1,HP2:TRBPoint; t,k:double; var PNew: TDoublePoint; var HNew: double);
var t_sq,t_cb,r1,r2,r3,r4,k1,k2:double;
    HP1a,HP2a: TDoublePoint;
begin
   k1 := Distance(P1.point,HP1.point)*k*cBezierHelpPointDistance;
   HP1a.x := ((P1.point.X-HP1.point.X)/k1 +P1.point.X);
   HP1a.y := ((P1.point.y-HP1.point.y)/k1 +P1.point.y);

   k2 := Distance(P2.point,HP2.point)*k*cBezierHelpPointDistance;
   HP2a.x := ((P2.point.X-HP2.point.X)/k2 +P2.point.X);
   HP2a.y := ((P2.point.y-HP2.point.y)/k2 +P2.point.y);

   t_sq := t * t;
   t_cb := t * t_sq;
   r1 := (1 - 3*t + 3*t_sq -   t_cb)*P1.point.X;
   r2 := (    3*t - 6*t_sq + 3*t_cb)*(HP1a.X{-P1.cosl(25)});
   r3 := (          3*t_sq - 3*t_cb)*(HP2a.X{+P2.cosl(25)});
   r4 := (                     t_cb)*P2.point.X;
   PNew.X  := (r1 + r2 + r3 + r4);
   r1 := (1 - 3*t + 3*t_sq -   t_cb)*P1.point.Y;
   r2 := (    3*t - 6*t_sq + 3*t_cb)*(HP1a.Y{+P1.sinl(25)});
   r3 := (          3*t_sq - 3*t_cb)*(HP2a.Y{-P2.sinl(25)});
   r4 := (                     t_cb)*P2.point.Y;
   PNew.Y  := (r1 + r2 + r3 + r4);

   HNew   := P1.height + t*(P2.height-P1.height);

end;

// berechne Punkt auf der Linie zwischen P1 und P2 (t=0..1, 0.5 ist genau in der Mitte)
class procedure TRBPoint.Interpolate(P1,P2: TRBPoint; t: double; var PNew: TDoublePoint; var HNew: double);
begin
  PNew.x := P1.point.x + t*(P2.point.x-P1.point.x);
  PNew.y := P1.point.y + t*(P2.point.y-P1.point.y);
  HNew   := P1.height + t*(P2.height-P1.height);
end;

procedure TRBPoint.Move(xoffset,yoffset,vert: double);
begin
  point.x := point.x + xoffset;
  point.y := point.y + yoffset;
  height := height + vert;
end;

procedure TRBPoint.Scale(f: double);
begin
  point.x := point.x * f;
  point.y := point.y * f;
end;

procedure TRBPoint.Turn(turnpoint: TDoublePoint; angle: double);
var cosa,sina,px,py,px2,py2: double;
begin
  cosa := cos(angle*pi/180);
  sina := sin(angle*pi/180);
  px := point.x-turnpoint.x;
  py := point.y-turnpoint.y;
  px2 := +cosa*px+sina*py;
  py2 := -sina*px+cosa*py;
  point.x := px2+turnpoint.x;
  point.y := py2+turnpoint.y;
  turned := true;
end;

end.
