<master>
<property name="context">{/doc/responsive-theme {responsive-theme}} {Responsive Theme Docs}</property>
<property name="doc(title)">Responsive Theme Documentation</property>

<h1>
Responsive Theme
</h1>
<h2>introduction
</h2>
<p>
This is a responsive theme package for OpenACS web app platform.
It's designed to make OpenACS sites viewable by most small device users as well as desktop users.
An emphasis is placed on using only css as defined by 
OpenACS' default theme, 
Estra Strength Responsive Grid, and
css styles released with openacs-core.
</p>
<h2>license
</h2>
<pre>
Copyright (c) 2015 Benjamin Brink

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
</pre>
<h2>
features
</h2>

<p>
This package is a blend of 
<a href="dfcb.github.io/extra-strength-responsive-grids">Extra Strength Responsive Grids</a> 
(ESRG) and OpenACS's default theme from release 5.8
</p>
<p>
Blending mainly consisted of adding the names of existing OpenACS css classes and id's to ESRG's css.
In order to achieve additional style consistency of allowing relative styles to be used repeatedly, 
id's from plain-master have been changed to classes.
</p>
<h2>
installation
</h2>
<p>
Follow standard OpenACS package installation instructions.
Update subsite style parameters:
</p>
<ul><li>
DefaultMaster value becomes /packages/b-responsive-theme/lib/plain-master
</li><li>
StreamingHead value becomes /packages/b-responsive-theme/lib/plain-streaming-head
</li><li>
ThemeCSS value becomes {{href /resources/b-responsive-theme/styles/default-master.css} {media all}}
</li></ul>

<p>
It is expected that ESRG and openacs-default-theme.css will change over time. 
To help maintain this package, originals used for blending are located in b-responsive-theme/www/doc/originals.
Use diff between originals and current files to identify changes that may need to be used to update this package.
</p>
