b-responsive-theme
====================

The lastest version of the code is available at the site:
 http://github.com/tekbasse/b-responsive-theme

introduction
------------

This is a theme package used by OpenACS web app platform.
It's designed to make OpenACS sites viewable by small device users as well as desktop users.
An emphasis is placed on using only css defined in the stylesheet as
well as hooking with any hardcoded styles released with openacs-core.

license
-------
Copyright (c) 2015 Benjamin Brink
po box 20, Marylhurst, OR 97036-0020 usa
email: tekbasse@yahoo.com

OpenACS default theme parts are 
Copyright (c) Don Baccus and other contributors to OpenACS's openacs-default-theme

Extra Strength Responsive Grid parts are 
Copyright (c) 2013 John Polacek under Dual MIT & GPL license

b-responsive-theme is open source and published under the GNU General Public License, 
consistent with the OpenACS system: http://www.gnu.org/licenses/gpl.html
A local copy is available at b-responsive-theme/www/doc/LICENSE.html

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

features
--------

This package is a blend of Extra Strength Responsive Grids 
(ESRG) and OpenACS's default theme from release 5.8

ESRG: http://dfcb.github.io/extra-strength-responsive-grids

Blending mainly consisted of adding the names of existing OpenACS css classes and id's to ESRG's css.
In order to achieve additional style consistency of allowing relative styles to be used repeatedly, 
id's from plain-master have been changed to classes.


installation
------------
Follow standard OpenACS package installation instructions.
Be sure to update subsite style parameters to use /lib/plain-master in this package.

