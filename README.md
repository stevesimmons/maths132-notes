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


Note: All email addresses, phone numbers etc were current 25 years ago and are long dead. Melbourne University no longer uses the `mu.oz.au` domain. My `015` phone number was on the old Australian analogue network, which was turned off around 15 years ago.