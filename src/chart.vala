/* chart.vala
 *
 * Copyright 2024 khaustovdn
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Graphin {
    public abstract class Chart : Gtk.DrawingArea, IChartDrawable {
        public Point center;
        public double scale;
        private IChartDrawable axis { get; default = new ChartAxis (); }
        private IChartDrawable grid { get; default = new ChartGrid (); }
        public ChartGestureHandler gesture_handler { get; construct; }
        public Gee.ArrayList<ChartSerie> series { get; construct; }

        construct {
            this.content_width = 360;
            this.content_height = 480;
            this.set_draw_func (draw);
            this.set_parameters (new Point (50.0, this.content_height - 50), 1.0);
            this.gesture_handler = new ChartGestureHandler (this);
            this.series = new Gee.ArrayList<ChartSerie> ();
        }

        public virtual void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            this.axis.set_parameters (this.center, this.scale);
            this.axis.draw (drawing_area, cairo, width, height);
            this.grid.set_parameters (this.center, this.scale);
            this.grid.draw (drawing_area, cairo, width, height);
        }

        public void set_parameters (Point center, double scale) {
            this.center = center;
            this.scale = scale;
        }
    }
}