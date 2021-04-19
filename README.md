# Lecture notes for Maths 132

I wrote these lecture notes in 1995-96 for Lee White's course on Differential Equations, taught to first year maths students at the University of Melbourne.

The notes are written in LaTeX, with most diagrams using the PSTricks macro package.

The final chapter, Chapter 7, on Non-Linear Coupled ODEs, is notable because the phase portrait diagrams are programmed directly in PostScript. The header file `phasport.pro` defines the PS function `cls` (for "coupled linear systems") taking 8 parameters:
> ` cls: dt a b c d n x0 y0`
giving the time step size `dt`, the 2x2 matrix `(a, b; c, d)`, a number of segments `n` and a starting position `(x0, y0)`.

This was used via my `\zphaseportrait` LaTeX macro:

```latex
\zphaseportrait{
      clsinit 0.02 0 2 2 0
      50 0.5 0.5 cls    50 -0.5 0.5 cls    50 0.5 -0.5 cls    50 -0.5 -0.5 cls 
      80 0 0.4 cls	80 0 0.8 cls	   80 0 -0.8 cls      80 0 -0.4 cls
      80 0.4 0 cls	80 0.8 0 cls	   80 -0.8 0 cls      80 -0.4 0 cls
      80 0 1.2 cls	80 0 -1.2 cls	   80 1.2 0 cls	      80 -1.2 0 cls}{
}
```

You can see the result on the final page of the PDF output `notes.pdf`.

The PS code in `phasport.pro` is here, annotated with comments so I could keep track of my variables on top of the PS stack :

```postscript
% Routines for drawing phase portraits of coupled linear systems
% Given the linear 2D coupled system dY/dt = AY, the phase portrait
% may be drawn by using
% 	clsinit			% initialise the clipping window
%	sl a b c d		% sl = segment length, [a b; c d] = A
%	ns x y cls		% ns = number of segments, (x,y) = origin
% 	...	
%	ns x y cls		% ns = number of segments, (x,y) = origin
%	clsend			% clean up stack
% Note that the origin (x,y) of each trajectory is the point at which the
% arrow head is drawn.  The line is drawn ns segments forward and backward in 
% time from this point.
%
% Copyright 1995-96  Stephen Simmons		simmons@ee.mu.oz.au

% 9-Feb-1996 SS: Modified to extend clipping box from (-1.2,1.2) to (-1.5,1.5)

/clsDict 10 dict def clsDict begin 

% Initialise
% clsinit: --
/clsinit { %0.6 setgray 0 setlinewidth
	% Set the clipping path to the box from (-1.5,-1.5) to (1.5,1.5)
	newpath -1.5 -1.5 moveto 0 3 rlineto 3 0 rlineto 0 -3 rlineto 
	closepath clip
} def

% pairmul: a b x y -- ax by
/pairmul { 3 -1 roll mul 3 1 roll mul exch } def

% pairsub: a b x y -- a-x b-y
/pairsub { 3 -1 roll sub neg 3 1 roll sub exch } def

% pairadd: a b x y -- a+x b+y
/pairadd { 3 -1 roll add 3 1 roll add exch } def

% Draw 2D coupled linear system 
% x'=ax+by   y'=cx+dy
% clsiterate: dt a b c d x y -- dt a b c d x+dx y+dy
/clsiterate {
	7 copy 2 copy 		% -- dt a b c d x y dt a b c d x y x y 
	6 2 roll		% -- dt a b c d x y dt a b x y c d x y  
	pairmul			% -- dt a b c d x y dt a b x y cx dy
	add 5 1 roll		% -- dt a b c d x y dt cx+dy a b x y  
	pairmul add exch	% -- dt a b c d x y dt ax+by cx+dy
	2 copy 2 copy pairmul	% -- dt a b c d x y dt dx dy dx^2 dy^2
	add sqrt  		% -- dt a b c d x y dt dx dy dr
	4 -1 roll   		% -- dt a b c d x y dx dy dr dt
	exch div   		% -- dt a b c d x y dx dy dd
	dup pairmul  		% -- dt a b c d x y dx dy dd
	pairadd			% -- dt a b c d x1 y1
} def

% Draw a line forwards in time from the specified starting point
% clsloop: dt a b c d n x0 y0 -- dt a b c d 
/clsloop {
	2 copy newpath moveto 	% -- dt a b c d n x0 y0
 	1 1 			% -- dt a b c d n x0 y0 1 1 
	5 -1 roll 		% -- dt a b c d x0 y0 1 1 n
	{pop clsiterate 	% -- dt a b c d x y
	 2 copy 2 copy pairmul  % -- dt a b c d x y x^2 y^2
	 add 25 gt {exit} if    % -- dt a b c d x y
	 2 copy lineto} for	% -- dt a b c d x y
  	stroke
	pop pop
} def

% Draw an arrow 
% clsarrow: x1 y1 x0 y0 -- 
/clsarrow {
	gsave
	2 copy translate	% -- x1 y1 x0 y0
	newpath pairsub		% -- x1-x0 y1-y0
	exch atan rotate	% --
	0.12 0 moveto -0.2 0.08 rlineto 0 -0.16 rlineto 0.2 0.08 rlineto
	closepath fill
	grestore
} def

% Draw a line forwards and backwards in time with an arrow in the middle
% cls: dt a b c d n x0 y0 -- dt a b c d
/cls {
	3 copy 11 3 roll 	% -- n x0 y0 dt a b c d n x0 y0	
	clsloop			% -- n x0 y0 dt a b c d
	8 4 roll 4 copy		% -- a b c d n x0 y0 dt n x0 y0 dt
	12 4 roll neg		% -- n x0 y0 dt a b c d n x0 y0 -dt
	8 1 roll		% -- n x0 y0 dt -dt a b c d n x0 y0
	clsloop			% -- n x0 y0 dt -dt a b c d 
	5 -1 roll pop	 	% -- n x0 y0 dt a b c d 
 	7 copy clsend		% -- n x0 y0 dt a b c d x0 y0
	clsiterate		% -- n x0 y0 dt a b c d x1 y1
	10 -3 roll		% -- dt a b c d x1 y1 n x0 y0
	3 -1 roll pop		% -- dt a b c d x1 y1 x0 y0
	clsarrow		% -- dt a b c d
} def 

% Remove things from the stack at the end
% clsend: dt a b c d --
/clsend { pop pop pop pop pop } def

end % clsDict
```

### Note

All email addresses, phone numbers etc were current 25 years ago and are long dead. Melbourne University no longer uses the `mu.oz.au` domain. My `015` phone number was on the old Australian analogue network, which was turned off around 15 years ago.